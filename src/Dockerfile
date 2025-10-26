# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash app
USER app

# Expose the port that Cloud Run expects
EXPOSE 8080

# Set the PORT environment variable
ENV PORT=8080

# Define the command to run your Flask application with gunicorn
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
