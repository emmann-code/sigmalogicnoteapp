# Sigma Note App

A Flutter note-taking application with a clean UI and essential features.

## Features

- **Splash Screen** - Beautifully designed splash screen
- **Authentication** - Mock login functionality
- **Notes List** - View and manage your notes (mocked data)
- **Settings** - Access device information via native MethodChannel
- **Secure Storage** - Token storage using `flutter_secure_storage`
- **State Management** - Powered by Riverpod
- **Offline-First** - Uses mocked repositories (no real HTTP calls)

## Screenshots

| Splash Screen | Login Screen | Notes | Settings |
|---------------|--------------|-------|----------|
| <img src="https://raw.githubusercontent.com/emmann-code/sigmalogicnoteapp/main/sigma_note_app/assets/images/splash.png" width="200"> | <img src="https://raw.githubusercontent.com/emmann-code/sigmalogicnoteapp/main/sigma_note_app/assets/images/loginpage.png" width="200"> | <img src="https://raw.githubusercontent.com/emmann-code/sigmalogicnoteapp/main/sigma_note_app/assets/images/nothomescreen.png" width="200"> | <img src="https://raw.githubusercontent.com/emmann-code/sigmalogicnoteapp/main/sigma_note_app/assets/images/settingsscreen.png" width="200"> |

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)
- VS Code or Android Studio (with Flutter plugins)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/emmann-code/sigmalogicnoteapp.git
   cd sigmalogicnoteapp
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Mock Credentials

Use these credentials for testing:
- **Email**: test@sigma-logic.gr
- **Password**: password123

Any other credentials will show an error message.

## Native Device Information

The app displays device information using platform channels:

### Android (Kotlin)
- Device Model
- Manufacturer
- OS Version
- Battery Level

### iOS (Swift)
- Device Model/Name
- System Version
- Battery Level

## Dependencies

- `flutter_secure_storage`: For secure token storage
- `riverpod`: For state management
- `sizer`: For responsive UI
- `fluttertoast`: For showing toast messages

## Project Structure

```
lib/
├── core/
├── presentation/
│   ├── login_screen/
│   ├── notes_screen/
│   ├── settings_screen/
│   └── splash_screen/
├── routes/
├── theme/
└── widgets/
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
