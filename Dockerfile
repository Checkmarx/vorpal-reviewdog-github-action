# Build Reviewdog executable using Alpine
FROM alpine:latest AS build-reviewdog

ENV REVIEWDOG_VERSION=v0.20.1

# Install necessary packages and Reviewdog
RUN apk --no-cache add curl bash \
    && curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin ${REVIEWDOG_VERSION}

# Base Image with Vorpal CLI
FROM checkmarx/vorpal-cli:1.0.116 AS build-vorpal

# Set the working directory
WORKDIR /app/bin

# Copy the Reviewdog executable from the builder stage
COPY --from=build-reviewdog /usr/local/bin/reviewdog /usr/local/bin/reviewdog

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make sure the binaries and the entrypoint script have execution permissions
RUN chmod +x /app/bin/vorpal /usr/local/bin/reviewdog /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]