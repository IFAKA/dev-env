# SFCC Prophet-like Functionality for Neovim

This provides the same "Clean Project/Upload all" functionality as the [VS Code Prophet extension](https://github.com/SqrTT/prophet) but directly in Neovim.

## 🎯 Features

- **Clean all cartridges** - Remove cache and temporary files
- **Upload all cartridges** - Upload to SFCC sandbox
- **Clean and upload** - Combined operation (main feature)
- **Project status** - Check configuration and cartridges
- **Configuration management** - Create and manage dw.json

## 🚀 Usage

### Neovim Keymaps
```vim
<leader>sfcc-all     " Clean and upload all cartridges
<leader>sfcc-clean   " Clean cartridges only
<leader>sfcc-upload  " Upload cartridges only
<leader>sfcc-status  " Show project status
<leader>sfcc-config  " Create dw.json template
```

### Command Line
```bash
# Clean and upload all (main function)
./scripts/sfcc-prophet.sh clean-upload

# Clean only
./scripts/sfcc-prophet.sh clean

# Upload only
./scripts/sfcc-prophet.sh upload

# Show status
./scripts/sfcc-prophet.sh status

# Create config template
./scripts/sfcc-prophet.sh config
```

### SFCC Project Script
```bash
# Use with SFCC project script
./scripts/project-sfcc.sh clean-upload
./scripts/project-sfcc.sh clean
./scripts/project-sfcc.sh upload
./scripts/project-sfcc.sh status
```

## 📁 Configuration

### dw.json Template
```json
{
    "hostname": "your-sandbox.demandware.net",
    "username": "your-username",
    "password": "your-app-password",
    "code-version": "version1",
    "cartridge": ["store", "core", "custom_cartridge"]
}
```

### dw.js Template (Alternative)
```javascript
module.exports = {
    hostname: 'your-sandbox.demandware.net',
    username: 'your-username',
    password: 'your-app-password',
    codeVersion: 'version1',
    cartridge: ['store', 'core', 'custom_cartridge']
};
```

## 🔧 Prerequisites

### Required Tools
- **dwupload** - SFCC upload tool
- **Node.js 14** - For SFCC development
- **Git** - For project management

### Installation
```bash
# Install dwupload globally
npm install -g dwupload

# Install with NVM (recommended)
nvm install 14
nvm use 14
npm install -g dwupload
```

## 📋 Workflow

### 1. Initial Setup
```bash
# Create dw.json configuration
./scripts/sfcc-prophet.sh config

# Edit dw.json with your sandbox credentials
vim dw.json
```

### 2. Daily Development
```bash
# Clean and upload all cartridges
./scripts/sfcc-prophet.sh clean-upload

# Or use Neovim keymaps
# Press <leader>sfcc-all in Neovim
```

### 3. Project Structure
```
your-sfcc-project/
├── dw.json                    # Sandbox configuration
├── cartridge/                 # Cartridge files
│   ├── store/
│   ├── core/
│   └── custom_cartridge/
└── scripts/
    └── sfcc-prophet.sh        # Prophet functionality
```

## 🎯 Equivalent to VS Code Prophet

| VS Code Prophet | Neovim Equivalent |
|----------------|-------------------|
| Clean Project/Upload all | `<leader>sfcc-all` |
| Upload cartridges | `<leader>sfcc-upload` |
| Clean cartridges | `<leader>sfcc-clean` |
| Project status | `<leader>sfcc-status` |
| Configuration | `<leader>sfcc-config` |

## 🔍 Troubleshooting

### Common Issues
- **dwupload not found**: Install with `npm install -g dwupload`
- **No dw.json**: Run `./scripts/sfcc-prophet.sh config`
- **Permission denied**: Run `chmod +x scripts/sfcc-prophet.sh`
- **Invalid credentials**: Check dw.json configuration

### Validation
```bash
# Check project status
./scripts/sfcc-prophet.sh status

# Verify dwupload installation
which dwupload

# Test sandbox connection
dwupload --hostname your-sandbox.demandware.net --username your-username --password your-password --code-version version1 --cartridge store
```

## 📚 Related

- [VS Code Prophet Extension](https://github.com/SqrTT/prophet) - Original VS Code extension
- [SFCC Documentation](https://documentation.b2c.commercecloud.salesforce.com/) - Official SFCC docs
- [dwupload CLI](https://www.npmjs.com/package/dwupload) - SFCC upload tool

## 🚀 Benefits

- ✅ **Neovim native** - No need to switch to VS Code
- ✅ **Same functionality** - Equivalent to Prophet extension
- ✅ **Keyboard-first** - Perfect for mobile development
- ✅ **Terminal-based** - Works on any device
- ✅ **Git-friendly** - Version control integration
- ✅ **Cross-device** - Works on Android, iOS, macOS, Linux
