
# ☁️ Tocaan Weather

A responsive, animated, and production-ready Flutter weather app that delivers a clean user experience and a robust architecture. Built using **GetX**, **MVVM**, and **Hive**, it integrates real-time API data with smart caching and elegant UI.

## 🔍 About the Project

Tocaan Weather is not just a UI project — it was built to reflect real-world practices such as local data persistence, API abstraction, testing readiness, and state clarity. The app handles connectivity issues gracefully, visually communicates data freshness, and adapts well to different screen sizes.

---

## ✅ Features

- **📡 Real-time Weather Data** from a public API (WeatherAPI).
- **⚡ Responsive UI** built with `flutter_screenutil` for all devices.
- **🧠 Smart Debounce**: Avoids excessive API calls while typing.
- **🗃 Hive Caching**: Weather data is stored locally for offline support.
- **🟢 Data Freshness Indicator**: Labels weather data as `Fresh`, `Stale`, or `Expired` based on update time.
- **📴 Offline Awareness**: Clear messaging and fallback to cache when offline.
- **🎯 MVVM Architecture**: Easily testable and scalable project structure.
- **🎨 Weather Animations**: Rain overlay, condition-based effects, and smooth transitions.
- **🌐 Error Handling**: User-friendly `Snackbar` alerts with meaningful icons and messages.
- **🧪 Testability Ready**: Includes service abstraction and separation of concerns.

---

## 📱 Screens

| Feature | Screenshot |
|--------|------------|
| Search & Fetch | ✅ |
| Error & Offline | ✅ |
| Rain Animation | ✅ |
| Empty State UI | ✅ |
| Data Freshness Badge | ✅ |

---

## 🏗 Architecture

```
lib/
├── controllers/          # GetX weather controller with all logic
├── models/               # WeatherModel (Hive-ready)
├── services/             # API and abstraction layers
├── utils/                # Constants, exceptions, cache manager
├── views/                # UI widgets and screens
└── main.dart             # Entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.x
- Hive & Dio dependencies

### Setup
```bash
flutter pub get
flutter packages pub run build_runner build
flutter run
```

### API Key
Uses WeatherAPI (`https://www.weatherapi.com`). Key is stored in `AppConstants`.

---

## ⚙️ Data Freshness Logic

Each weather card shows one of:
- `Fresh` → updated in the last 10 minutes
- `Stale` → 10 to 60 minutes ago
- `Expired` → older than 1 hour

This is based on the `lastUpdated` field stored alongside weather data in Hive.

---

## ✍️ Author

**Mahmoud Ramadan**  
Flutter Developer .   

---

## 📌 Final Notes

This task was implemented from scratch with the following mindset:
- **Maintainability** over shortcuts.
- **User experience** over complexity.
- **Production realism** with error handling, caching, and responsive UI.

Let me know if you'd like access to tests or more advanced state solutions like Riverpod/Bloc integration.

Thanks for reviewing this project.
