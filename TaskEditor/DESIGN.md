# TaskEditor Design Document

## Purpose
Native macOS app to edit the task library (`data/tasks.js`) and letterhead (`assets/images/letterhead.png`) used by the taskflow creator web app.

## User Profile
Non-technical user who wants a simple, reliable tool to manage exercise tasks and customize printed output.

## Key Design Decisions

### File Location
- App uses source file location (`#file`) to find repository root
- Works both when running from Xcode (DerivedData) and when exported
- **Always uses relative paths** from source files in `TaskEditor/TaskEditor/`
- Navigates up 3 levels to find `data/tasks.js` and `assets/images/`
- No sandboxing - app has full file system access to read/write files

### Task IDs
- **Auto-generated** using timestamp-based unique IDs
- Format: `task-{timestamp}` (e.g., `task-1702234567890`)
- User never sees or edits IDs

### Image Handling
- **Input methods**: Drag-and-drop, Paste from Clipboard button, File picker button
- **Accepted formats**: PNG, JPG, JPEG, GIF, TIFF, BMP (liberal - accept what NSImage can load)
- **Task images**: Always saved as PNG to `assets/images/{taskId}.png`, resized to exactly 200x200px (aspect-fit with letterboxing)
- **Letterhead**: Saved as PNG to `assets/images/letterhead.png`, resized to 800px width with aspect-fit height
- **Preview**: Show current image in editor (200x200 for tasks, full width for letterhead)
- **No Remove button for tasks**: Users can only replace images, maintaining invariant that every task has an image
- **Remove button for letterhead**: Available when letterhead exists, with confirmation dialog

### Letterhead Feature
- **Access**: Button in header (document icon) to open letterhead editor
- **Purpose**: Add custom image to top of all printed sheets (e.g., clinic logo, letterhead)
- **Editor**: Same drag-and-drop, paste, file picker interface as task images
- **Storage**: `assets/images/letterhead.png` (800px width)
- **Display**: Shows at top of printed output in taskflow.html
- **Removal**: Confirmation dialog before deletion
- **Integration**: taskflow.html automatically detects and displays letterhead when printing

### Save Behavior
- **Manual save with Save button** (not auto-save)
- Prevents accidental changes
- Save button disabled until name and image are provided
- Clear visual feedback on save success (green banner)
- Delete requires confirmation dialog

### UI Requirements
- **Task List**: Scrollable, alphabetically sorted by name
- **Search/Filter**: Text field to filter tasks by name
- **Task Editor**: Form with Name, Description, Image upload area
- **Delete**: Confirmation dialog before deletion, removes task AND image
- **Clear button**: Reset form for new task entry
- **Fixed header and footer**: Save/Clear buttons always visible, content scrolls

### Sorting
- Tasks displayed in **alphabetical order** (matching taskflow.html)
### Architecture
- **Pure SwiftUI** - no WebView, no HTML/JS bridge
- **~500 lines of Swift** across 5 files
- **Direct file I/O** - no async bridge complexity
- **Source file path discovery** using `#file` compile-time constant
- **Two editing modes**: Task editor and Letterhead editor (mutually exclusive views)
- Format: `const TASKS_DATA = [...];`
- Each task: `{ "id": "...", "name": "...", "image": "assets/images/...", "description": "..." }`
- Preserve formatting for git-friendly diffs
- Auto-saves after delete operations

### Architecture
- **Pure SwiftUI** - no WebView, no HTML/JS bridge
- **~400 lines of Swift** across 5 files
- **Direct file I/O** - no async bridge complexity
- **Source file path discovery** using `#file` compile-time constant

## Launch Method (Current)
- Open project in Xcode and Run (Cmd+R)
- Export: Product → Archive → Distribute App → Copy App
- Place exported .app in repository folder structure

## Error Handling
- Graceful handling of missing files (create if needed)
- Clear error messages for file access issues
- Validate task data before saving
- Console debug output for path resolution

## System Messages (Ignorable)
When running in Xcode, these harmless system messages appear:
- "Unable to open mach-O at path: default.metallib"
- "fopen failed for data file: errno = 2"
- "Errors found! Invalidating cache..."
- "ViewBridge to RemoteViewService Terminated"

These are normal macOS/SwiftUI framework messages and can be ignored.

## Non-Goals
- No git integration (user manages that)
- No undo/redo (keep it simple)
- No multi-user or cloud sync
- No export/import features
- No keyboard shortcuts for paste (button works reliably)
