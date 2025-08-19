# Contributing to All Fintech Flutter SDK

Thank you for your interest in contributing to the All Fintech Flutter SDK! This guide will help you get started.

## 🚀 Quick Start

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Create** a feature branch
4. **Make** your changes
5. **Test** thoroughly
6. **Submit** a pull request

## 🛠️ Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/all_fintech_sdk.git
cd all_fintech_sdk/flutter-sdk/all_fintech_flutter_sdk

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run example app
cd example && flutter run
```

## 📋 Contribution Areas

### 🏦 **New Fintech Providers**
- Research provider APIs and documentation
- Follow existing provider patterns
- Implement both data and UI services
- Add comprehensive tests

### 🎨 **UI Components**
- Follow Material Design 3 guidelines
- Ensure responsive design
- Add proper error handling and loading states
- Include accessibility features

### 🔒 **Security Features**
- Implement proper authentication flows
- Add signature verification
- Enhance encryption methods
- Follow security best practices

### 📚 **Documentation**
- Improve README examples
- Add API documentation
- Create tutorial guides
- Fix typos and clarity issues

## 🎯 Coding Standards

### **Dart/Flutter Guidelines**
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check code quality
- Format code with `dart format`
- Maintain null safety

### **Architecture Patterns**
- Follow the dual service pattern (data + UI)
- Keep providers independent
- Use proper error handling
- Implement minimal code principle

### **Naming Conventions**
- Use descriptive class and method names
- Follow camelCase for variables and methods
- Use PascalCase for classes
- Prefix private members with underscore

## 🧪 Testing

### **Required Tests**
- Unit tests for all data services
- Widget tests for UI components
- Integration tests for critical flows
- Mock external API calls

### **Test Structure**
```dart
group('PaystackDataService', () {
  test('should initialize transaction successfully', () async {
    // Arrange
    final service = PaystackDataService(mockClient);
    
    // Act
    final result = await service.initializeTransaction(request);
    
    // Assert
    expect(result.status, true);
  });
});
```

## 📝 Pull Request Process

### **Before Submitting**
- [ ] Code follows project standards
- [ ] Tests pass locally
- [ ] Documentation updated if needed
- [ ] No breaking changes (or clearly documented)
- [ ] Commit messages follow conventional format

### **PR Template**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Example app tested

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
```

## 🐛 Bug Reports

When reporting bugs, please include:
- **Provider** affected (Paystack, Flutterwave, etc.)
- **Flutter version** and platform
- **Minimal code example** to reproduce
- **Expected vs actual behavior**
- **Error messages** and stack traces

## ✨ Feature Requests

For feature requests, please provide:
- **Clear description** of the feature
- **Use case** and business value
- **Proposed implementation** (if any)
- **Alternatives considered**

## 🏷️ Commit Message Format

Use conventional commits:
```
type(scope): description

feat(paystack): add subscription management
fix(ui): resolve payment sheet validation
docs(readme): update installation guide
test(monnify): add OAuth flow tests
```

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and community support
- **Email**: chidiebere.edeh@example.com for direct contact

## 🙏 Recognition

Contributors will be:
- Listed in the README contributors section
- Mentioned in release notes
- Given credit in documentation

Thank you for helping make Nigerian fintech integration easier for Flutter developers! 🚀