# Use Rust base image
FROM rust:1.70

# Set working directory
WORKDIR /app

# Install Doppler CLI and other dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg && \
    curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" > /etc/apt/sources.list.d/doppler-cli.list && \
    apt-get update && \
    apt-get install -y doppler && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Rust-related dependencies
RUN cargo install cargo-nextest --locked && \
    cargo install cargo-tarpaulin && \
    cargo install sqlx-cli --no-default-features --features rustls,postgres

# Set the default shell
CMD ["/bin/bash"]
