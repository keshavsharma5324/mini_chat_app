# Mini Chat App

A Flutter application featuring a custom tab switcher, persistent navigation, and chat functionality with API integration.

## Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   ```bash
   flutter run
   ```

## Features

- **Home Screen**: Custom SliverAppBar with "Users" and "Chat History" tabs.
- **Users**: Add new users locally.
- **Chat**: Real-time messaging UI. Sender messages are local; Receiver messages are fetched from `dummyjson.com`.
- **Persistence**: Users and Chat History are saved locally.

## Testing

Run unit tests:
```bash
flutter test
```
