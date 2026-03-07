# Flutter Quick-Reference Commands

You can copy and paste these commands into your terminal for daily development.

## 🚀 Basic Development
| Command | Description |
| :--- | :--- |
| `flutter run` | Run the app in debug mode |
| `flutter run --release` | Run the app in release mode |
| `flutter clean` | Delete the build/ and .dart_tool/ folders |
| `flutter pub get` | Download packages defined in pubspec.yaml |
| `flutter pub upgrade` | Upgrade all packages to latest versions |
| `flutter run -d chrome --web-port 3001` | Run on Chrome using port 3001 |

## 🛠️ Code Generation & Analysis
| Command | Description |
| :--- | :--- |
| `flutter analyze` | Analyze the project for errors and warnings |
| `flutter test` | Run unit and widget tests |
| `dart format .` | Format all files in the current directory |
| `flutter pub run build_runner build` | (If using) Run one-time code generation |
| `flutter pub run build_runner watch` | (If using) Keep watch for file changes to generate code |

## 📱 Device Management
| Command | Description |
| :--- | :--- |
| `flutter devices` | List all connected devices |
| `flutter emulators` | List and launch emulators |
| `flutter doctor` | Check if your Flutter environment is correctly set up |

## 📦 Build Commands (Android)
| Command | Description |
| :--- | :--- |
| `flutter build apk` | Build a debug/release APK |
| `flutter build appbundle` | Build an Android App Bundle (for Play Store) |

## 📦 Build Commands (Windows)
| Command | Description |
| :--- | :--- |
| `flutter build windows` | Build a Windows executable |

---

### Tips for Efficiency
- **Hot Reload**: Press `r` in the terminal while `flutter run` is active.
- **Hot Restart**: Press `R` in the terminal while `flutter run` is active.
- **Debug Menu**: Press `v` or `h` in the terminal to see more run options.
