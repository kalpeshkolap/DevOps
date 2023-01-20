FROM python:3.9

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy requirements file
COPY requirements.txt .

# Install app dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source code
COPY . .

# Expose port
EXPOSE 5000

# Start app
CMD [ "python", "app.py" ]

# Install Microsoft SQL Server drivers
RUN apt-get update && \
    apt-get install -y apt-transport-https gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17

