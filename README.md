# Flutter Clean Architecture Template

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Template](https://img.shields.io/badge/Template-Ready-success)](https://github.com/israelcarreno-gl/gist/generate)

A production-ready Flutter template with Clean Architecture, BLoC pattern, multi-environment support, and all the best practices you need to start your next Flutter project.

## ✨ What's Included

- 🏗️ **Clean Architecture** - Separation of concerns with Domain, Data, and Presentation layers
- 🎯 **BLoC Pattern** - Robust state management with flutter_bloc
- 💉 **Dependency Injection** - GetIt service locator pattern
- 🌍 **Multi-Environment** - Dev, Integration, and Production configurations
- 🎨 **Theming** - Light and Dark mode support with Material 3
- 🌐 **Internationalization** - Multi-language support (en, es)
- 🧪 **Testing** - Unit, widget, and integration tests with >80% coverage
- 🛠️ **FVM Support** - Flutter Version Manager for version pinning
- 📱 **Multi-Platform** - iOS, Android, Web, Windows, Linux, macOS ready

## 🚀 Quick Start

### Option 1: Use This Template (GitHub)

1. Click the **"Use this template"** button at the top of this repository
2. Create your new repository
3. Clone your new repository
4. Run the setup script (see below)

### Option 2: Clone and Setup

```bash
git clone https://github.com/israelcarreno-gl/gist.git my-app
cd my-app
chmod +x setup_template.sh
./setup_template.sh --name "MyApp" --bundle-id "com.mycompany.myapp" --flutter-version "3.35.7"
```

### Option 3: VS Code Setup (Easiest)

1. Open the project in VS Code
2. Press `Cmd+Shift+P` / `Ctrl+Shift+P`
3. Select **"Tasks: Run Task"** → **"Setup Template"**
4. Follow the interactive prompts

## 📋 What the Setup Does

The setup script automatically:
- ✅ Renames the project and updates all package names
- ✅ Updates bundle identifiers for iOS and Android
- ✅ Configures FVM with your chosen Flutter version
- ✅ Updates all Dart imports across the project
- ✅ Cleans and reinstalls all dependencies
- ✅ Runs code generation (Freezed, JSON serialization)
- ✅ Sets up CocoaPods for iOS (macOS only)

## 🏗️ Architecture

This project follows **Clean Architecture** principles with the following structure:

```
lib/
├── core/                          # Core app functionalities
│   ├── config/                   # Configurations (app, theme, environment)
│   ├── di/                       # Dependency Injection (GetIt)
│   ├── error/                    # Error handling (failures, exceptions)
│   ├── network/                  # HTTP Client (Dio)
│   ├── observers/                # BLoC Observer for logging
│   ├── router/                   # Navigation (GoRouter)
│   ├── theme/                    # Theme Cubit (dark/light mode)
│   └── utils/                    # Utilities and typedefs
├── features/                      # App features
│   └── demo/                     # Demo feature
│       ├── data/                 # Data layer
│       │   ├── datasources/     # Remote/Local data sources
│       │   ├── models/          # DTOs with Freezed
│       │   └── repositories/    # Repository implementations
│       ├── domain/              # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository contracts
│       │   └── usecases/       # Use cases
│       └── presentation/        # Presentation layer
│           ├── bloc/           # BLoC/Cubit
│           └── screens/        # UI Screens
├── app.dart                      # Main app widget
├── main.dart                     # Entry point (dev)
├── main_dev.dart                # Development entry point
├── main_int.dart                # Integration entry point
└── main_prod.dart               # Production entry point
```

## 🚀 Features

### Patterns and Architecture
- ✅ **Clean Architecture** (Domain, Data, Presentation)
- ✅ **BLoC Pattern** for state management
- ✅ **Repository Pattern** with data source abstraction
- ✅ **Dependency Injection** with GetIt
- ✅ **Either Pattern** for error handling (Dartz)

### Technologies
- ✅ **Dio + Retrofit** for HTTP calls
- ✅ **Freezed + Json Annotation** for immutable models and serialization
- ✅ **GoRouter** for navigation
- ✅ **Google Fonts** for typography
- ✅ **SharedPreferences** for local persistence
- ✅ **Logger** for debugging
- ✅ **FlutterGen** for type-safe asset generation

### Implemented Features
- ✅ **Theme Cubit** - Dark/light theme switching with persistence
- ✅ **Locale Cubit** - Internationalization (English/Spanish) with persistence
- ✅ **BLoC Observer** - Complete event and state logging
- ✅ **Multi-flavor** support (dev, int, prod)
- ✅ **Environment Variables** - Configuration from .env files
- ✅ **Demo Feature** - Fetching jokes from public API
- ✅ **Navigation** between screens with GoRouter

### Testing
- ✅ **Unit Tests** - Repositories, BLoCs, Use Cases
- ✅ **Widget Tests** - Screens and UI components
- ✅ **Integration Tests** - Complete app flows

## 📦 Installation

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Generate code (Freezed, Json Serializable, Retrofit, FlutterGen)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> This will generate:
> - Freezed models (`*.freezed.dart`)
> - JSON serialization (`*.g.dart`)
> - Retrofit API services
> - Type-safe asset classes (`lib/gen/assets.gen.dart`)

## 🏃‍♂️ Running the App

### Development (DEV)
```bash
flutter run -t lib/main_dev.dart
```

### Integration (INT)
```bash
flutter run -t lib/main_int.dart
```

### Production (PROD)
```bash
flutter run -t lib/main_prod.dart
```

### Default run (uses DEV)
```bash
flutter run
```

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run unit tests
```bash
flutter test test/features/demo/
```

### Run integration tests
```bash
flutter test integration_test/app_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

## 🔧 Flavor Configuration

Each flavor has its own configuration in `AppConfig`:

### Development (DEV)
- API Base URL: https://official-joke-api.appspot.com
- Logger: Enabled
- Timeout: 30 seconds

### Integration (INT)
- API Base URL: https://official-joke-api.appspot.com
- Logger: Enabled
- Timeout: 30 seconds

### Production (PROD)
- API Base URL: https://official-joke-api.appspot.com
- Logger: Disabled
- Timeout: 20 seconds

## 📱 Available Features

### Demo Screen
- Fetches a random joke from the API
- Displays setup and punchline
- Allows refreshing to get another joke
- Navigation to details screen
- Dark/light theme toggle
- Language toggle (English/Spanish)

### Detail Screen
- Shows details of the selected joke
- Navigation back to main screen

## 🎨 Themes

The app supports light and dark themes:
- Toggle via button in the AppBar
- Preference persistence with SharedPreferences
- Material 3 Design
- Google Fonts (Poppins)

## 🌍 Internationalization

The app supports multiple languages:
- English and Spanish
- Toggle via button in the AppBar
- Preference persistence with SharedPreferences
- ARB files for translations

## 🔌 API Used

**Official Joke API**
- Base URL: https://official-joke-api.appspot.com
- Random endpoint: `/random_joke`
- By type endpoint: `/jokes/{type}/ten`

## 📝 Adding a New Feature

1. Create folder structure in `features/`
2. Register dependencies in `injection_container.dart`
3. Add routes in `app_router.dart`
4. Create corresponding tests

## 🎨 Adding New Assets

1. Add asset to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/new_image.png
```

2. Run the generator:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Use type-safe assets:
```dart
Assets.images.newImage.image()
```

See [FLUTTER_GEN.md](FLUTTER_GEN.md) for more details.

## 🛠️ Useful Commands

### Generate code
```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerates)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Clean project
```bash
flutter clean
flutter pub get
```

## 📚 Main Packages

- `flutter_bloc` - State management
- `flutter_gen` - Type-safe asset generation
- `get_it` - Dependency injection
- `dio` - HTTP client
- `retrofit` - Type-safe REST client
- `freezed` - Code generation for immutable classes
- `go_router` - Declarative routing
- `google_fonts` - Custom fonts
- `dartz` - Functional programming
- `logger` - Pretty logging

## 📖 Documentation

- [Template Setup Guide](.github/TEMPLATE_SETUP.md) - First-time setup instructions
- [Contributing](CONTRIBUTING.md) - How to contribute to this template

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Show Your Support

If you find this template helpful, please give it a ⭐️ on GitHub!

## 🙏 Acknowledgments

- Clean Architecture principles by Robert C. Martin
- Flutter and Dart teams
- The amazing Flutter community

---

**Made with ❤️ for the Flutter community**

**Happy Coding! 🚀**
