#!/bin/bash

## ALL INFORMATION CAN BE FOUND HERE: https://github.com/ChristianLempa/cheat-sheets/blob/main/misc/ssl-certs.md
## FOR A BREAKDOWN OF EACH COMMAND, I WOULD SUGGEST YOU WATCH THIS: https://www.youtube.com/watch?v=VH4gXcvkmOY
## I DID NOT CREATE THIS, I ONLY PUT ALL OF IT IN A BASH SCRIPT SO YOU CAN DO THIS FASTER THAN USING THE INDIVIDUAL COMMANDS

## DO NOT EDIT THIS FILE

read -p "Enter your certificate name: " CERTIFICATE_NAME
read -p "Enter your domain name: " DOMAIN_NAME

# Ensure that a Certificate name is provided, or choose a default name.
if [ -z "$CERTIFICATE_NAME" ]; then
    CERTIFICATE_NAME="default_certificate"
fi

# Ensure that a domain name is provided
if [ -z "$DOMAIN_NAME" ]; then
    echo "Error: Domain name not provided."
    exit 1
fi

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y openssl
fi

## Create CA certs
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca.pem

## Create RSA key
openssl genrsa -out cert-key.pem 4096
# Generate CSR key
openssl req -new -sha256 -subj "/CN=$CERTIFICATE_NAME" -key cert-key.pem -out cert.csr

echo "subjectAltName=DNS:*.$DOMAIN_NAME,IP:$(curl ipv4.icanhazip.com)" >> extfile.cnf

# Create the certificate:
openssl x509 -req -sha256 -days 365 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial

# Redirect users to the place of the cheatsheet,
# so that they can assign the certificates.
ls -l
echo "Go here to view how you can assign the certificates as trusted: https://github.com/ChristianLempa/cheat-sheets/blob/main/misc/ssl-certs.md"
