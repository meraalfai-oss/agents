#!/bin/bash

# YMERA Production Deployment Script
# This script helps deploy the YMERA system in production

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_warning "Running as root. Consider using a non-root user with sudo privileges."
fi

echo "========================================"
echo "YMERA Production Deployment Script"
echo "========================================"
echo ""

# Check prerequisites
print_info "Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi
print_success "Docker is installed: $(docker --version)"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
print_success "Docker Compose is installed"

# Check if .env file exists
if [ ! -f .env ]; then
    print_warning ".env file not found"
    read -p "Would you like to create one from .env.example? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp .env.example .env
        print_success ".env file created from .env.example"
        print_warning "IMPORTANT: Edit .env file and change default passwords before deploying!"
        read -p "Press Enter to open .env in editor (or Ctrl+C to exit)..."
        ${EDITOR:-nano} .env
    else
        print_error "Cannot proceed without .env file"
        exit 1
    fi
fi

# Validate critical environment variables
print_info "Validating environment variables..."
source .env

if [ "$POSTGRES_PASSWORD" = "CHANGE_THIS_PASSWORD_IN_PRODUCTION" ]; then
    print_error "POSTGRES_PASSWORD is still set to default! Please update .env file."
    exit 1
fi

if [ "$SECRET_KEY" = "CHANGE_THIS_TO_A_STRONG_RANDOM_SECRET_KEY_IN_PRODUCTION" ]; then
    print_error "SECRET_KEY is still set to default! Please update .env file."
    exit 1
fi

if [ "$REDIS_PASSWORD" = "CHANGE_THIS_REDIS_PASSWORD_IN_PRODUCTION" ]; then
    print_error "REDIS_PASSWORD is still set to default! Please update .env file."
    exit 1
fi

print_success "Environment variables validated"

# Create necessary directories
print_info "Creating required directories..."
mkdir -p certs logs
chmod 700 certs
print_success "Directories created"

# Check for SSL certificates
if [ ! -f certs/cert.pem ] || [ ! -f certs/key.pem ]; then
    print_warning "SSL certificates not found in certs/ directory"
    print_info "You can:"
    print_info "  1. Use Let's Encrypt: sudo certbot certonly --standalone -d yourdomain.com"
    print_info "  2. Generate self-signed: openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/key.pem -out certs/cert.pem"
    print_info "For now, system will run on HTTP only"
fi

# Display deployment plan
echo ""
echo "========================================"
echo "Deployment Plan"
echo "========================================"
echo "Environment: $ENVIRONMENT"
echo "Services to deploy:"
echo "  - PostgreSQL 16.2"
echo "  - Redis 7.2"
echo "  - NATS 2.10.7"
echo "  - YMERA API"
echo "  - Frontend"
echo "  - Nginx Proxy (HTTP/HTTPS)"
echo "========================================"
echo ""

read -p "Proceed with deployment? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Deployment cancelled"
    exit 0
fi

# Pull latest images
print_info "Pulling latest Docker images..."
docker-compose -f docker-compose.prod.yml pull

# Build services
print_info "Building services..."
docker-compose -f docker-compose.prod.yml build --no-cache

# Start services
print_info "Starting services..."
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be healthy
print_info "Waiting for services to be healthy..."
sleep 10

# Check service health
print_info "Checking service health..."
RETRIES=30
WAIT_TIME=5

for i in $(seq 1 $RETRIES); do
    if docker-compose -f docker-compose.prod.yml ps | grep -q "unhealthy"; then
        print_warning "Some services are still starting... (attempt $i/$RETRIES)"
        sleep $WAIT_TIME
    else
        break
    fi
    
    if [ $i -eq $RETRIES ]; then
        print_error "Services failed to become healthy"
        print_info "Check logs with: docker-compose -f docker-compose.prod.yml logs"
        exit 1
    fi
done

# Display service status
echo ""
echo "========================================"
echo "Service Status"
echo "========================================"
docker-compose -f docker-compose.prod.yml ps

# Test health endpoints
echo ""
print_info "Testing health endpoints..."

# Test main health endpoint
if curl -f -s http://localhost/health > /dev/null 2>&1; then
    print_success "Main health endpoint: ✓"
else
    print_warning "Main health endpoint: ✗"
fi

# Test API health endpoint
if curl -f -s http://localhost/api/v1/health > /dev/null 2>&1; then
    print_success "API health endpoint: ✓"
else
    print_warning "API health endpoint: ✗"
fi

# Display access information
echo ""
echo "========================================"
echo "Deployment Complete!"
echo "========================================"
print_success "YMERA system is now running"
echo ""
echo "Access URLs:"
echo "  - Frontend: http://localhost"
echo "  - API: http://localhost/api/v1"
echo "  - API Docs: http://localhost/api/v1/docs (if enabled)"
echo ""
echo "Useful commands:"
echo "  - View logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "  - Stop services: docker-compose -f docker-compose.prod.yml down"
echo "  - Restart: docker-compose -f docker-compose.prod.yml restart"
echo "  - Service status: docker-compose -f docker-compose.prod.yml ps"
echo ""
print_warning "Remember to:"
echo "  - Configure SSL/TLS certificates for production"
echo "  - Set up firewall rules"
echo "  - Configure automated backups"
echo "  - Set up monitoring and alerts"
echo ""
echo "See PRODUCTION_DEPLOYMENT.md for detailed documentation"
echo "========================================"
