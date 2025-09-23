# Docker Insulated Development Environment

This provides insulated Docker containers for building and testing without using your MacBook Pro for heavy processing.

## 🎯 **Why Docker?**

- **Insulated Environment** - No impact on your MacBook Pro
- **Consistent Environment** - Same setup across all devices
- **Isolated Dependencies** - No conflicts with host system
- **Easy Cleanup** - Remove containers when done
- **Resource Control** - Limit CPU and memory usage
- **Cross-Platform** - Works on any device with Docker

## 🐳 **Available Environments**

### **1. Main Development Environment**
- **Purpose**: General development work
- **Tools**: Node.js, Python, Neovim, Git, development tools
- **Ports**: 3000, 3001, 4000, 5000, 8000, 8080, 9000
- **Use Case**: Next.js, React, Vue, Angular development

### **2. SFCC Development Environment**
- **Purpose**: Salesforce Commerce Cloud development
- **Tools**: Node.js 14, dwupload, Java 11, SFCC SDK
- **Ports**: 9000
- **Use Case**: SFCC cartridge development and testing

### **3. AI/ML Development Environment**
- **Purpose**: AI engineering and machine learning
- **Tools**: Python, Jupyter, TensorFlow, PyTorch, OpenAI
- **Ports**: 8000 (Jupyter), 5000 (Flask/FastAPI)
- **Use Case**: AI model development, data science

### **4. Data Visualization Environment**
- **Purpose**: Data science and visualization
- **Tools**: Python, Jupyter, Streamlit, Plotly, financial data tools
- **Ports**: 8000 (Jupyter), 5000 (Streamlit)
- **Use Case**: Data analysis, trading algorithms, visualization

## 🚀 **Quick Start**

### **1. Build All Environments**
```bash
# Build all Docker environments
./scripts/docker-manager.sh build
```

### **2. Start Development Environment**
```bash
# Start main development environment
./scripts/docker-manager.sh start-dev

# Access the container
docker exec -it universal-dev-env bash
```

### **3. Start Specialized Environments**
```bash
# SFCC development
./scripts/docker-manager.sh start-sfcc
docker exec -it sfcc-dev-env bash

# AI/ML development
./scripts/docker-manager.sh start-ai
docker exec -it ai-dev-env bash
# Jupyter Lab: http://localhost:8000

# Data visualization
./scripts/docker-manager.sh start-data
docker exec -it data-viz-env bash
# Jupyter Lab: http://localhost:8000
```

## 🔧 **Docker Management**

### **Build Environments**
```bash
# Build all environments
./scripts/docker-manager.sh build

# Build specific environment
cd docker
docker build -t universal-dev-env .
docker build -f Dockerfile.sfcc -t sfcc-dev-env .
docker build -f Dockerfile.ai -t ai-dev-env .
docker build -f Dockerfile.data -t data-viz-env .
```

### **Start/Stop Environments**
```bash
# Start all environments
cd docker
docker-compose up -d

# Start specific environment
docker-compose up -d dev-env
docker-compose up -d sfcc-dev
docker-compose up -d ai-dev
docker-compose up -d data-viz

# Stop all environments
./scripts/docker-manager.sh stop
```

### **Environment Status**
```bash
# Show running containers
./scripts/docker-manager.sh status

# Show Docker disk usage
docker system df
```

### **Cleanup**
```bash
# Clean up Docker resources
./scripts/docker-manager.sh cleanup

# Remove all containers and images
docker system prune -a
```

## 📁 **Directory Structure**

```
docker/
├── Dockerfile              # Main development environment
├── Dockerfile.sfcc        # SFCC development environment
├── Dockerfile.ai          # AI/ML development environment
├── Dockerfile.data        # Data visualization environment
├── docker-compose.yml     # Multi-container setup
└── workspace/             # Shared workspace
    ├── dev/               # Main development workspace
    ├── sfcc/              # SFCC development workspace
    ├── ai/                # AI/ML development workspace
    └── data/              # Data visualization workspace
```

## 🛠️ **Development Workflows**

### **SFCC Development**
```bash
# Start SFCC environment
./scripts/docker-manager.sh start-sfcc

# Access container
docker exec -it sfcc-dev-env bash

# Inside container
./scripts/sfcc-dev.sh setup
./scripts/sfcc-dev.sh start
./scripts/sfcc-dev.sh clean-upload
```

