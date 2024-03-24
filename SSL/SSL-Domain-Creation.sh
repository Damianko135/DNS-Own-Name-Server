#!/bin/bash

# Prompt the user for the domain name
read -p "Enter your domain name: " DOMAIN

# Ensure that a domain name is provided
if [ -z "$DOMAIN" ]; then
    echo "Error: Domain name not provided."
    exit 1
fi

# Update package repositories and install OpenSSL
sudo apt-get update
sudo apt-get install -y openssl

# Generate SSL certificate and key
openssl genrsa -out "$DOMAIN.key" 2048
openssl req -new -key "$DOMAIN.key" -out "$DOMAIN.csr" -subj "/CN=$DOMAIN"
openssl x509 -req -days 365 -in "$DOMAIN.csr" -signkey "$DOMAIN.key" -out "$DOMAIN.crt"

# Display generated certificate files
echo "SSL certificate and key generated successfully for $DOMAIN."
echo "Generated files:"
ls -l "$DOMAIN.key" "$DOMAIN.crt" "$DOMAIN.csr"
