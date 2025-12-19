# Silk Sheets

This system was originally designed to help my physiotherapist, Alan
Silk, create custom stretching routines for his clients. Hence the
name Silk Sheets. But it is much more general than that. Though the
description below is in terms of “tasks”, it will work for anything
that has a library of entities, each of which has a header, a body of
descriptive text, and a descriptive image.

The system is designed to be used by very non-technical users. Hence
the main application is just a Web page and can run on any
platform. The other is designed to run on MacOS.

## Components

### 1. Taskflow Creator (`taskflow.html`)
Web application for creating custom task sheets:
- Browse task library with search/filter
- Drag tasks to build a sheet
- Print or save as PDF
- Optional letterhead at top of printed sheets
- No server required - runs entirely in browser

**Usage**: Open `taskflow.html` in any modern web browser

### 2. Task Library Editor (`TaskEditor/`)
Native macOS application for managing the task library:
- Create, edit, delete tasks
- Upload and manage task images
- Add/remove letterhead for printed sheets
- Search and filter tasks
- Simple, non-technical interface

**Usage**: Double-click `TaskEditor.app` to launch (no installation required)

**First Launch (macOS 15+)**: The app is unsigned, so macOS will block it. To allow:
1. Try to open the app (it will be blocked)
2. Open System Settings → Privacy & Security
3. Scroll to Security section
4. Click "Open Anyway" next to the TaskEditor message
5. Confirm by clicking "Open"
6. After this one time, it opens normally

## Features

### Taskflow Creator
- ✅ Drag-and-drop task selection
- ✅ Search/filter task library
- ✅ Print-ready output with optional letterhead
- ✅ Responsive design
- ✅ No installation or server required
- ✅ Generic output (not just "tasks")

### Task Editor
- ✅ Full CRUD operations on tasks
- ✅ Image upload (drag, paste, file picker)
- ✅ Letterhead management
- ✅ Alphabetical sorting
- ✅ Confirmation dialogs for deletions
- ✅ Auto-resize images (200x200 for tasks, 800px width for letterhead)

## Data Structure

```
silk-sheets/
├── taskflow.html          # Main web app
├── TaskEditor/            # Task editor app (for end users)
│   └── TaskEditor.app    # Double-click to run
├── data/
│   └── tasks.js          # Task library (JSON in JS file)
├── assets/
│   └── images/           # Task images and letterhead
│       ├── task-*.png    # Individual task images
│       └── letterhead.png # Optional letterhead
├── scripts/
│   ├── app.js           # Main app logic
│   └── taskManager.js   # Task management
├── styles/
│   └── main.css         # Styling
└── TaskEditorSource/     # Source code (for developers)
    └── TaskEditor.xcodeproj
```

## Getting Started

1. **Edit tasks**: Double-click `TaskEditor.app` (no Xcode needed)
2. **Create sheets**: Open `taskflow.html` in a web browser
3. **Print**: Use browser print (Cmd+P) to save as PDF or print

**Important**: Keep the entire `silk-sheets/` folder together when moving or distributing. The app, data files, and web app must remain in their sibling structure.

## For Developers

### Building from Source

To rebuild the TaskEditor app:

1. Open `TaskEditorSource/TaskEditor.xcodeproj` in Xcode
2. Press **Cmd+B** (or Product → Build)
3. Run `make build` to copy the build to TaskEditor/
4. Run `make dist` to create a distribution zip

Or simply run `make` to do steps 3-4 automatically.

See `CLAUDE.md` for detailed development documentation.

## Design Principles

- **Simple**: No servers, databases, or complex setup
- **Non-technical**: Designed for non-technical users
- **Self-contained**: Everything runs locally
- **Printable**: Optimized for paper output
- **Flexible**: Works for any type of items, not just "tasks"

## Requirements

- **Taskflow Creator**: Any modern web browser
- **Task Editor**: macOS 13.0+, Xcode (for building)
