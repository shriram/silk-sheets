# Development Documentation

This document contains detailed information for developers working on Silk Sheets.

## Project Structure

```
silk-sheets/
├── taskflow.html              # Main web application
├── TaskEditor/                # Built app for distribution
│   └── TaskEditor.app        # macOS native app
├── TaskEditorSource/          # Source code
│   ├── TaskEditor.xcodeproj  # Xcode project
│   ├── TaskEditor/           # Swift source files
│   │   ├── TaskEditorApp.swift
│   │   ├── ContentView.swift
│   │   ├── TaskEditorView.swift
│   │   ├── TaskManager.swift
│   │   └── Models.swift
│   ├── DESIGN.md            # Architecture documentation
│   └── README.md            # TaskEditor-specific docs
├── data/
│   └── tasks.js             # Task library (JSON wrapped in JS)
├── assets/
│   └── images/              # Task images and letterhead
├── scripts/                 # Web app JavaScript
├── styles/                  # Web app CSS
├── Makefile                 # Build automation
└── CLAUDE.md               # This file
```

## Build System

### Quick Start

```bash
# Full build and distribution
make

# Individual steps
make build    # Copy latest Xcode build to TaskEditor/
make dist     # Create distribution zip
make clean    # Remove build artifacts
make help     # Show all targets
```

### Build Workflow

1. **Build in Xcode**: Press Cmd+B (or Product → Build)
   - Xcode builds to `~/Library/Developer/Xcode/DerivedData/`

2. **Copy build**: Run `make build`
   - Automatically finds the latest build in DerivedData
   - Copies to `TaskEditor/TaskEditor.app`

3. **Create distribution**: Run `make dist`
   - Creates `dist/silk-sheets/` with all files
   - Generates `silk-sheets.zip` for distribution
   - Removes quarantine attributes from the app

### Makefile Targets

- `make` (default): Runs `build` + `dist`
- `make build`: Copies latest Xcode build to TaskEditor/
- `make dist`: Creates distribution package
- `make clean`: Removes dist/ folder and .zip file
- `make help`: Shows usage instructions

## Important Implementation Details

### Path Resolution

The TaskEditor app uses **runtime path resolution** to find its data files. This allows the entire folder to be moved anywhere without breaking:

```swift
// In TaskManager.swift
let bundlePath = Bundle.main.bundlePath              // /path/to/silk-sheets/TaskEditor/TaskEditor.app
let repoPath = (bundlePath as NSString).deletingLastPathComponent  // /path/to/silk-sheets/TaskEditor/
let repoRoot = (repoPath as NSString).deletingLastPathComponent    // /path/to/silk-sheets/

tasksFilePath = ((repoRoot as NSString).appendingPathComponent("data") as NSString).appendingPathComponent("tasks.js")
imagesDirectory = ((repoRoot as NSString).appendingPathComponent("assets") as NSString).appendingPathComponent("images")
```

This means:
- The app always looks for `data/tasks.js` and `assets/images/` relative to its location
- The entire `silk-sheets/` folder is portable
- No hardcoded paths or configuration needed

### Type Naming Conflict

The project defines a custom `Task` struct in `Models.swift`, but Swift's concurrency framework also has a generic `Task<Success, Failure>` type. To avoid conflicts:

```swift
// Models.swift
struct TaskItem: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var image: String
    var description: String
}

// Type alias for backward compatibility
typealias Task = TaskItem
```

- Use `TaskItem` in code that might conflict with Swift.Task
- The `Task` alias allows existing code to work unchanged
- JSON encoding/decoding works correctly with the explicit `CodingKeys`

### Data Format

Tasks are stored in `data/tasks.js` as JavaScript to allow easy loading in both Swift and web browsers:

```javascript
const TASKS_DATA = [
  {
    "id": "task-1702234567890",
    "name": "Task Name",
    "image": "assets/images/task-1702234567890.png",
    "description": "Description text..."
  }
];
```

The Swift app:
- Reads the file as a string
- Extracts the JSON array between `const TASKS_DATA = ` and `;`
- Decodes it using `JSONDecoder`
- Writes back with the same format when saving

## Developer Notes

### Shell Alias Compatibility

If you have an `rm` alias (common for safety), the Makefile uses `/bin/rm` explicitly to avoid issues:

```makefile
/bin/rm -rf TaskEditor/TaskEditor.app
```

### Xcode Command Line Tools

The project **does not require** switching from Command Line Tools to full Xcode developer tools. The Makefile uses a runtime approach that works with the default setup:

1. Build in Xcode GUI (Cmd+B)
2. `make build` finds the built app in DerivedData
3. `make dist` packages everything

This avoids requiring ~15GB of additional disk space for xcodebuild support.

### Debug Output

The TaskManager prints debug information on launch:

```
Bundle location: /path/to/TaskEditor.app
Repository root: /path/to/silk-sheets
Tasks file: /path/to/silk-sheets/data/tasks.js
Images dir: /path/to/silk-sheets/assets/images
```

Check the Xcode console or system logs if tasks aren't loading.

## Testing

To test a build:

1. Run `make` to create `silk-sheets.zip`
2. Copy the zip to a different location (e.g., Desktop)
3. Unzip and verify:
   - Open `TaskEditor.app` - should show all tasks
   - Add a new task - should appear in task list
   - Open `taskflow.html` - should show the new task
   - Verify the new task saved to `data/tasks.js` in the **unzipped folder**, not the source folder

## Common Issues

### App shows empty task list

**Cause**: Path resolution is incorrect or the app is looking in the wrong location.

**Debug**: Check console output for the calculated paths. Verify they point to the correct `data/tasks.js`.

### Build not updating

**Cause**: The Makefile is copying an old build from DerivedData.

**Fix**: Clean Xcode build (Cmd+Shift+K), rebuild (Cmd+B), then `make build`.

### Changes don't appear after distribution

**Cause**: Old build in `TaskEditor/` folder.

**Fix**: Always run `make build` after building in Xcode, before running `make dist`.

## Architecture

See [TaskEditorSource/DESIGN.md](TaskEditorSource/DESIGN.md) for detailed architecture documentation.

## Contributing

When making changes:

1. Update source code in `TaskEditorSource/`
2. Build in Xcode (Cmd+B)
3. Run `make build` to copy the build
4. Test the built app in `TaskEditor/`
5. Run `make dist` and test the distributed package
6. Update relevant documentation (this file, README.md, etc.)

## File Modification Notes

- **Makefile**: Uses `/bin/rm` for compatibility with `rm` aliases
- **TaskManager.swift**: Uses `bundlePath` not `bundleURL` to ensure paths resolve correctly when moved
- **Models.swift**: Defines `TaskItem` with `Task` alias to avoid Swift.Task naming conflict
