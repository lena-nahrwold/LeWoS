# Dockerfile for headless LeWoS with MATLAB Runtime
FROM ubuntu:24.04

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

# Install MATLAB Runtime R2025a (v101)
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2025a/Release/0/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2025a_glnxa64.zip \
    && unzip MATLAB_Runtime_R2025a_glnxa64.zip -d /tmp/mcr-install \
    && /tmp/mcr-install/install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr \
    && rm -rf /tmp/mcr-install MATLAB_Runtime_R2025a_glnxa64.zip

ENV LD_LIBRARY_PATH=/opt/mcr/v101/runtime/glnxa64:/opt/mcr/v101/bin/glnxa64:/opt/mcr/v101/sys/os/glnxa64:/opt/mcr/v101/extern/bin/glnxa64:$LD_LIBRARY_PATH

# Set working directory
WORKDIR /app

# Copy compiled LeWoS CLI files into container
COPY LeWoSCLI /app/LeWoSCLI

# Make executable runnable
RUN chmod +x /app/LeWoSCLI

# Entry point
ENTRYPOINT ["/app/LeWoSCLI"]
