# TaskEditor

Clean, native SwiftUI macOS application for editing the task library.

## Building & Running

1. Open `TaskEditor.xcodeproj` in Xcode
2. Select the TaskEditor scheme
3. Press Cmd+R to build and run

## How to Use

1. Place the app inside your silk-sheets folder (or its parent folder)
2. Double-click the app to launch (or run from Xcode)
3. The app will automatically find `data/tasks.js` and `assets/images/`

## Features

- ✅ View all tasks in a scrollable list
- ✅ Search/filter tasks by name
- ✅ Create new tasks
- ✅ Edit existing tasks
- ✅ Delete tasks (with confirmation)
- ✅ Upload images via:
  - Drag & drop
  - File picker
  - Paste (Cmd+V)
- ✅ Auto-resize images to 200x200px
- ✅ Auto-generate task IDs
- ✅ Manual save with Save button
- ✅ Clear form for new tasks

## Architecture

- Pure SwiftUI (no WebView)
- ~400 lines of clean Swift code
- Direct file I/O
- Relative path discovery from app location
- Standard macOS behaviors

## Files

- `TaskEditorApp.swift` - App entry point
- `ContentView.swift` - Main window with task list and editor
- `TaskEditorView.swift` - Task form with image handling
- `TaskManager.swift` - File operations (read/write tasks.js, images)
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
