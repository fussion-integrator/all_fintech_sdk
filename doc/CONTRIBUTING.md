# Contributing to All Fintech SDK

Thank you for your interest in contributing to the All Fintech SDK! This document provides guidelines and information for contributors.

## Development Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Git
- Make (optional, for using Makefile commands)

### Setup Instructions

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/all_fintech_sdk.git
   cd all_fintech_sdk
   ```

2. **Install Dependencies**
   ```bash
   make install
   # or
   flutter pub get
   cd example && flutter pub get
   ```

3. **Setup Development Environment**
   ```bash
   make dev-setup
   ```

## Development Workflow

### Code Style

- Follow Dart/Flutter conventions
- Use `dart format` for consistent formatting
- Maintain 80-character line limit
- Add comprehensive documentation for public APIs

### Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(paystack): add subscription management
fix(monnify): resolve OAuth token refresh issue
docs(readme): update installation instructions
```

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Write code following our style guidelines
   - Add tests for new functionality
   - Update documentation as needed

3. **Run Quality Checks**
   ```bash
   make analyze
   make test
   make format
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat(provider): add new feature"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## Adding New Providers

### Provider Structure

When adding a new fintech provider:

1. **Create Provider Directory**
   ```
   lib/src/providers/new_provider/
   ├── data/
   │   └── new_provider_data_service.dart
   ├── ui/
   │   ├── widgets/
   │   └── new_provider_ui_service.dart
   ├── models/
   │   └── new_provider_models.dart
   ├── new_provider_client.dart
   └── new_provider_provider.dart
   ```

2. **Implement Required Interfaces**
   - Data service for API operations
   - UI service for widgets
   - Models with JSON serialization
   - HTTP client with authentication

3. **Add to Main SDK**
   - Update `FintechProvider` enum
   - Add getter in `AllFintechSDK`
   - Export in main library file

### Testing Requirements

- Unit tests for all public methods
- Widget tests for UI components
- Integration tests for API flows
- Mock implementations for testing

## Code Quality Standards

### Static Analysis

All code must pass:
```bash
flutter analyze --fatal-infos
```

### Test Coverage

Maintain minimum 80% test coverage:
```bash
flutter test --coverage
```

### Documentation

- Document all public APIs
- Include code examples
- Update README for new features
- Add inline comments for complex logic

## Release Process

### Version Bumping

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run full test suite
4. Create release PR
5. Tag release after merge

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/chidiebere-edeh/all_fintech_sdk/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chidiebere-edeh/all_fintech_sdk/discussions)
- **Email**: chidiebere.edeh@example.com

## Recognition

Contributors will be:
- Listed in `CONTRIBUTORS.md`
- Mentioned in release notes
- Added to GitHub contributors list

Thank you for contributing to the All Fintech SDK! 🚀