# Dockerfile

# Start from the official Kong Gateway image
FROM kong:3.4

# Ensure the command runs as root (optional, if needed)
USER root

# Install necessary OS dependencies using apt-get
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    libssl-dev \
    gcc \
    musl-dev \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install the kong-plugin-oidc plugin via LuaRocks
COPY kong-plugin-oidc-1.4.0-1.rockspec /tmp/
RUN luarocks install /tmp/kong-plugin-oidc-1.4.0-1.rockspec

# Set environment variables
ENV KONG_DATABASE=off
ENV KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yml
ENV KONG_PLUGINS=bundled,oidc

# Expose the necessary ports
EXPOSE 8000 8443 8001 8444

# Revert to default non-root user (if needed)
USER kong

# Start Kong
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kong", "docker-start"]
