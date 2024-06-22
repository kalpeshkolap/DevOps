import os
from flask import Flask
from opentelemetry import trace
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

# Initialize Flask app
app = Flask(__name__)

# Initialize OpenTelemetry tracer
resource = Resource(attributes={
    SERVICE_NAME: "hello-request-server"
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

# Define a route
@app.route('/hello')
def hello_world():
    with tracer.start_as_current_span("helloapi"):
        return 'Hello, World!'

# Run the Flask app on port 8000 and host 0.0.0.0
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