### **AI/ML Development**
```bash
# Start AI environment
./scripts/docker-manager.sh start-ai

# Access container
docker exec -it ai-dev-env bash

# Inside container
./scripts/ai-dev.sh setup
./scripts/ai-dev.sh jupyter
./scripts/ai-dev.sh install
```

### **Data Visualization**
```bash
# Start data environment
./scripts/docker-manager.sh start-data

# Access container
docker exec -it data-viz-env bash

# Inside container
./scripts/data-dev.sh setup
./scripts/data-dev.sh jupyter
./scripts/data-dev.sh streamlit app.py
```

## 🔗 **Port Mapping**

| Environment | Port | Service |
|-------------|------|---------|
| Main Dev | 3000 | Next.js |
| Main Dev | 3001 | React |
| Main Dev | 4000 | Vue |
| Main Dev | 5000 | Python Flask |
| Main Dev | 8000 | Jupyter |
| Main Dev | 8080 | Angular |
| Main Dev | 9000 | SFCC |
| SFCC | 9000 | SFCC Development |
| AI/ML | 8000 | Jupyter Lab |
| AI/ML | 5000 | Flask/FastAPI |
| Data Viz | 8000 | Jupyter Lab |
| Data Viz | 5000 | Streamlit |

## 📊 **Resource Management**

### **Memory Limits**
```yaml
# In docker-compose.yml
services:
  dev-env:
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 2G
```

### **CPU Limits**
```yaml
# In docker-compose.yml
services:
  dev-env:
    deploy:
      resources:
        limits:
          cpus: '2.0'
        reservations:
          cpus: '1.0'
```

## 🔄 **Data Persistence**

### **Volume Mounts**
- **Workspace**: `./workspace:/home/dev/workspace`
- **Code Projects**: `~/code:/home/dev/code`
- **Git Config**: `~/.gitconfig:/home/dev/.gitconfig:ro`
- **SSH Keys**: `~/.ssh:/home/dev/.ssh:ro`

### **Data Backup**
```bash
# Backup workspace data
docker cp universal-dev-env:/home/dev/workspace ./backup/workspace

# Restore workspace data
docker cp ./backup/workspace universal-dev-env:/home/dev/workspace
```

## 🚨 **Troubleshooting**

### **Common Issues**
- **Port conflicts**: Change port mappings in docker-compose.yml
- **Permission issues**: Check file permissions on mounted volumes
- **Memory issues**: Increase Docker memory limits
- **Build failures**: Check Dockerfile syntax and dependencies

### **Debugging**
```bash
# Check container logs
docker logs universal-dev-env

# Check container status
docker ps -a

# Check resource usage
docker stats

# Access container shell
docker exec -it universal-dev-env bash
```

### **Reset Environment**
```bash
# Stop and remove all containers
docker-compose down

# Remove all images
docker rmi $(docker images -q)

# Rebuild from scratch
./scripts/docker-manager.sh build
```

## 🎯 **Benefits**

- ✅ **No MacBook Pro usage** - All processing in containers
- ✅ **Isolated environments** - No conflicts with host system
- ✅ **Consistent setup** - Same environment everywhere
- ✅ **Easy cleanup** - Remove containers when done
- ✅ **Resource control** - Limit CPU and memory usage
- ✅ **Cross-platform** - Works on any device with Docker
- ✅ **Specialized environments** - Optimized for different use cases
- ✅ **Data persistence** - Keep your work between sessions

## 📋 **Best Practices**

### **Development Workflow**
1. **Start environment** - Use appropriate container for your work
2. **Mount volumes** - Keep your code in mounted directories
3. **Use scripts** - Leverage provided development scripts
4. **Clean up** - Remove containers when done
5. **Backup data** - Save important work outside containers

### **Resource Management**
1. **Limit resources** - Set memory and CPU limits
2. **Monitor usage** - Check resource consumption
3. **Clean up regularly** - Remove unused containers and images
4. **Use volumes** - Persist important data

This Docker environment provides a complete insulated development setup that doesn't impact your MacBook Pro while giving you all the tools you need for development work.
