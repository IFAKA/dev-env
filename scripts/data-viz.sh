#!/bin/bash

# Data Visualization Script for Neovim
# Provides data visualization and exploration capabilities within Neovim

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Install data visualization packages
install_viz_packages() {
    log_info "Installing data visualization packages..."
    
    pip install --upgrade pip
    pip install matplotlib seaborn plotly
    pip install pandas numpy scipy
    pip install jupyter ipykernel
    pip install sniprun
    
    log_success "Data visualization packages installed"
}

# Create data visualization template
create_viz_template() {
    log_info "Creating data visualization template..."
    
    cat > ~/code/python-projects/data_analysis.py << 'EOF'
#!/usr/bin/env python3
"""
Data Analysis Template for Neovim
Use this template for data visualization and exploration
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import plotly.graph_objects as go

# Set up plotting style
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

def load_data(file_path):
    """Load data from CSV file"""
    try:
        df = pd.read_csv(file_path)
        print(f"Data loaded: {df.shape[0]} rows, {df.shape[1]} columns")
        return df
    except Exception as e:
        print(f"Error loading data: {e}")
        return None

def explore_data(df):
    """Basic data exploration"""
    print("\n=== DATA EXPLORATION ===")
    print(f"Shape: {df.shape}")
    print(f"\nColumns: {list(df.columns)}")
    print(f"\nData types:\n{df.dtypes}")
    print(f"\nMissing values:\n{df.isnull().sum()}")
    print(f"\nFirst 5 rows:\n{df.head()}")
    print(f"\nBasic statistics:\n{df.describe()}")

def create_plots(df):
    """Create various plots for data visualization"""
    
    # Set up the plotting area
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))
    fig.suptitle('Data Visualization Dashboard', fontsize=16)
    
    # Plot 1: Distribution of numeric columns
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    if len(numeric_cols) > 0:
        df[numeric_cols].hist(ax=axes[0,0], bins=20)
        axes[0,0].set_title('Distribution of Numeric Columns')
        axes[0,0].tick_params(axis='x', rotation=45)
    
    # Plot 2: Correlation heatmap
    if len(numeric_cols) > 1:
        correlation_matrix = df[numeric_cols].corr()
        sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', ax=axes[0,1])
        axes[0,1].set_title('Correlation Heatmap')
    
    # Plot 3: Box plots for numeric columns
    if len(numeric_cols) > 0:
        df[numeric_cols].boxplot(ax=axes[1,0])
        axes[1,0].set_title('Box Plots')
        axes[1,0].tick_params(axis='x', rotation=45)
    
    # Plot 4: Value counts for categorical columns
    categorical_cols = df.select_dtypes(include=['object']).columns
    if len(categorical_cols) > 0:
        df[categorical_cols[0]].value_counts().plot(kind='bar', ax=axes[1,1])
        axes[1,1].set_title(f'Value Counts: {categorical_cols[0]}')
        axes[1,1].tick_params(axis='x', rotation=45)
    
    plt.tight_layout()
    plt.savefig('data_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    print("\nPlot saved as 'data_analysis.png'")

def create_interactive_plot(df):
    """Create interactive plot with Plotly"""
    try:
        # Create interactive scatter plot
        numeric_cols = df.select_dtypes(include=[np.number]).columns
        if len(numeric_cols) >= 2:
            fig = px.scatter(df, x=numeric_cols[0], y=numeric_cols[1], 
                           title='Interactive Scatter Plot')
            fig.write_html('interactive_plot.html')
            print("Interactive plot saved as 'interactive_plot.html'")
            return fig
    except Exception as e:
        print(f"Error creating interactive plot: {e}")
        return None

def analyze_data(df):
    """Comprehensive data analysis"""
    print("\n=== COMPREHENSIVE ANALYSIS ===")
    
    # Basic exploration
    explore_data(df)
    
    # Create visualizations
    create_plots(df)
    
    # Create interactive plot
    create_interactive_plot(df)
    
    print("\n=== ANALYSIS COMPLETE ===")
    print("Files created:")
    print("- data_analysis.png (static plots)")
    print("- interactive_plot.html (interactive plot)")

# Example usage
if __name__ == "__main__":
    # Load sample data or your data
    # df = load_data('your_data.csv')
    
    # For demonstration, create sample data
    np.random.seed(42)
    df = pd.DataFrame({
        'A': np.random.randn(100),
        'B': np.random.randn(100),
        'C': np.random.choice(['X', 'Y', 'Z'], 100),
        'D': np.random.randint(1, 10, 100)
    })
    
    print("Using sample data for demonstration")
    analyze_data(df)
EOF
    
    log_success "Data visualization template created"
}

# Start data visualization environment
start_viz_env() {
    log_info "Starting data visualization environment..."
    
    # Create project directory
    mkdir -p ~/code/python-projects
    cd ~/code/python-projects
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        log_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Install packages
    install_viz_packages
    
    # Create template
    create_viz_template
    
    # Start Neovim with data analysis
    nvim data_analysis.py
    
    log_success "Data visualization environment started"
}

# Quick data analysis
quick_analysis() {
    log_info "Starting quick data analysis..."
    
    if [ -z "$1" ]; then
        log_warning "Please provide a data file path"
        echo "Usage: data-viz quick <data_file.csv>"
        exit 1
    fi
    
    # Create quick analysis script
    cat > /tmp/quick_analysis.py << EOF
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv('$1')
print(f"Data shape: {df.shape}")
print(f"Columns: {list(df.columns)}")
print(f"Data types:\n{df.dtypes}")
print(f"Missing values:\n{df.isnull().sum()}")
print(f"First 5 rows:\n{df.head()}")

# Create quick plot
numeric_cols = df.select_dtypes(include=['number']).columns
if len(numeric_cols) > 0:
    df[numeric_cols].hist(figsize=(10, 6))
    plt.tight_layout()
    plt.savefig('quick_analysis.png')
    plt.show()
    print("Plot saved as 'quick_analysis.png'")
EOF
    
    # Run analysis
    python3 /tmp/quick_analysis.py
    
    log_success "Quick analysis completed"
}

# Show available commands
show_commands() {
    echo "Data Visualization Commands:"
    echo ""
    echo "Neovim Keymaps:"
    echo "  <leader>plot     # Run code with SnipRun"
    echo "  <leader>data     # Check pandas availability"
    echo "  <leader>viz      # Check matplotlib availability"
    echo "  <leader>table    # Show data table"
    echo "  <leader>img      # Preview images/plots"
    echo "  <leader>repl      # Open Python REPL"
    echo "  <leader>rs       # Send code to REPL"
    echo ""
    echo "Script Commands:"
    echo "  ./scripts/data-viz.sh start        # Start visualization environment"
    echo "  ./scripts/data-viz.sh quick <file> # Quick data analysis"
    echo "  ./scripts/data-viz.sh install      # Install packages"
    echo "  ./scripts/data-viz.sh template     # Create template"
    echo ""
    echo "Python Functions:"
    echo "  load_data(file_path)      # Load CSV data"
    echo "  explore_data(df)          # Basic exploration"
    echo "  create_plots(df)          # Create visualizations"
    echo "  analyze_data(df)          # Full analysis"
}

# Main function
main() {
    case "${1:-help}" in
        "start")
            start_viz_env
            ;;
        "quick")
            quick_analysis "$2"
            ;;
        "install")
            install_viz_packages
            ;;
        "template")
            create_viz_template
            ;;
        "commands")
            show_commands
            ;;
        "help"|"-h"|"--help")
            echo "Data Visualization Script for Neovim"
            echo ""
            echo "Usage: data-viz [COMMAND] [OPTIONS]"
            echo ""
            echo "Commands:"
            echo "  start       Start visualization environment"
            echo "  quick       Quick data analysis"
            echo "  install     Install packages"
            echo "  template    Create template"
            echo "  commands    Show available commands"
            echo "  help       Show this help"
            ;;
        *)
            log_error "Unknown command: $1"
            show_commands
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
