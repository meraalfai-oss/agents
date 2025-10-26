# YMERA Production Deployment Guide

This guide covers deploying the YMERA Multi-Agent AI System in a production environment using Docker Compose.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Security Considerations](#security-considerations)
- [SSL/TLS Setup](#ssltls-setup)
- [Monitoring](#monitoring)
- [Backup & Recovery](#backup--recovery)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

Before deploying, ensure you have:

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 2.0 or higher)
- **Domain name** (for production SSL/TLS)
- **SSL certificates** (Let's Encrypt recommended)
- **Minimum server specs:**
  - 4 CPU cores
  - 8 GB RAM
  - 50 GB storage
  - Ubuntu 20.04 LTS or higher (recommended)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/meraalfai-oss/agents.git
cd agents
```

### 2. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your production values
nano .env
```

**Critical values to change:**
- `POSTGRES_PASSWORD` - Strong database password
- `REDIS_PASSWORD` - Strong Redis password
- `SECRET_KEY` - Generate with: `python -c "import secrets; print(secrets.token_urlsafe(64))"`
- `ALLOWED_ORIGINS` - Your domain(s)
- `CORS_ORIGINS` - Your domain(s)

### 3. Create Required Directories

```bash
# Create directory for SSL certificates (if using HTTPS)
mkdir -p certs

# Set proper permissions
chmod 700 certs
```

### 4. Deploy with Docker Compose

```bash
# Pull the latest images
docker-compose -f docker-compose.prod.yml pull

# Build and start services
docker-compose -f docker-compose.prod.yml up -d

# Check service status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```

### 5. Verify Deployment

```bash
# Check health endpoint
curl http://localhost/health

# Check API health
curl http://localhost/api/v1/health
```

## ⚙️ Configuration

### Environment Variables

The `.env.example` file contains all configurable options. Key categories:

#### Database Configuration
```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=ymera
DATABASE_POOL_SIZE=10
```

#### Redis Configuration
```env
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
```

#### Security Settings
```env
SECRET_KEY=your_64_char_random_secret
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

#### CORS & Origins
```env
ALLOWED_ORIGINS=https://yourdomain.com
CORS_ORIGINS=https://yourdomain.com
```

### Nginx Configuration

The `nginx.conf` file includes:
- Reverse proxy configuration
- WebSocket support
- Rate limiting
- Security headers
- Gzip compression
- SSL/TLS ready (commented out)

Modify `nginx.conf` for:
- Custom rate limits
- Different backend routing
- Additional security headers

## 🔒 Security Considerations

### 1. Change Default Credentials

**Critical:** Never use default passwords in production!

```bash
# Generate strong passwords
openssl rand -base64 32  # For POSTGRES_PASSWORD
openssl rand -base64 32  # For REDIS_PASSWORD
python -c "import secrets; print(secrets.token_urlsafe(64))"  # For SECRET_KEY
```

### 2. Enable Firewall

```bash
# Allow only necessary ports
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 3. Security Headers

The nginx configuration includes security headers:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

### 4. Rate Limiting

Pre-configured rate limits:
- API endpoints: 10 requests/second (burst: 20)
- General endpoints: 50 requests/second (burst: 100)

Adjust in `nginx.conf` as needed.

### 5. Network Isolation

Services communicate via internal `ymera-network`:
- Only nginx-proxy exposes ports 80/443
- Database and Redis are not directly accessible
- Inter-service communication is isolated

## 🔐 SSL/TLS Setup

### Option 1: Let's Encrypt (Recommended)

```bash
# Install certbot
sudo apt-get update
sudo apt-get install certbot

# Generate certificate
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Copy certificates
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem certs/cert.pem
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem certs/key.pem
sudo chown -R $(whoami):$(whoami) certs/
```

### Option 2: Self-Signed (Development/Testing)

```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/key.pem \
  -out certs/cert.pem \
  -subj "/CN=localhost"
```

### Enable HTTPS in Nginx

1. Uncomment the HTTPS server block in `nginx.conf`
2. Update certificate paths if needed
3. Restart nginx:

```bash
docker-compose -f docker-compose.prod.yml restart nginx-proxy
```

## 📊 Monitoring

### Health Checks

All services include health checks:

```bash
# Check all services
docker-compose -f docker-compose.prod.yml ps

# Check specific service logs
docker-compose -f docker-compose.prod.yml logs ymera-api
docker-compose -f docker-compose.prod.yml logs postgres
```

### Prometheus Metrics

Prometheus is integrated for metrics collection:

```bash
# Access Prometheus (if exposed)
# Add to docker-compose.prod.yml if needed:
#   prometheus:
#     image: prom/prometheus:latest
#     ports:
#       - "9090:9090"
#     volumes:
#       - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

### Grafana Dashboards

Add Grafana for visualization:

```yaml
# Add to docker-compose.prod.yml
grafana:
  image: grafana/grafana:latest
  ports:
    - "3001:3000"
  environment:
    - GF_SECURITY_ADMIN_PASSWORD=your_grafana_password
  volumes:
    - grafana_data:/var/lib/grafana
```

## 💾 Backup & Recovery

### Database Backup

```bash
# Backup PostgreSQL database
docker-compose -f docker-compose.prod.yml exec postgres \
  pg_dump -U postgres ymera > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore database
cat backup_20240126_120000.sql | \
  docker-compose -f docker-compose.prod.yml exec -T postgres \
  psql -U postgres ymera
```

### Volume Backup

```bash
# Stop services
docker-compose -f docker-compose.prod.yml down

# Backup volumes
docker run --rm \
  -v ymera_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres_data_backup.tar.gz -C /data .

# Restore volumes
docker run --rm \
  -v ymera_postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres_data_backup.tar.gz -C /data
```

### Automated Backups

Create a backup script (`backup.sh`):

```bash
#!/bin/bash
BACKUP_DIR="/backup/ymera"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup database
docker-compose -f docker-compose.prod.yml exec -T postgres \
  pg_dump -U postgres ymera > "$BACKUP_DIR/db_$DATE.sql"

# Compress old backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -exec gzip {} \;

# Remove backups older than 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete
```

Schedule with cron:
```bash
# Run daily at 2 AM
0 2 * * * /path/to/backup.sh
```

## 🔍 Troubleshooting

### Service Won't Start

```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs [service-name]

# Check service status
docker-compose -f docker-compose.prod.yml ps

# Restart specific service
docker-compose -f docker-compose.prod.yml restart [service-name]
```

### Database Connection Issues

```bash
# Test database connection
docker-compose -f docker-compose.prod.yml exec postgres \
  psql -U postgres -d ymera -c "SELECT version();"

# Check database logs
docker-compose -f docker-compose.prod.yml logs postgres
```

### Redis Connection Issues

```bash
# Test Redis connection
docker-compose -f docker-compose.prod.yml exec redis redis-cli ping

# Check Redis logs
docker-compose -f docker-compose.prod.yml logs redis
```

### Nginx Configuration Issues

```bash
# Test nginx configuration
docker-compose -f docker-compose.prod.yml exec nginx-proxy nginx -t

# Reload nginx configuration
docker-compose -f docker-compose.prod.yml exec nginx-proxy nginx -s reload

# Check nginx logs
docker-compose -f docker-compose.prod.yml logs nginx-proxy
```

### Performance Issues

```bash
# Check resource usage
docker stats

# Check service resource limits
docker-compose -f docker-compose.prod.yml exec ymera-api top

# Review nginx access logs for slow requests
docker-compose -f docker-compose.prod.yml logs nginx-proxy | grep "rt="
```

### Cleaning Up

```bash
# Stop all services
docker-compose -f docker-compose.prod.yml down

# Remove volumes (WARNING: deletes data)
docker-compose -f docker-compose.prod.yml down -v

# Remove unused images
docker system prune -a
```

## 📝 Maintenance

### Update Services

```bash
# Pull latest images
docker-compose -f docker-compose.prod.yml pull

# Rebuild services
docker-compose -f docker-compose.prod.yml build --no-cache

# Restart with new images
docker-compose -f docker-compose.prod.yml up -d
```

### View Service Logs

```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f ymera-api

# Last 100 lines
docker-compose -f docker-compose.prod.yml logs --tail=100 ymera-api
```

### Scale Services (if needed)

```bash
# Scale API service
docker-compose -f docker-compose.prod.yml up -d --scale ymera-api=3
```

## 🆘 Support

For issues or questions:
- GitHub Issues: https://github.com/meraalfai-oss/agents/issues
- Documentation: See other docs in this repository
- Email: support@yourdomain.com

## 📄 License

See LICENSE file in the repository root.

---

**Production Checklist:**

- [ ] Changed all default passwords
- [ ] Generated strong SECRET_KEY
- [ ] Configured domain and CORS origins
- [ ] Set up SSL/TLS certificates
- [ ] Configured firewall rules
- [ ] Set up automated backups
- [ ] Tested health endpoints
- [ ] Configured monitoring
- [ ] Reviewed nginx rate limits
- [ ] Set up log rotation
- [ ] Documented custom configurations
- [ ] Tested disaster recovery procedures
