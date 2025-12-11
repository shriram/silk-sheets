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

## For Developers

To rebuild the TaskEditor app from source:

1. Open `TaskEditorSource/TaskEditor.xcodeproj` in Xcode
2. Select Product → Archive
3. Click "Distribute App"
4. Choose "Copy App"
5. Save the exported app to the `TaskEditor/` folder
6. The app is now ready to distribute to non-technical users

## Design Principles

- **Simple**: No servers, databases, or complex setup
- **Non-technical**: Designed for non-technical users
- **Self-contained**: Everything runs locally
- **Printable**: Optimized for paper output
- **Flexible**: Works for any type of items, not just "tasks"

## Requirements

- **Taskflow Creator**: Any modern web browser
- **Task Editor**: macOS 13.0+, Xcode (for building)
