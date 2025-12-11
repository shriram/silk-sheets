# How to Export TaskEditor.app

Follow these steps to create a standalone .app that can be distributed to non-technical users:

## Steps

1. **Open the project in Xcode**
   ```bash
   open TaskEditorSource/TaskEditor.xcodeproj
   ```

2. **Build for Release**
   - In Xcode, select Product → Scheme → Edit Scheme
   - Under "Run", change Build Configuration to "Release" (optional but recommended)
   - Click "Close"

3. **Archive the app**
   - Select Product → Archive
   - Wait for the build to complete
   - The Organizer window will open

4. **Distribute the app**
   - In the Organizer, click "Distribute App"
   - Select "Copy App"
   - Click "Next"
   - Choose a location to save (recommend: Desktop)
   - Click "Export"

5. **Move to repository**
   ```bash
   mv ~/Desktop/TaskEditor.app /Users/sk/Desktop/r/sk/silk-sheets/TaskEditor/
   ```

6. **Verify it works**
   ```bash
   open /Users/sk/Desktop/r/sk/silk-sheets/TaskEditor/TaskEditor.app
   ```

## Result

You'll have a `TaskEditor.app` file in the repository root that:
- Can be double-clicked to run (no Xcode needed)
- Contains all dependencies
- Works on any Mac with macOS 13.0 or later
- Can be distributed via git, zip file, cloud storage, etc.

## For Your Doctor

Just tell them: "Double-click TaskEditor.app to edit tasks"

No Xcode, no installation, no technical knowledge required!

## Notes

- The app is ~1-2 MB in size
- First launch may show a security warning (right-click → Open to bypass)
- The app will automatically find the data/ and assets/ folders
- Can be committed to git for version control
