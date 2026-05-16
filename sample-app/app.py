import random
import time

from fastapi import FastAPI, HTTPException
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from prometheus_fastapi_instrumentator import Instrumentator

resource = Resource.create({"service.name": "sample-api"})
provider = TracerProvider(resource=resource)
provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter()))
trace.set_tracer_provider(provider)
tracer = trace.get_tracer(__name__)

app = FastAPI(title="sample-api")
FastAPIInstrumentor.instrument_app(app)
Instrumentator().instrument(app).expose(app, include_in_schema=False)


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


@app.get("/work")
def work(fail: bool = False, slow: bool = False):
    with tracer.start_as_current_span("work-handler") as span:
        latency = random.uniform(0.05, 0.2)
        if slow:
            latency = random.uniform(0.8, 1.3)
        time.sleep(latency)
        span.set_attribute("work.latency_seconds", latency)

        if fail:
            span.set_attribute("work.failed", True)
            raise HTTPException(status_code=500, detail="synthetic failure")

        return {"ok": True, "latency": latency}
