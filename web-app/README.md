# Secure Microservice Deployment - DevSecOps Assessment

## Overview

This project demonstrates a secure Node.js microservice deployment with MongoDB using Docker containers. The implementation follows DevSecOps best practices including container hardening, secrets management, and runtime security.

## Security Features Implemented

### 1. Docker Hardening
- **Minimal Base Image**: Uses Alpine Linux for smaller attack surface
- **Multi-stage Build**: Separates build and runtime environments
- **Non-root User**: Runs as `appuser` (UID 1001) with minimal privileges
- **Security Options**: 
  - `no-new-privileges` prevents privilege escalation
  - Dropped all capabilities, only added necessary ones
  - Read-only filesystem with specific tmpfs mounts

### 2. Container Security
- **Resource Limits**: CPU and memory constraints
- **Health Checks**: Proper application health monitoring
- **Logging Configuration**: Structured logging with rotation
- **Network Isolation**: Custom bridge network

### 3. Application Security
- **Helmet.js**: Security headers and CSP
- **Rate Limiting**: Protection against DDoS attacks
- **Input Validation**: Proper data sanitization
- **CORS Configuration**: Controlled cross-origin requests

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

## Quick Start

### 1. Clone and Setup
```bash
# Clone the repository
git clone <repository-url>
cd secure-microservice

# Initialize npm (if package-lock.json doesn't exist)
npm install  # This will generate package-lock.json

# Create secrets directory
mkdir -p secrets

# Generate MongoDB credentials
echo "admin" > secrets/mongo_root_username.txt
echo "$(openssl rand -base64 32)" > secrets/mongo_root_password.txt

# Set proper permissions
chmod 600 secrets/*
```

### 2. Build and Run
```bash
# Build and start services
docker-compose up --build -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f app
```

### 3. Test the Application
```bash
# Health check
curl http://localhost:3000/health

# Create an item
curl -X POST http://localhost:3000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Item", "description": "This is a test item"}'

# Get all items
curl http://localhost:3000/api/items
```

## Security Scanning

### Dockerfile Scanning with Trivy
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan Dockerfile
trivy config .

# Scan built image
docker build -t secure-app .
trivy image secure-app
```

### Container Scanning with Dockle
```bash
# Install Dockle
wget https://github.com/goodwithtech/dockle/releases/latest/download/dockle_Linux-64bit.tar.gz
tar zxvf dockle_Linux-64bit.tar.gz
sudo mv dockle /usr/local/bin

# Scan container
dockle secure-app
```

## Development Workflow

### Running in Development Mode
```bash
# Install dependencies
npm install

# Start in development mode
npm run dev

# Run security audit
npm run security:audit

# Run linting
npm run lint
```

### Testing Security
```bash
# Test rate limiting
for i in {1..110}; do curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000/health; done

# Test input validation
curl -X POST http://localhost:3000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name": "A".repeat(101)}'
```

## Production Considerations

### 1. Secrets Management
- Use external secrets management (HashiCorp Vault, AWS Secrets Manager)
- Implement secret rotation policies
- Use encrypted storage for sensitive data

### 2. Monitoring and Logging
- Implement centralized logging (ELK stack, Splunk)
- Set up monitoring and alerting (Prometheus, Grafana)
- Configure security event monitoring

### 3. Network Security
- Use TLS/SSL for all communications
- Implement network segmentation
- Configure firewall rules

### 4. Runtime Security
- Deploy with container runtime security tools (Falco)
- Implement admission controllers (OPA Gatekeeper)
- Use security policies (Pod Security Standards)

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   ```bash
   # Check user in container
   docker exec -it secure-web-app whoami
   
   # Verify file permissions
   docker exec -it secure-web-app ls -la /app
   ```

2. **Database Connection Issues**
   ```bash
   # Check MongoDB logs
   docker-compose logs mongodb
   
   # Test connectivity
   docker exec -it secure-web-app nc -zv mongodb 27017
   ```

3. **Secret File Errors**
   ```bash
   # Verify secrets exist
   ls -la secrets/
   
   # Check file permissions
   stat secrets/mongo_root_password.txt
   ```

## Security Checklist

- [ ] Container runs as non-root user (appuser)
- [ ] Minimal base image used (Alpine)
- [ ] Multi-stage build implemented
- [ ] No secrets in Docker layers
- [ ] Security capabilities dropped
- [ ] Resource limits configured
- [ ] Health checks implemented
- [ ] Logging configured
- [ ] Network isolation enabled
- [ ] Input validation implemented
- [ ] Security headers configured
- [ ] Rate limiting enabled

## Cleanup

```bash
# Stop and remove containers
docker-compose down -v

# Remove images
docker rmi $(docker images -q secure-microservice_app)

# Clean up secrets
rm -rf secrets/
```

## Next Steps

1. **CI/CD Integration**: Implement GitHub Actions or GitLab CI
2. **Infrastructure as Code**: Add Terraform configurations
3. **Kubernetes Deployment**: Create Helm charts
4. **Runtime Security**: Implement Falco rules
5. **Compliance**: Add CIS benchmarks compliance