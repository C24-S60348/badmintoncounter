# Badminton Counter App 🏸

A comprehensive Flutter app for tracking badminton scores with history tracking, statistics, and multiple control methods.

## Features

### 🎮 Multiple Control Methods
- **Touch Control**: Tap score boxes to increment, tap [-] button to decrement
- **Mouse Control**: Left/right click to score, middle click to toggle touch mode
- **Keyboard Shortcuts**: 
  - Arrow keys (←/→) or A/D to score
  - Z/C to decrement
  - R to reset
  - S to toggle speech

### 🔥 Core Features
- **Streak Indicator**: Fire emojis show consecutive points
  - 1 point: 🔥
  - 2 points: 🔥🔥
  - 3 points: 🔥🔥🔥
  - 4+ points: 🔥x4, 🔥x5, etc.
- **Speech Score**: Optional voice announcement of scores
- **Total Points Tracking**: Persistent point tracking across all games
- **History Management**: Save and edit completed games with player names and remarks
- **Statistics Summary**: View player stats, win rates, leaderboards
- **Screenshot Sharing**: Capture and share game scores

### 📱 User Interface
- Beautiful Material Design 3 UI
- Responsive layout for all screen sizes
- Dark/Light theme support (system default)
- Bottom navigation for easy access to all features

## Installation

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / Xcode (for mobile development)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/afwanhaziq/badmintoncounter.git
cd badmintoncounter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### API Configuration

The app connects to a backend API at `https://afwanhaziq.vps.webdock.cloud/api`. 

To use your own backend:
1. Update the `baseUrl` in `lib/services/api_service.dart`
2. Ensure your backend has the following endpoints:
   - `POST /gethistory` - Get user's game history
   - `POST /inserthistory` - Save new game
   - `POST /updatehistory` - Update existing game
   - `POST /insertsuggestions` - Submit user suggestions

## Project Structure

```
lib/
├── main.dart                    # App entry point & navigation
├── services/
│   └── api_service.dart        # API integration
└── screens/
    ├── counter_page.dart       # Main scoring interface
    ├── history_page.dart       # Game history with edit
    ├── summary_page.dart       # Player statistics
    ├── instructions_page.dart  # User guide
    └── suggestions_page.dart   # Feedback form
```

## Usage

### Starting a Game
1. Open the app to the Counter page
2. Use any control method to increment scores
3. Watch for streak indicators (🔥)
4. Enable speech score if desired

### Saving a Game
1. Tap the reset button when game is complete
2. Choose to save to history
3. Enter player names (optional)
4. Add remarks (optional)
5. Confirm to save

### Viewing History
1. Navigate to History tab
2. Tap any game to edit details
3. Pull down to refresh

### Checking Statistics
1. Navigate to Summary tab
2. View leaderboard and player stats
3. Track win rates and averages

## Dependencies

- `flutter_tts: ^3.8.3` - Text-to-speech for score announcements
- `http: ^1.1.0` - API communication
- `shared_preferences: ^2.2.2` - Local data persistence
- `intl: ^0.18.1` - Date/time formatting
- `share_plus: ^7.2.1` - Screenshot sharing
- `screenshot: ^2.1.0` - Screen capture
- `path_provider: ^2.1.1` - File system access

## Backend API

The backend is built with Flask/Python and uses SQLite for data storage.

### Database Schema

**history table:**
- `id`: INTEGER PRIMARY KEY
- `userid`: TEXT
- `date`: TEXT (YYYY-MM-DD)
- `time`: TEXT (HH:MM:SS)
- `score`: TEXT (e.g., "21-19")
- `playerleft`: TEXT
- `playerright`: TEXT
- `remark`: TEXT
- `created_at`: TEXT

**suggestions table:**
- `id`: INTEGER PRIMARY KEY
- `name`: TEXT
- `comment`: TEXT
- `created_at`: TEXT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Support

For bugs, feature requests, or suggestions, please use the in-app "Send Suggestions" feature or open an issue on GitHub.

## Version

Current Version: 1.0.0

---

Made with ❤️ for badminton enthusiasts

# badmintoncounter
