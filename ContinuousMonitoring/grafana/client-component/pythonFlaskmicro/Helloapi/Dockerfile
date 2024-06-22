# Step 1: Use an Alpine-based Python image
FROM python:3.11-alpine

# Step 2: Set environment variables
ENV PYTHONUNBUFFERED=1

# Step 3: Create a working directory
WORKDIR /app

# Step 4: Install build dependencies
RUN apk update && apk add --no-cache gcc musl-dev libffi-dev

# Step 5: Copy requirements.txt and install Python dependencies
COPY requirements.txt /app
RUN pip install -r requirements.txt

# Step 6: Copy the application code
COPY . /app

# Step 7: Expose the required port
EXPOSE 8000

# Step 8: Run the Flask application
CMD ["python", "app.py"]
