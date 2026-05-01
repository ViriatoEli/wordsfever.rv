🔥 Words Fever — Guida al Progetto
Sviluppatore: Viriato Rivera  
Anno: 2026 — Classe 4I  
Stack: Flutter (App) + HTML/CSS (Landing Page)
---
Struttura del Progetto
```
words_fever/
├── web/
│   └── index.html              ← Landing Page completa
└── flutter/
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── theme/
        │   ├── app_colors.dart
        │   └── app_theme.dart
        └── screens/
            ├── splash_screen.dart   ← Animazione RV + 2-3s
            ├── auth_screen.dart     ← Login / Gioca
            ├── loading_screen.dart  ← Fake progress
            └── home_screen.dart     ← Menu modalità
```
---
Setup Flutter
```bash
# 1. Entra nella cartella flutter
cd flutter

# 2. Installa le dipendenze
flutter pub get

# 3. Avvia su simulatore iOS
flutter run -d ios

# 4. Avvia su Android
flutter run -d android

# 5. Build release
flutter build apk          # Android
flutter build ipa          # iOS (richiede Xcode + Apple Dev Account)
```
---
Flusso Schermate
```
SplashScreen (2.8s)
    │  FadeTransition
    ▼
AuthScreen
    │  FadeTransition (tap GIOCA)
    ▼
LoadingScreen (1.7s fake progress)
    │  SlideTransition + FadeTransition
    ▼
HomeScreen (Menu Modalità)
```
---
Animazioni — Guida Tecnica
Splash Screen
`AnimationController` con `elasticOut` per lo scale-in del logo RV
Sequence: `_scaleCtrl.forward()` → delay 200ms → `_fadeCtrl.forward()`
Flame bars: loop `repeat(reverse: true)` con offset per ogni barra
Auth Screen
5 elementi con `staggered` animations usando `Interval(i * 0.12, ...)`
Ogni elemento fa `Opacity + Transform.translate` per il fade-up effect
Loading Screen
`TweenAnimationBuilder<double>` per la barra progress (smooth interpolation)
`AnimatedSwitcher` per il cambio testo status
Steps temporali via `Future.delayed`
Home Screen
Cards entrano con `staggered` ListView animations
Ogni card ha `AnimatedScale` su press (0.97) per feedback aptico
Settings e logo: fade-in separato
Transizioni tra schermate
```dart
// FadeTransition (Splash → Auth)
PageRouteBuilder(
  transitionsBuilder: (_, animation, __, child) =>
    FadeTransition(opacity: animation, child: child),
)

// Slide + Fade (Loading → Home)  
SlideTransition(
  position: Tween<Offset>(begin: Offset(0, 0.05), end: Offset.zero)
    .animate(CurvedAnimation(curve: Curves.easeOut, ...)),
  child: FadeTransition(opacity: animation, child: child),
)
```
---
TODO — Prossimi Sviluppi
[ ] Logica di gioco per `Indovina la parola`
[ ] Timer + logica bomba per `Bomb Word`
[ ] Sistema ruoli per `Impostor`
[ ] Multiplayer locale per `Spiega la parola`
[ ] Firebase Auth (Google + Facebook)
[ ] Firestore per parole e punteggi
[ ] Screen `Impostazioni` (lingua, timer, difficoltà)
---
Landing Page
Apri `web/index.html` direttamente nel browser.  
Per pubblicarla: caricala su Netlify, Vercel o GitHub Pages (drag & drop).
---
Progetto scolastico — Classe 4I · 2026
