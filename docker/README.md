# AzerothCore Docker Testing Environment

This directory contains Docker configuration for testing the AzerothCore installation script.

## Quick Start

### Build and Run

```bash
# Build the Docker image
docker-compose build

# Start in interactive mode (default)
docker-compose up -d

# View logs
docker-compose logs -f

# Access the container
docker-compose exec azerothcore /bin/bash
```

### Installation Inside Container

Once inside the container, you can run the installation:

```bash
# Option 1: Use the entrypoint
/docker-entrypoint.sh install

# Option 2: Use the install script directly
install-azerothcore

# Option 3: Run interactive menu
install-azerothcore
# Then select your options
```

### Start/Stop Servers

```bash
# Start servers
docker-compose exec azerothcore /docker-entrypoint.sh start

# Or attach to running container and use aliases
docker-compose exec azerothcore /bin/bash
start    # Start servers
wow      # Attach to world server
stop     # Stop servers
```

## Docker Commands Reference

```bash
# Build image
docker-compose build

# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Remove volumes (WARNING: deletes all data)
docker-compose down -v

# Access shell
docker-compose exec azerothcore /bin/bash

# Check status
docker-compose ps

# Scale (not applicable for single server, but useful for reference)
docker-compose up -d --scale azerothcore=1
```

## Testing the Installation Script

The primary purpose of this Docker setup is to test the `install.sh` script:

1. **Test Module Selection**
   ```bash
   docker-compose exec azerothcore install-azerothcore
   # Navigate through module selection menu
   ```

2. **Test Build Options**
   - Server type selection
   - Bot count configuration
   - Cross-faction settings

3. **Test Docker Installation Path**
   ```bash
   install-azerothcore --docker
   ```

## Volume Persistence

Data is persisted in named volumes:
- `azerothcore-data`: Compiled binaries and client data
- `azerothcore-etc`: Configuration files
- `azerothcore-modules`: Installed modules
- `azerothcore-db`: MariaDB database files

## Port Mapping

- **3724**: Auth server (TCP)
- **8085**: World server (TCP)
- **3306**: MySQL/MariaDB (optional)

## Troubleshooting

### Container keeps restarting
```bash
# Check logs
docker-compose logs --tail=100

# Check health status
docker-compose ps
```

### Compilation fails
```bash
# Increase Docker memory limit (Docker Desktop settings)
# Or adjust deploy.resources in docker-compose.yml

# Clean and rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### Database connection issues
```bash
# Check MariaDB status
docker-compose exec azerothcore mysqladmin -u root status

# Reset database
docker-compose exec azerothcore mysql -u root -e "DROP DATABASE IF EXISTS acore_world; DROP DATABASE IF EXISTS acore_characters; DROP DATABASE IF EXISTS acore_auth;"
```

### Want to start fresh?
```bash
docker-compose down -v
docker-compose up -d
```

## Customization

### Custom Configs
Uncomment the volume mount in docker-compose.yml:
```yaml
volumes:
  - ./custom-configs:/azerothcore/custom-configs:ro
```

Then place your custom .conf files in `custom-configs/` directory.

### Environment Variables
Edit `docker-compose.yml` to change:
- `REALM_NAME`: Your server's name
- `ACORE_USER`/`ACORE_PASS`: Database credentials
- `SERVER_IP`: Bind address

### Resource Limits
Adjust in `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: '4'      # Increase for faster compilation
      memory: 8G     # Increase for more bots
```

## CI/CD Testing

This Docker setup can be used for automated testing:

```bash
#!/bin/bash
# test-install.sh

# Build
docker-compose build || exit 1

# Start
docker-compose up -d || exit 1

# Wait for MariaDB
sleep 10

# Test installation
docker-compose exec -T azerothcore /docker-entrypoint.sh install || exit 1

# Verify binaries exist
docker-compose exec azerothcore test -f /azerothcore/env/dist/bin/worldserver || exit 1
docker-compose exec azerothcore test -f /azerothcore/env/dist/bin/authserver || exit 1

# Start servers
docker-compose exec -T azerothcore /docker-entrypoint.sh start &

# Wait for startup
sleep 30

# Check if running
docker-compose exec azerothcore pgrep worldserver || exit 1
docker-compose exec azerothcore pgrep authserver || exit 1

echo "All tests passed!"
```

## Notes

- First startup will take 15-45 minutes due to compilation
- Client data download adds additional time
- Database is created on first run
- Configuration files are copied from .dist versions

## See Also

- [Main README](../README.md)
- [Installation Guide](../build.txt)
- [AzerothCore Wiki](https://www.azerothcore.org/wiki/)
