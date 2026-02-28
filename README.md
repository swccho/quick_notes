# Quick Notes

A Flutter Desktop note-taking application.

## Description

Quick Notes is a modern desktop note-taking app built with Flutter. It uses local persistent storage (Hive), autosave with debounce, search and filtering, pin/unpin, keyboard shortcuts, light/dark theme, and a resizable sidebar whose width is persisted. You can export a single note to .txt, export or import a full backup as .json, and clear all notes with confirmation.

## Features

- Local persistent storage (Hive)
- Autosave with debounce
- Search and filtering
- Pin/unpin notes
- Keyboard shortcuts
- Theme toggle (light/dark)
- Sidebar resize (persisted)
- Export single note to .txt
- Export/import backup (.json)
- Clear all notes (with confirmation)

## Screenshots

_(Screenshots to be added.)_

## Keyboard Shortcuts

| Shortcut   | Action                 |
| ---------- | ---------------------- |
| Ctrl + N   | New note               |
| Ctrl + S   | Save note              |
| Ctrl + F   | Focus search           |
| Delete     | Delete selected note   |

## Architecture Overview

The app follows a layered structure:

- **models/** — Data only. Immutable note model with `copyWith`, `toJson`, `fromJson` (e.g. `lib/models/note.dart`).
- **services/** — Storage and external I/O. Hive boxes, settings, export/import to files (e.g. `lib/services/note_storage_service.dart`).
- **providers/** — State and business logic. Single `NoteProvider` (ChangeNotifier) for notes, selection, search, theme, sidebar width (e.g. `lib/providers/note_provider.dart`).
- **screens/** — Full-page layout. Home screen with shortcuts and resizable sidebar (e.g. `lib/screens/home_screen.dart`).
- **widgets/** — Reusable UI. Sidebar (list, search, menu, theme, shortcuts) and note editor (e.g. `lib/widgets/sidebar.dart`, `lib/widgets/note_editor.dart`).

## Tech Stack

- Flutter (Desktop; primary target Windows)
- Provider (state management)
- Hive (local storage)
- intl (date/time formatting)
- path_provider, path (export/import paths)
- uuid (note IDs)

## Installation

**Prerequisites:** Flutter SDK, Windows (for desktop run/build).

1. Clone or open the project.
2. Run `flutter pub get`.
3. Run `flutter run -d windows`.

## Build Release

To build a release bundle:

```bash
flutter build windows --release
```

The runnable output is in `build/windows/x64/runner/Release/`. To run or distribute the app, use the **entire** folder (the `.exe` plus `flutter_windows.dll` and other dependencies). Copying only the executable will not work on another machine.

## Project Structure

```
lib/
  main.dart
  app.dart
  models/
    note.dart
  services/
    note_storage_service.dart
  providers/
    note_provider.dart
  screens/
    home_screen.dart
  widgets/
    sidebar.dart
    note_editor.dart
```

## Future Improvements

- File picker for import (instead of pasting path)
- Tags or categories for notes
- Cloud sync
- System tray support
- Optional encryption for notes

## License

This project is provided under the MIT License.
