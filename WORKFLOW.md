# Development Workflow

## 🎯 Two Separate Workflows

### 1. Dev Environment (This Repo)
**Purpose**: Auto-setup development environment
**When you use it**:
- ✅ Initial setup on new device
- ✅ Environment updates when repo changes
- ✅ Configuration changes you want to sync
- ❌ Daily development (use your code projects instead)

**Commands**:
```bash
# Initial setup (once per device)
git clone <your-repo-url> ~/dev-env
cd ~/dev-env
./setup.sh

# Update environment
cd ~/dev-env
./scripts/update-env.sh update

# Sync across devices
./scripts/sync.sh sync
```

### 2. Code Projects (Separate Repos)
**Purpose**: Your actual development work
**When you use it**:
- ✅ Daily development work
- ✅ Creating new projects
- ✅ Working on existing projects
- ✅ Regular Git workflow

**Commands**:
```bash
# Clone your projects
git clone https://github.com/yourusername/your-project.git ~/code/your-project
cd ~/code/your-project

# Start development
dev start

# Or use project-specific scripts
./scripts/project-sfcc.sh start
./scripts/project-nextjs.sh start
```

## 🔄 Typical Workflow

### Day 1: Initial Setup
```bash
# Setup dev environment (once per device)
git clone <your-repo-url> ~/dev-env
cd ~/dev-env
./setup.sh
```

### Day 2+: Daily Development
```bash
# Work on your projects
cd ~/code/your-project
dev start

# Or clone new projects
git clone https://github.com/yourusername/new-project.git ~/code/new-project
cd ~/code/new-project
dev start
```

### When Dev Environment Updates
```bash
# Update environment
cd ~/dev-env
./scripts/update-env.sh update
```

## 📁 Directory Structure

```
~/dev-env/          # Dev environment repo (this repo)
├── setup.sh        # Setup script
├── scripts/        # Environment scripts
└── configs/        # Configuration files

~/code/             # Your actual projects
├── your-project/   # Your GitHub/GitLab projects
├── another-project/
└── ...
```

## 🚀 Quick Start

### New Device Setup
```bash
# 1. Clone dev environment
git clone <your-repo-url> ~/dev-env
cd ~/dev-env
./setup.sh

# 2. Clone your projects
git clone https://github.com/yourusername/your-project.git ~/code/your-project
cd ~/code/your-project
dev start
```

### Daily Development
```bash
# Work on your projects
cd ~/code/your-project
dev start
```

### Environment Updates
```bash
# Update dev environment
cd ~/dev-env
./scripts/update-env.sh update
```

## 🔧 Key Points

- **This repo** = Dev environment setup (use occasionally)
- **Your projects** = Daily development work (use daily)
- **Separate repos** = Each project has its own Git repo
- **Local development** = All work happens on your device
- **Git sync** = Standard Git workflow for projects
- **Environment sync** = Git-based sync for dev environment
