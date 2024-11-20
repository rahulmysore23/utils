#!/bin/sh

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "You must run this script as root or using sudo."
  exit 1
fi

# Update system packages
echo "Updating package lists..."
apt update -y

# Install dependencies for Go, Node.js, and Rust
echo "Installing required dependencies..."
apt install -y \
  curl \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  pkg-config \
  git

# ===========================
# Install Go (Golang)
# ===========================
echo "Installing Go..."
GO_VERSION="1.21.3"
GO_TARBALL="go$GO_VERSION.linux-amd64.tar.gz"
GO_DOWNLOAD_URL="https://golang.org/dl/$GO_TARBALL"

# Download and install Go
curl -fsSL "$GO_DOWNLOAD_URL" -o "$GO_TARBALL"
tar -C /usr/local -xzf "$GO_TARBALL"
rm "$GO_TARBALL"

# Set up Go environment variables
echo "Setting up Go environment variables..."
echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
source /etc/profile

# Verify Go installation
echo "Verifying Go installation..."
go version

# ===========================
# Install Node.js (via NodeSource)
# ===========================
echo "Installing Node.js and npm..."

# Add NodeSource repository for Node.js (version 18.x, latest LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install Node.js (which includes npm)
apt install -y nodejs

# Verify Node.js and npm installation
echo "Verifying Node.js and npm installation..."
node -v
npm -v

# ===========================
# Install Rust (via rustup)
# ===========================
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Source Rust environment variables
echo "export PATH=\$HOME/.cargo/bin:\$PATH" >> /etc/profile
source /etc/profile

# Verify Rust installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

echo "Go, Node.js (npm), and Rust have been installed successfully!"