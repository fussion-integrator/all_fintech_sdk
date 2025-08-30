#!/bin/bash
# All Fintech SDK Development Setup Script

set -e

echo "🚀 Setting up All Fintech SDK development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter is not installed${NC}"
        echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Flutter found: $(flutter --version | head -n 1)${NC}"
}

# Check if Dart is installed
check_dart() {
    if ! command -v dart &> /dev/null; then
        echo -e "${RED}❌ Dart is not installed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Dart found: $(dart --version)${NC}"
}

# Install dependencies
install_dependencies() {
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    
    flutter pub get
    
    if [ -d "example" ]; then
        cd example
        flutter pub get
        cd ..
    fi
    
    echo -e "${GREEN}✅ Dependencies installed${NC}"
}

# Setup git hooks
setup_git_hooks() {
    echo -e "${YELLOW}🔗 Setting up git hooks...${NC}"
    
    if [ -f "tools/git-hooks/pre-commit" ]; then
        cp tools/git-hooks/pre-commit .git/hooks/
        chmod +x .git/hooks/pre-commit
        echo -e "${GREEN}✅ Git hooks installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Pre-commit hook not found, skipping...${NC}"
    fi
}

# Run initial checks
run_checks() {
    echo -e "${YELLOW}🔍 Running initial checks...${NC}"
    
    # Format check
    dart format --set-exit-if-changed . || {
        echo -e "${YELLOW}⚠️  Code formatting issues found. Running formatter...${NC}"
        dart format .
    }
    
    # Analysis
    flutter analyze --fatal-infos
    
    # Tests
    flutter test
    
    echo -e "${GREEN}✅ All checks passed${NC}"
}

# Create necessary directories
create_directories() {
    echo -e "${YELLOW}📁 Creating necessary directories...${NC}"
    
    mkdir -p coverage
    mkdir -p doc/api
    mkdir -p build
    
    echo -e "${GREEN}✅ Directories created${NC}"
}

# Main setup function
main() {
    echo "Starting setup process..."
    
    check_flutter
    check_dart
    create_directories
    install_dependencies
    setup_git_hooks
    run_checks
    
    echo ""
    echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
    echo ""
    echo "Available commands:"
    echo "  make help          - Show available make commands"
    echo "  make test          - Run tests"
    echo "  make analyze       - Run static analysis"
    echo "  make format        - Format code"
    echo "  make build         - Build example app"
    echo ""
    echo "Happy coding! 🚀"
}

# Run main function
main "$@"