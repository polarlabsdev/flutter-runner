# Flutter Web Docker Image

A custom Docker image specifically designed for building and deploying Flutter web applications. This image addresses common issues found in existing Flutter Docker images by providing a more reliable and stable environment for building Flutter web projects.

## Overview

This repository contains the necessary configurations to build and maintain a Docker image with Flutter SDK and web-specific tools pre-installed. The image is specifically designed to work with Bitbucket Pipelines and is hosted on DigitalOcean's private registry.

> **Note**: This image is optimized for Flutter web deployments only. For mobile (iOS/Android) builds, please use dedicated CI/CD tools and their respective native environments.

## Why This Image?

- Existing Flutter Docker images often have compatibility issues or outdated dependencies
- Optimized specifically for web builds, reducing image size and complexity
- Provides a consistent environment for web deployment pipelines
- Regularly updated with the latest Flutter SDK versions

## Prerequisites

- Access to our DigitalOcean registry
- DigitalOcean API token with read access
- Bitbucket pipeline environment variables configured

## Using the Image

### Pulling the Image

To pull the image from our private DigitalOcean registry:

Set your DigitalOcean access token for `doctl`, use the following command:

```bash
# Login to DigitalOcean registry
doctl auth init
```

You will be prompted to enter your DigitalOcean API token. Once authenticated, you can proceed to log in to the registry:

```bash
doctl registry login

# Pull the image
docker pull registry.digitalocean.com/<your-registry>/<repo>:<tag>
```

## Updating Flutter Version

To update the Flutter SDK version in the image:

1. Access your Bitbucket repository settings
2. Navigate to Repository Variables
3. Update the following variables as needed:
   - `FLUTTER_VERSION`
   - `IMAGE_TAG_NAME`
4. Manually trigger the pipeline to build and push the new image

## Integration Tips

Example `bitbucket-pipelines.yml` configuration for web builds:

```yaml
image:
  name: registry.digitalocean.com/<your-registry>/<repo>:<tag>
  username: $DIGITALOCEAN_ACCESS_TOKEN
  password: $DIGITALOCEAN_ACCESS_TOKEN

pipelines:
  default:
    - step:
        name: Build Web
        script:
          - flutter pub get
          - flutter build web
```

Example `Dockerfile` configuration for web builds:

```dockerfile
FROM registry.digitalocean.com/<your-registry>/<repo>:<tag>

USER flutter
WORKDIR /home/flutter/app

COPY --chown=flutter:flutter . .

RUN flutter pub get
RUN flutter build web
```

## Important Notes

- This image is specifically optimized for web builds only
- Always specify the image tag when pulling to ensure consistency
- The `flutter` user has the necessary permissions pre-configured
- Environment variables and workspace directories are set up for the `flutter` user
- The image includes web-specific development tools and dependencies

## Troubleshooting

If you encounter permission issues:
```bash
# Verify you're running as flutter user
whoami

# Check flutter installation and web support
flutter doctor
flutter config --enable-web

# Verify workspace permissions
ls -la
```

## Common Web Build Issues

- Memory limits: See documentation for setting appropriate Dart VM options
- CORS configuration: Ensure proper setup for web deployments
- Asset loading: Verify base-href settings for production deployments