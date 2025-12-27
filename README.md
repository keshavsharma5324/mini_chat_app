# Galactic Solstice - Mini Chat App

A premium Flutter application featuring a clean architecture, real-time-simulated chat, and advanced UI/UX patterns.

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Code Generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## 🛠 Tech Stack

- **Core**: Flutter & Dart
- **State Management**: [Riverpod](https://riverpod.dev/) (using Generator and Annotation)
- **Networking**: `http` for fetching remote quotes
- **Persistence**: `shared_preferences` for local data
- **Serialization**: `json_serializable`
- **Testing**: `flutter_test`, `mocktail` for mocks, and `provider_scope` overrides

## 🏗 Architecture

The project follows **Clean Architecture** principles to ensure modularity and testability:

- **Domain Layer**: Pure Dart entities, use cases, and repository interfaces.
- **Data Layer**: Repository implementations, models (JSON conversion), and data sources (Local & Remote).
- **Presentation Layer**: Riverpod notifiers for state and Flutter widgets for the UI.

## ✨ Key Features

### 1. Users List
- **Initial Avatars**: Beautifully colored icons with user initials.
- **Online Status**: Real-time status dots (simulated) and "Last Seen" timestamps (e.g., "5 min ago", "Yesterday").
- **Quick Add**: Floating Action Button (**+ Add User**) on the Users tab with immediate snackbar feedback.
- **Scroll Preservation**: Navigation between tabs preserves your scroll position perfectly.

### 2. Chat History
- **Message Previews**: See the last message sent or received.
- **Unread Badges**: Prominent blue badges for unread messages (randomized for demo purposes).
- **Timing**: Relative timestamps for all conversations.

### 3. Messaging Experience
- **Interactive Chat**: Send messages and receive simulated replies from a remote API.
- **Word Dictionary**: Tap any word in a chat bubble to instantly fetch its meaning in a bottom sheet.
- **Header Sync**: The AppBar in the chat screen dynamically updates based on the user's online status.

## 🧪 Testing

The app includes comprehensive coverage:

- **Unit Tests**: Domain logic, repository mapping, and JSON models.
- **Widget Tests**: Verification of screen renders and interaction flows.

Run all tests:
```bash
flutter test
```

---
Built with ❤️ by the Galactic Solstice Team(Keshav Kumar).
