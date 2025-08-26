# Dockerfile for headless LeWoS with MATLAB Runtime
FROM ubuntu:24.04

# Install dependencies required by MATLAB Runtime
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libx11-6 \
    libxt6 \
    libxext6 \
    libxmu6 \
    libxrender1 \
    libxi6 \
    libglu1-mesa \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install MATLAB Runtime R2024a (v9.14)
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2024a/Release/0/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024a_glnxa64.zip \
    && unzip MATLAB_Runtime_R2024a_glnxa64.zip -d /tmp/mcr-install \
    && /tmp/mcr-install/install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr \
    && rm -rf /tmp/mcr-install MATLAB_Runtime_R2024a_glnxa64.zip

# Create app directory and copy compiled executable
WORKDIR /app
COPY LeWoSCLI /app/LeWoSCLI
COPY run_LeWoSCLI.sh /app/run_LeWoSCLI.sh

# Make sure the script is executable
RUN chmod +x /app/run_LeWoSCLI.sh
RUN chmod +x /app/LeWoSCLI

# Create input/output folders
RUN mkdir -p /app/data /app/output

# Default command
# Usage: docker run -v $(pwd)/data:/app/data -v $(pwd)/output:/app/output lewos-cli
CMD ["/app/run_LeWoSCLI.sh", "/opt/mcr/R2024a", "/app/data", "/app/output"]