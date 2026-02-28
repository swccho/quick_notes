# Quick Notes (Flutter Desktop) — Full Project Description

## What it is

**Quick Notes** is a lightweight **desktop-first notes app** for Windows (and later Mac/Linux) built with **Flutter Desktop**. It focuses on speed: open the app, create a note instantly, search fast, edit with auto-save, and keep everything stored **locally**.

---

## Pages / Screens

### 1) Splash / Boot Screen (optional)

**Purpose:** App initializes storage + loads theme + loads notes.

**What happens:**

- Initialize Hive (or your chosen local DB)
- Open `notes_box`
- Load saved theme mode
- Navigate to Home

**UI:**

- App logo + "Loading notes…"

---

### 2) Home Screen (Main Workspace)

This is the **only required screen** for MVP. It's a split desktop layout.

**Layout:**

- **Left Sidebar**: note list + search + new note
- **Right Editor Pane**: open selected note and edit

**Sections & Features:**

#### A) Top Bar (Header)

- App title: "Quick Notes"
- Theme toggle (Light/Dark)
- (Optional) Settings button

#### B) Sidebar (Left Pane)

**Contains:**

1. **New Note** button
   - Creates a new empty note
   - Auto-selects it
   - Cursor goes to title/content immediately

2. **Search Input**
   - Filters notes by title/content
   - Debounced search for performance

3. **Notes List**
   - Scrollable list of notes
   - Each item shows:
     - Title (or "Untitled")
     - Short content preview (1–2 lines)
     - Last updated time
     - Pin icon (if pinned)
     - Color dot (if enabled)

4. **Sorting / Filters (optional for MVP)**
   - Sort by: Recently updated / Created / Title
   - Filter: Pinned only

#### C) Editor Pane (Right Pane)

Shows when a note is selected.

**Contains:**

- Title input
- Big multi-line content editor
- Updated timestamp ("Last edited: …")
- Action buttons:
  - Delete
  - Pin/Unpin
  - (Optional) Color picker
  - (Optional) Export

**Auto-save behavior:**

- Typing updates provider state
- Provider saves to local DB using debounce (example 300–600ms)
- No "Save" button required (but you can still add Ctrl+S)

---

### 3) Settings Screen (optional but recommended)

**Purpose:** Small settings for a desktop feel.

**Settings:**

- Default theme (Light/Dark/System)
- Font size (small/medium/large)
- Auto-save delay (e.g., 300ms, 600ms, 1s)
- Default new note color
- Data management:
  - Export all notes (JSON/TXT)
  - Import notes (JSON)
  - Clear all notes (danger zone)

---

### 4) About Screen (optional)

- App version
- "Built with Flutter"
- Links (GitHub, website) (optional)

---

## Core Features (MVP)

### Notes Management

- ✅ Create note
- ✅ Edit note (title + content)
- ✅ Auto-save locally
- ✅ Delete note (with confirmation)
- ✅ Notes list with preview and timestamps
- ✅ Select a note to edit

### Search

- ✅ Search by title/content
- ✅ Fast filtering
- ✅ Clear search button

### Theme

- ✅ Light/Dark mode
- ✅ Persist theme choice locally

### Desktop UX

- ✅ Keyboard shortcuts
- ✅ Responsive resizing (sidebar width adapts)
- ✅ Smooth scrolling list

---

## Advanced Features (Phase 2)

### Pin Notes

- Pin/unpin notes
- Pinned notes stay at top
- Filter pinned only

### Note Colors

- Assign a color label to each note
- Color dot in the list

### Export / Import

- Export a single note to `.txt`
- Export all notes to `.json`
- Import notes from `.json`

### Undo / Redo (optional)

- In-editor undo redo support (basic)

### Markdown (optional)

- Markdown preview pane (split view)
- Toggle "Edit / Preview"

---

## Power Features (Phase 3)

### Tags / Categories

- Add tags (e.g., "Work", "Ideas")
- Filter by tags
- Tag manager screen

### Backup & Sync (future)

- Cloud sync (Supabase/Firebase)
- Offline-first: local always wins, sync in background

### Security

- Encrypt notes locally
- App lock with password/PIN
- Locked notes (hide content until unlocked)

### System Tray

- Minimize to tray
- Quick open note from tray
- Global hotkey (Ctrl+Shift+N to open)

---

## Data Model (What we store)

Each note:

- `id`: unique id (uuid)
- `title`: string
- `content`: string
- `createdAt`: DateTime
- `updatedAt`: DateTime
- `isPinned`: bool
- `color`: int (optional)

Storage:

- Hive box: `notes_box`
- Theme box: `settings_box`

---

## Navigation (How many pages do we really need?)

### MVP Navigation (simple)

- Splash (optional)
- Home (main)

### Full App Navigation (recommended)

- Home
- Settings
- About

But still: **Home is the "main app"** (like real desktop note apps).

---

## Keyboard Shortcuts (Desktop Feel)

- **Ctrl + N** → New note
- **Ctrl + F** → Focus search
- **Ctrl + S** → Save now (optional, even though auto-save exists)
- **Ctrl + D** → Delete note (optional)
- **Ctrl + P** → Pin/unpin
- **Esc** → Clear focus / close dialogs

---

## User Flow (How it feels to use)

1. Open app
2. App loads notes instantly
3. Click "New Note"
4. Start typing — it's saved automatically
5. Search to find anything instantly
6. Pin important notes
7. Delete old notes safely
8. Theme stays the way you like next time

---

## MVP Deliverables (What we will build first)

- ✅ Home screen split layout
- ✅ Notes CRUD
- ✅ Local storage
- ✅ Search
- ✅ Theme toggle + persistence
- ✅ Keyboard shortcuts

---

## Next (when ready)

- Exact UI wireframe + widget breakdown
- Folder-by-folder code plan
- Step-by-step build order (like tutorial)
- Data flow diagram (Provider → Storage → UI)
