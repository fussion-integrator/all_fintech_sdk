# All Fintech SDK Makefile
# Professional development workflow automation

.PHONY: help install clean test analyze format build docs publish

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Development setup
install: ## Install dependencies
	@echo "Installing dependencies..."
	@flutter pub get
	@cd example && flutter pub get

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@flutter clean
	@cd example && flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/

# Code quality
analyze: ## Run static analysis
	@echo "Running static analysis..."
	@flutter analyze --fatal-infos

format: ## Format code
	@echo "Formatting code..."
	@dart format --set-exit-if-changed .

format-fix: ## Format code and fix issues
	@echo "Formatting and fixing code..."
	@dart format .

# Testing
test: ## Run tests
	@echo "Running tests..."
	@flutter test --coverage

test-integration: ## Run integration tests
	@echo "Running integration tests..."
	@cd example && flutter test integration_test/

# Build
build: ## Build example app
	@echo "Building example app..."
	@cd example && flutter build apk --debug

build-release: ## Build release version
	@echo "Building release version..."
	@cd example && flutter build apk --release

# Documentation
docs: ## Generate documentation
	@echo "Generating documentation..."
	@dart doc .
	@echo "Documentation generated in doc/api/"

docs-serve: ## Serve documentation locally
	@echo "Serving documentation on http://localhost:8080"
	@cd doc/api && python3 -m http.server 8080

# Publishing
check-publish: ## Check if package is ready for publishing
	@echo "Checking package for publishing..."
	@flutter pub publish --dry-run

publish: ## Publish package to pub.dev
	@echo "Publishing package..."
	@flutter pub publish

# Development helpers
upgrade: ## Upgrade dependencies
	@echo "Upgrading dependencies..."
	@flutter pub upgrade
	@cd example && flutter pub upgrade

outdated: ## Check for outdated dependencies
	@echo "Checking for outdated dependencies..."
	@flutter pub outdated

# Git hooks
setup-hooks: ## Setup git hooks
	@echo "Setting up git hooks..."
	@cp tools/git-hooks/pre-commit .git/hooks/
	@chmod +x .git/hooks/pre-commit

# CI/CD helpers
ci-setup: install analyze test ## Setup for CI/CD

# All-in-one commands
dev-setup: install setup-hooks ## Complete development setup
	@echo "Development environment ready!"

release-check: clean analyze test build docs check-publish ## Pre-release checks
	@echo "Release checks completed!"