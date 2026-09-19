# Block Surge: 8x8 Color Puzzle

A production-level, offline-first casual mobile puzzle game built with **Flutter** and the **Flame Game Engine**, targeted for Android and Google Play Store distribution.

## Architecture Overview

```
lib/
├── main.dart                       # Entry point, orientation locking & service bootstrap
├── app/
│   ├── app.dart                    # MaterialApp declaration
│   ├── app_theme.dart              # Dark mode gaming theme
│   └── routes.dart                 # Navigation routes
├── game/
│   ├── block_blast_game.dart       # Core FlameGame loop, pan gesture router & callbacks
│   ├── components/
│   │   ├── block_component.dart    # 20-30% 3D beveled block painter
│   │   ├── board_component.dart    # 8x8 grid rendering & snap ghost preview
│   │   ├── piece_component.dart    # Interactive draggable piece component
│   │   ├── piece_tray_component.dart # 3-piece tray management
│   │   ├── particle_component.dart # High-performance particle engine (bursts/stars/confetti)
│   │   ├── score_component.dart    # Floating score indicators
│   │   └── combo_component.dart    # Animated combo banner
│   ├── models/
│   │   ├── block.dart              # Block color theme & index
│   │   ├── board_cell.dart         # Cell occupancy & clearing state
│   │   ├── block_piece.dart        # Polyomino coordinates & dimensions
│   │   └── game_state.dart         # Game status state machine
│   ├── systems/
│   │   ├── board_system.dart       # Grid logic & row/column clear detection
│   │   ├── piece_generator.dart    # Fair randomizer with board-capacity checks
│   │   ├── scoring_system.dart     # Centralized score formula calculation
│   │   ├── combo_system.dart       # Consecutive clear multiplier
│   │   ├── game_over_system.dart   # Fit verification across tray pieces
│   │   └── input_system.dart       # Touch drag state & vertical finger offset
│   └── config/
│       ├── game_config.dart        # Dimension, points, offsets & radii
│       ├── color_config.dart       # 8-color vibrant palette with highlight/shadow/glow
│       └── animation_config.dart   # Standardized animation durations
├── screens/
│   ├── home_screen.dart            # Start screen with high score, play button & daily challenge
│   ├── game_screen.dart            # Flutter shell hosting Flame GameWidget + Top HUD
│   ├── settings_screen.dart        # Audio, music, haptic toggles & stats reset
│   └── game_over_screen.dart       # Animated score counter, new record celebration & replay
├── services/
│   ├── audio_service.dart          # Sound effects and BGM abstraction
│   ├── vibration_service.dart      # Haptic feedback integration
│   └── storage_service.dart        # SharedPreferences local persistence
└── widgets/
    ├── game_button.dart            # Tactile 3D beveled push button
    ├── score_display.dart          # Top HUD (crown best score, current score, settings)
    ├── settings_tile.dart          # Custom card toggle widget
    └── animated_text.dart          # Breathing pulse title animation
```

## How to Run in Android Studio

1. **Prerequisites**: Install Flutter SDK (>= 3.16.0) and Android Studio.
2. **Open Project**: Launch Android Studio, select **Open**, and choose this root directory.
3. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run on Device / Emulator**:
   Connect an Android phone (with USB debugging enabled) or start an Android Virtual Device (AVD), then execute:
   ```bash
   flutter run
   ```
5. **Build Android Release Bundle (AAB for Google Play)**:
   ```bash
   flutter build appbundle --release
   ```
