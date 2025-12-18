# TaskEditor

Clean, native SwiftUI macOS application for editing the task library and letterhead.

## Building & Running

1. Open `TaskEditor.xcodeproj` in Xcode
2. Select the TaskEditor scheme
3. Press Cmd+R to build and run

## How to Use

1. Keep the app as a sibling to `data/` and `assets/` folders in the `silk-sheets/` structure
2. Double-click the app to launch (or run from Xcode)
3. The app will automatically find `data/tasks.js` and `assets/images/` using its bundle location
4. The entire folder can be moved anywhere - paths are resolved at runtime

## Features

### Task Editing
- ✅ View all tasks in a scrollable, alphabetically sorted list
- ✅ Search/filter tasks by name
- ✅ Create new tasks
- ✅ Edit existing tasks
- ✅ Delete tasks (with confirmation)
- ✅ Upload images via:
  - Drag & drop
  - File picker
  - Paste from clipboard button
- ✅ Auto-resize task images to 200x200px
- ✅ Auto-generate task IDs
- ✅ Manual save with Save button
- ✅ Clear form for new tasks

### Letterhead Editing
- ✅ Add custom letterhead image (e.g., clinic logo)
- ✅ Appears at top of all printed sheets
- ✅ Same image upload methods (drag, paste, file picker)
- ✅ Auto-resize to 800px width (aspect-fit height)
- ✅ Remove letterhead with confirmation dialog
- ✅ Access via document icon in header

## Architecture

- Pure SwiftUI (no WebView)
- ~500 lines of clean Swift code
- Direct file I/O
- Runtime path discovery using `Bundle.main.bundleURL` for portability
- Standard macOS behaviors
- Two editing modes: Tasks and Letterhead

## Files

- `TaskEditorApp.swift` - App entry point
- `ContentView.swift` - Main window with task list, editor, and letterhead editor
- `TaskEditorView.swift` - Task form and letterhead form with image handling
- `TaskManager.swift` - File operations (read/write tasks.js, images, letterhead)
- `Models.swift` - Data structures

## Data Format

Reads and writes `data/tasks.js` as:
```javascript
const TASKS_DATA = [
  {
    "id": "task-1702234567890",
    "name": "Task Name",
    "image": "assets/images/task-1702234567890.png",
    "description": "Description..."
  }
];
```

Images are saved as PNG to `assets/images/` with task ID as filename.
