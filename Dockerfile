# Dockerfile for headless LeWoS with MATLAB Runtime
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libxext6 \
    libx11-6 \
    libxtst6 \
    libxrandr2 \
    libfreetype6 \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy compiled LeWoS CLI files into container
COPY LeWoSCLI /app/LeWoSCLI
COPY for_redistribution_files /app/MCR

# Set MATLAB Runtime environment
ENV LD_LIBRARY_PATH=/app/MCR/v97/runtime/glnxa64:/app/MCR/v97/bin/glnxa64:/app/MCR/v97/sys/os/glnxa64:$LD_LIBRARY_PATH
ENV XAPPLRESDIR=/app/MCR/v97/X11/app-defaults

# Make executable runnable
RUN chmod +x /app/LeWoSCLI

# Entry point
ENTRYPOINT ["/app/LeWoSCLI"]
