ARG GLEAM_VERSION=v1.13.0
  
  # Build stage - compile the application
FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-erlang-alpine AS builder
  
  # Install deps
RUN apk add curl \
&& apk add --update nodejs \
&& curl -L https://unpkg.com/@pnpm/self-installer | node
  
  # Add project code
COPY . /build/app
  
  # Install dependencies for all projects
RUN cd /build/app && gleam deps download
  
  # Compile the app code
RUN cd /build/app \
&& gleam export erlang-shipment
  
  # Runtime stage - slim image with only what's needed to run
FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-erlang-alpine
  
  # Copy the compiled app code from the builder stage
COPY --from=builder /build/app/build/erlang-shipment /app
  
  # Set up the entrypoint
WORKDIR /app
RUN echo -e '#!/bin/sh\nexec ./entrypoint.sh "$@"' > ./start.sh \
&& chmod +x ./start.sh
  
  # Set environment variables
  # DATABASE_URL env var should be provided to the container
ENV HOST=0.0.0.0
ENV PORT=8080
  
  # Expose the port the app will run on
EXPOSE $PORT
  
  # Run the app
CMD ["./start.sh", "run"]
