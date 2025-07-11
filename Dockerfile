# Ubuntu 22.04 Image.
FROM ubuntu:22.04

# Set Environmental Variable
ENV PROM_VERSION=2.53.5

# Install dependencies
RUN apt-get update -y && \
        apt-get install -y wget tar curl && \
        useradd -r -s /sbin/nologin prometheus

# Download Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz && \
        tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz && \
        mkdir -p /opt/prometheus/data && \
        chmod +x /opt/prometheus && \
        chown prometheus:prometheus /opt/prometheus/data && \
        mv prometheus-${PROM_VERSION}.linux-amd64/* /opt/prometheus/ && \
        rm prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Copy config
COPY prometheus.yml /opt/prometheus/prometheus.yml

# set user and export port 9090
USER prometheus
EXPOSE 9090

# Set working directory and start command
WORKDIR /opt/prometheus
CMD ["./prometheus", "--config.file=prometheus.yml"]