# Dockerfile for headless LeWoS with MATLAB Runtime
FROM ubuntu:24.04

# Install dependencies required by MATLAB Runtime
RUN apt-get update && apt-get install -y \
    wget unzip libx11-6 libxtst6 libxext6 libglib2.0-0 \
    libsm6 libxrender1 libfreetype6 libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Download and install MATLAB Runtime R2024a (v9.14)
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2024a/Release/0/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024a_glnxa64.zip \
    && unzip MATLAB_Runtime_R2024a_glnxa64.zip -d /tmp/mcr-install \
    && /tmp/mcr-install/install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr \
    && rm -rf /tmp/mcr-install MATLAB_Runtime_R2024a_glnxa64.zip

# Set MATLAB Runtime environment variables
ENV LD_LIBRARY_PATH=/opt/mcr/v914/runtime/glnxa64:/opt/mcr/v914/bin/glnxa64:/opt/mcr/v914/sys/os/glnxa64:/opt/mcr/v914/extern/bin/glnxa64:$LD_LIBRARY_PATH

# Create app directory and copy compiled executable
WORKDIR /app
COPY LeWoSCLI run_LeWoSCLI.sh ./

# Create input/output folders
RUN mkdir -p /app/data /app/output

# Default command
# Usage: docker run -v $(pwd)/data:/app/data -v $(pwd)/output:/app/output lewoscli
CMD ["./run_LeWoSCLI.sh", "/opt/mcr", "/app/data", "/app/output"]