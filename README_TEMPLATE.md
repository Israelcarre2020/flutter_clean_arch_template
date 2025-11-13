# Flutter Clean Architecture Template

A production-ready Flutter template with Clean Architecture, multi-environment support, and pre-configured best practices.

## ⚡ Quick Start

### Using VS Code (Recommended)

1. Open Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Select **"Tasks: Run Task"**
3. Choose **"Setup Template** 
4. Enter your project details when prompted

### Using Command Line

**Mac/Linux:**
```bash
chmod +x setup_template.sh
./setup_template.sh --name "MyApp" --bundle-id "com.mycompany.myapp" --org "MyCompany"
```


## 📋 What's Included

- ✅ **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- ✅ **State Management** - BLoC pattern with flutter_bloc
- ✅ **Dependency Injection** - GetIt service locator
- ✅ **Navigation** - GoRouter for declarative routing
- ✅ **Networking** - Dio with interceptors and logging
- ✅ **Multi-Environment** - Dev, Int, Prod configurations
- ✅ **Internationalization** - Multi-language support (en, es)
- ✅ **Theming** - Light and Dark mode support
- ✅ **Code Generation** - json_serializable, freezed, build_runner
- ✅ **Testing** - Unit tests, widget tests, and integration tests
- ✅ **Linting** - Flutter lints and custom rules

## 🏗️ Project Structure

```
lib/
├── app.dart                 # Main app widget
├── main.dart               # Entry point
├── main_dev.dart           # Dev environment entry
├── main_int.dart           # Integration environment entry
├── main_prod.dart          # Production environment entry
├── core/
│   ├── config/             # App configuration
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── l10n/               # Localization
│   ├── network/            # Network configuration
│   ├── router/             # Navigation
│   ├── theme/              # Theme configuration
│   └── utils/              # Utilities
└── features/
    └── demo/
        ├── data/           # Data layer (repositories, data sources)
        ├── domain/         # Domain layer (entities, use cases)
        └── presentation/   # Presentation layer (BLoC, screens, widgets)
```

## 🚀 Running the App

### Different Environments

**Development:**
```bash
flutter run -t lib/main_dev.dart
```

**Integration:**
```bash
flutter run -t lib/main_int.dart
```

**Production:**
```bash
flutter run -t lib/main_prod.dart
```

### Building for Release

**Android:**
```bash
flutter build apk -t lib/main_prod.dart --release
flutter build appbundle -t lib/main_prod.dart --release
```

**iOS:**
```bash
flutter build ios -t lib/main_prod.dart --release
```

## 🔧 Available VS Code Tasks

Run tasks via Command Palette → "Tasks: Run Task":

- **Setup Template** - Configure project for new app
- **Run All Tests** - Execute all unit and widget tests
- **Run Tests with Coverage** - Run tests and generate coverage report
- **Run Integration Tests** - Execute integration tests
- **Clean & Get Dependencies** - Clean and update dependencies
- **Run Code Generation** - Generate code with build_runner
- **Watch Code Generation** - Auto-generate code on file changes
- **Build APK (Dev)** - Build development APK
- **Build APK (Prod)** - Build production APK

## 🌍 Environment Configuration

Each environment has its own configuration file:

- `assets/env/.env.dev` - Development settings
- `assets/env/.env.int` - Integration settings  
- `assets/env/.env.prod` - Production settings

Example `.env` file:
```env
APP_NAME=My App Dev
API_BASE_URL=https://api.dev.example.com
ENABLE_LOGGER=true
```

## 🧪 Testing

**Run all tests:**
```bash
flutter test
```

**Run with coverage:**
```bash
flutter test --coverage
```

**Run integration tests:**
```bash
flutter test integration_test/
```

## 📦 Code Generation

**Run once:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Watch for changes:**
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 🎨 Customization

After setting up the template:

1. Update environment files (`assets/env/.env.*`)
2. Replace app icons:
   - Android: `android/app/src/main/res/mipmap-*/`
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. Update app colors and theme in `lib/core/theme/`
4. Add your features in `lib/features/`


## 🤝 Contributing

## 🛠️ FVM (Flutter Version Manager)

This template supports pinning the Flutter SDK using FVM to ensure all contributors and CI use the exact same Flutter version.

Quick notes:

- The template ships with a `.fvm/fvm_config.json` file containing the pinned Flutter SDK version (default: `3.35.7`).
- If you have FVM installed, run:

```bash
fvm install
fvm use
```

- When running Flutter commands, you can use the FVM wrapper to guarantee the pinned SDK is used:

```bash
fvm flutter pub get
fvm flutter run -t lib/main_dev.dart
```

- The `setup_template.sh` script accepts an optional Flutter version parameter to set the project Flutter version during setup:

```bash
./setup_template.sh --name "MyApp" --bundle-id "com.mycompany.myapp" --flutter-version 3.35.7
```

- The setup script automatically uses `fvm flutter` for all commands if FVM is installed, ensuring consistency from the start.

CI tip: use `fvm flutter` in CI pipelines (or install the specific Flutter version via FVM) so builds remain reproducible.


Feel free to submit issues and pull requests!

## 📄 License

MIT