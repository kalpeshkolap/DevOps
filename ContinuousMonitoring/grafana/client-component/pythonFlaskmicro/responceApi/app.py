import os
from flask import Flask, request
import requests
from opentelemetry import trace
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

app = Flask(__name__)

# Read the service A URL from the environment variable, with a default value
HELLO_SERVICE_URL = os.getenv('HELLO_SERVICE_URL', 'http://hello.server:8000/hello')

# Initialize OpenTelemetry tracer
resource = Resource(attributes={
    SERVICE_NAME: "hello-responce-server"
})
trace.set_tracer_provider(TracerProvider(resource=resource))
tracer = trace.get_tracer(__name__)

# Configure the OTLP exporter
otlp_exporter = OTLPSpanExporter(
    endpoint=os.getenv('OTEL_EXPORTER_OTLP_ENDPOINT', 'http://otel-opentelemetry-collector.server:4317'),
    insecure=True
)

# Add the span processor to the tracer
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# Instrument Flask app with OpenTelemetry
FlaskInstrumentor().instrument_app(app)

@app.route('/')
def call_service_a():
    with tracer.start_as_current_span("hello-request-server"):
        try:
            response = requests.get(HELLO_SERVICE_URL)
            return f"hello responce recieved: {response.text}", response.status_code
        except requests.exceptions.RequestException as e:
            return f"Service encountered an error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001)
