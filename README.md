# Swallpaper Flutter

Cross-platform wallpaper manager built with Flutter for **Windows** and **Android**.

## Features

| Feature | Windows | Android |
|---------|:-------:|:-------:|
| 🖼 Multi-source wallpapers | ✅ | ✅ |
| 🎬 Video wallpaper preview | ✅ | ✅ |
| ☁️ Cloud sync (OneDrive, iCloud, etc.) | ✅ | ✅ |
| ⭐ Favorites | ✅ | ✅ |
| 📥 Downloads | ✅ | ✅ |
| 🔍 Search | ✅ | ✅ |
| 🖥️ Set as wallpaper | ✅ | ✅ |
| 🎨 Dynamic theme | ✅ | ✅ |

## Wallpaper Sources

- **Wallhaven** - Massive wallpaper database
- **Unsplash** - High-quality photography
- **Pexels** - Free stock photos & videos
- **NASA APOD** - Daily astronomy pictures
- **NASA Images** - NASA image library
- **4K Wallpapers** - Ultra HD wallpapers
- **Coverr** - Free stock videos
- **MotionBG** - Motion backgrounds

## Getting Started

```bash
# Clone the repository
git clone https://github.com/sfyqiu/Swallpaper-Flutter.git
cd Swallpaper-Flutter

# Install dependencies
flutter pub get

# Run on Windows
flutter run -d windows

# Build Android APK
flutter build apk --release

# Build Windows release
flutter build windows --release
```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart               # MaterialApp config
├── config/                # Theme, routes, API config
├── models/                # Data models
├── services/              # API sources, download, wallpaper setter
├── providers/             # State management (Provider/Riverpod)
├── screens/               # UI pages
└── widgets/               # Reusable UI components
```

## License

GNU General Public License v3.0
