#!/bin/bash

# Build and Deploy Script for Cloud Run
set -e

# Configuration
PROJECT_ID="proj-b-475817"
REGION="us-central1"
REPOSITORY="meu-repo"
SERVICE_NAME="app1"
IMAGE_TAG="latest"

# Full image URL
IMAGE_URL="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$SERVICE_NAME:$IMAGE_TAG"

echo "🚀 Building and deploying $SERVICE_NAME to Cloud Run..."

# Step 1: Build the Docker image
echo "📦 Building Docker image..."
cd src
docker build -t $IMAGE_URL .

# Step 2: Push to Artifact Registry
echo "📤 Pushing to Artifact Registry..."
docker push $IMAGE_URL

# Step 3: Get the URL of the deployed service
echo "✅ Deployment completed!"
echo "🌐 Service URL: https://$SERVICE_NAME-$REGION.a.run.app"