# Quick Start Guide 🚀

## Getting Started in 5 Minutes

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
# For development
flutter run

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

### 3. Start Playing!

## First Time Setup

When you first open the app:
1. You'll see the **Counter** page with "Left" and "Right" as default players
2. The navigation bar at the bottom has 4 tabs:
   - 🏸 Counter
   - 📜 History
   - 📊 Summary
   - ❓ Instructions

## Basic Usage

### Scoring a Point

**Option 1: Touch/Tap**
- Tap the blue box (Left) or green box (Right) to add a point

**Option 2: Keyboard**
- Press `←` or `A` for Left player
- Press `→` or `D` for Right player

**Option 3: Quick Buttons**
- Use the `[+] Left` and `[+] Right` buttons below the score

### Removing a Point
- Click the red `[-]` button under each player's score

### Saving a Game
1. Click the 🔄 reset button in the top-right
2. Choose "Yes" to save to history
3. Enter player names (or use default Left/Right)
4. Add optional remark
5. Click "Save"

### Viewing History
1. Go to History tab
2. Tap any game to edit it
3. Pull down to refresh from server

### Checking Stats
1. Go to Summary tab
2. View leaderboard (sorted by wins)
3. See individual player cards with:
   - Win/Loss record
   - Win rate percentage
   - Average points per game
   - Total points scored

## Tips for Best Experience

### 🎮 Control Tips
- **Keyboard is fastest** for rapid scoring
- **Touch mode** is great for tablets
- **Mouse control** works well on desktop

### 🔥 Streak Feature
- Shows consecutive points with fire emojis
- 1-3 points: Individual emojis (🔥, 🔥🔥, 🔥🔥🔥)
- 4+ points: Compact format (🔥x4, 🔥x5, etc.)
- Great for tracking momentum!

### 🔊 Speech Score
- Turn on the "Speech Score" switch
- App will announce the score after each point
- Perfect when you can't look at the screen

### 📸 Sharing
- Click the share icon in top-right
- Takes a screenshot of current score
- Share to social media or save to photos

## Keyboard Shortcuts Reference

| Key | Action |
|-----|--------|
| `←` or `A` | +1 point to Left |
| `→` or `D` | +1 point to Right |
| `Z` | -1 point from Left |
| `C` | -1 point from Right |
| `R` | Reset game |
| `S` | Toggle speech |

## Common Scenarios

### Scenario: Quick Match
1. Open app (already on Counter page)
2. Use keyboard arrows to score
3. When done, hit `R` to reset
4. Choose "No" if you don't want to save

### Scenario: Tournament Tracking
1. Before starting, customize player names in a saved game
2. Use Speech Score so you can focus on the match
3. Save each game to history
4. Check Summary to see tournament standings

### Scenario: Practice Session
1. Use Counter normally
2. Don't save to history
3. Just reset between games
4. Total Points still tracks your activity

## Troubleshooting

### App won't save history
- Check internet connection
- Verify API server is running at `afwanhaziq.vps.webdock.cloud`

### Speech not working
- Enable microphone permissions
- Check device volume
- Try toggling Speech Score switch

### History not loading
- Pull down to refresh
- Check internet connection
- Restart the app

## Need More Help?

1. **Instructions Tab**: Complete guide in the app
2. **Send Suggestions**: Use the feedback form in Instructions
3. **README.md**: Full documentation in project folder

---

Enjoy tracking your badminton games! 🏸✨

