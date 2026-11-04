<div align="center">

# 🚆 RideWay

**Book train tickets, pick your seat, and travel with a QR ticket in your pocket.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](#)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

</div>

---

## 📖 Table of Contents

- [About](#about)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Running the App](#-running-the-app)
- [Configuration](#-configuration)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

---

## About

**RideWay** is a cross-platform train ticket booking app built with **Flutter**. Users can search for trains between stations, select seats, pay securely (Paymob integration), and receive a digital ticket with a scannable QR code. The app supports **English & Arabic** localization and runs on **Android, iOS, Web, and Desktop**.

## ✨ Features

- 🔍 **Search & Discovery** — Find trains by station pair with recent searches and favorite routes.
- 💺 **Seat Selection & Booking** — Interactive seat picker, passenger details, and booking flow.
- 💳 **Payments** — Secure payment via **Paymob** with Firestore payment records.
- 🎟️ **Digital Tickets** — QR-code tickets you can screenshot, download, or share with others.
- 🔔 **Push Notifications** — Firebase Cloud Messaging + local notifications for booking updates.
- 🌍 **Localization** — Full **English / Arabic** support with RTL layout.
- 👤 **Account Management** — Email/password + Google Sign-in, profile editing, and password security.
- 🌐 **Offline Awareness** — Internet connection checks with graceful handling.

## 🛠 Tech Stack

| Category | Tools |
|---|---|
| **Framework** | Flutter (Dart SDK ^3.9.2) |
| **State Management** | BLoC / flutter_bloc, Provider |
| **Architecture** | Clean Architecture (data / domain / presentation) |
| **Backend** | Firebase (Auth, Firestore, Cloud Messaging) |
| **Networking** | Dio + pretty_dio_logger, http |
| **Navigation** | go_router, app_links (deep links) |
| **Dependency Injection** | get_it |
| **Localization** | easy_localization (EN / AR) |
| **UI / UX** | Google Fonts (Outfit, Readex Pro), Lottie, flutter_svg, animated_text_kit, dotted_line, smooth_page_indicator |
| **Tickets & Sharing** | qr_flutter, screenshot, share_plus, gal |
| **Storage** | shared_preferences |
| **Testing** | flutter_test, bloc_test, mocktail |

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── auth_gate.dart         # Authentication state handler
├── core/                  # Shared utilities (DI, router, themes, cache, API, widgets)
├── payment/               # Paymob payment module (clean architecture)
└── features/
    ├── splash/            # Splash screen
    ├── onboarding/        # Onboarding flow
    ├── auth/              # Login, register, password reset
    ├── home/              # Bottom navigation & home
    ├── search_and_discovery/  # Station search & train lists
    ├── booking/           # Seat selection & booking flow
    ├── trips/             # My bookings, digital & shared tickets
    ├── tickets/           # Ticket management
    ├── map/               # Map / stations
    ├── notfication/       # Notifications screen
    ├── support/           # Help & support
    └── account/           # Profile & security
```

## ⚡ Quick Start

```bash
git clone <your-repo-url>
cd ride_way_app
flutter pub get
flutter run
```

> **Note:** Firebase must be configured first — see [Configuration](#-configuration).

## 📦 Installation

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.9.x
- [Dart SDK](https://dart.dev/get-dart) ^3.9.2
- A [Firebase](https://console.firebase.google.com) project
- Android Studio / Xcode (for emulators and platform tooling)

### Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd ride_way_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (see [Configuration](#-configuration))

4. **(Optional) Regenerate app icons**
   ```bash
   dart run flutter_launcher_icons
   ```

## 🚀 Running the App

```bash
# Run in debug mode (auto-detects connected device)
flutter run

# Run on a specific platform
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d macos           # macOS
flutter run -d linux           # Linux

# Release builds
flutter build apk --release    # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios --release    # iOS
```

## ⚙️ Configuration

### Firebase Setup

1. Install the Firebase CLI and FlutterFire CLI:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
2. Log in and configure the project:
   ```bash
   firebase login
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart`.
3. Firestore rules and indexes are already included:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

### Services Used

| Service | Purpose |
|---|---|
| Firebase Authentication | Email/password & Google Sign-in |
| Cloud Firestore | Bookings, tickets, payment records, user profiles |
| Firebase Cloud Messaging | Push notifications |

### Payments (Paymob)

Payment credentials/endpoints are managed in the core API layer (`lib/core/database/api/`). Update the Paymob API keys and endpoints there before building for production.

### Localization

Translation files live in `assets/translations/` (`en.json`, `ar.json`). Add new strings there and use `easy_localization` keys in code.

## 🧪 Testing

```bash
flutter test          # Run all tests
flutter test --coverage   # With coverage
```

Tests use `bloc_test` and `mocktail` (see the `test/` directory).

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please follow the existing code style ([Clean Architecture](https://bloclibrary.dev) + BLoC conventions) and run `flutter analyze` before submitting.

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

## 👤 Author

**[Your Name]**
- GitHub: [@your-username](https://github.com/your-username)
- Email: your.email@example.com

---

<div align="center">

Made with 💙 and Flutter

</div>
