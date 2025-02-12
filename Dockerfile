FROM odoo:17

# Switch to root to create necessary directories
USER root

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Odoo (but allow overrides at runtime)
ENV DB_HOST=${DB_HOST:-db} \
    DB_PORT=${DB_PORT:-5432} \
    DB_USER=${DB_USER:-odoo17} \
    DB_PASSWORD=${DB_PASSWORD:-DB_PASSWORD}


# Ensure the target directories exist with correct ownership
RUN mkdir -p /mnt/enterprise /mnt/customs && chown -R odoo:odoo /mnt/enterprise /mnt/customs

# Switch back to Odoo user
USER odoo

# Copy the Odoo Enterprise files
COPY --chown=odoo:odoo ./enterprise /mnt/enterprise

# Copy the customs folder into the container
COPY --chown=odoo:odoo ./customs /mnt/customs

# Ensure correct permissions
RUN chmod -R 755 /mnt/enterprise /mnt/customs

EXPOSE 8069
CMD ["odoo"]
