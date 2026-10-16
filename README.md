# 🗄️ Flutter Offline-First Starter (Drift · Riverpod · Clean Architecture)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Database](https://img.shields.io/badge/Persistence-Drift_(SQLite)-00B4AB)
![State Management](https://img.shields.io/badge/State_Management-Riverpod_2.x-00C853)
![Architecture](https://img.shields.io/badge/Pattern-Transactional_Outbox_%26_OCC-FF6D00)

A production-grade **Offline-First** reference architecture demonstrating **local SQLite persistence with Drift**, **Transactional Outbox synchronization**, **Optimistic Concurrency Control (OCC) conflict resolution**, and **SQLite-level pagination & search**.

---

## 🏗️ Why Most "Offline" Apps Fail in Production (And How This Solves It)

1. **The Hard-Delete Trap:** If a user deletes a record while offline and you immediately `DELETE FROM table`, the sync engine forgets the record ever existed—leaving orphaned data on the server.
   * **Solution (`Tombstone Pattern`):** Synced notes are soft-deleted locally (`SyncState.pendingDelete`), hidden from UI queries, pushed as `DELETE` mutations during sync, and hard-purged only after server acknowledgment.
2. **Silent Data Overwrites (Last-Write-Wins Data Loss):** Overwriting server rows blindly destroys concurrent edits made on other devices.
   * **Solution (`Version Vectors`):** Every note tracks `baseVersion` (last known server revision) and `localVersion`. If the remote server's `serverVersion > clientBaseVersion`, a `409 Conflict` state is persisted alongside the remote payload so the user can choose **Keep Local**, **Accept Remote**, or **Merge Both**.
3. **In-Memory Filtering Bottlenecks:** Loading 10,000 rows into Dart memory and running `.where()` freezes the UI isolate.
   * **Solution (`SQLite Indexed Pagination`):** Search (`LIKE`), category filters, sync status filters, and `LIMIT / OFFSET` pagination run directly inside SQLite via composite indexes (`idx_notes_updated`, `idx_notes_sync_state`).

---

## 📂 Architecture Overview

```
flutter_offline_first_starter/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── database/
│   │   │   ├── app_database.dart          # Drift SQLite schema, indexes & DAO queries
│   │   │   ├── app_database.g.dart        # Generated Drift code (run build_runner)
│   │   │   └── connection/
│   │   │       └── native_connection.dart # LazyDatabase + sqlite3 isolate setup
│   │   ├── di/
│   │   │   └── core_providers.dart        # Riverpod DI graph (DB, Remote Sim, Repo)
│   │   └── theme/
│   │       └── app_theme.dart             # Developer-grade dark theme tokens
│   └── features/
│       └── notes/
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── note_entity.dart
│           │   │   ├── note_filter.dart
│           │   │   └── sync_summary.dart
│           │   └── repositories/
│           │       └── notes_repository.dart      # Pure Dart Repository Interface
│           ├── data/
│           │   ├── datasources/
│           │   │   └── simulated_remote_datasource.dart # Controllable Cloud & 409 Conflict Simulator
│           │   ├── mappers/
│           │   │   └── note_mapper.dart
│           │   └── repositories/
│           │       └── drift_notes_repository.dart # Offline-first Outbox & Sync Engine
│           └── presentation/
│               ├── providers/
│               │   ├── notes_filter_notifier.dart
│               │   ├── paginated_notes_notifier.dart
│               │   └── sync_engine_notifier.dart
│               ├── pages/
│               │   └── notes_workspace_page.dart
│               └── widgets/
│                   ├── sync_telemetry_bar.dart
│                   ├── conflict_resolution_dialog.dart
│                   ├── note_editor_sheet.dart
│                   └── note_card_widget.dart
└── test/
    └── features/
        └── notes/
            └── drift_notes_repository_test.dart   # In-memory SQLite Unit & Conflict Tests
```

---

## 🚀 Quick Start & Reproducible Conflict Walkthrough

```bash
git clone https://github.com/RahimUllahAxlic/flutter_offline_first_starter.git
cd flutter_offline_first_starter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### How to Test 409 Conflict Resolution (No Backend Setup Required)
1. Tap the **Dataset Icon** (top-right) to seed 35 local notes, or create a new note.
2. Toggle **"Simulate 409 Server Conflict on Next Push"** in the Telemetry Header.
3. Tap the **Sync Icon** (top-right).
4. Observe the red **409 CONFLICT (Tap to Resolve)** badge appear on the top note.
5. Tap the conflicted note to inspect the **Side-by-Side Version Diff Dialog** (Local Outbox Version vs Remote Server Version) and resolve it using **Merge Both**, **Force Keep Local**, or **Accept Remote**.

---

## 🧪 Run In-Memory SQLite Unit Tests

```bash
flutter test
```
