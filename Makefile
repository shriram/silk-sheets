.PHONY: all dist clean help build

# Distribution settings
DIST_NAME = silk-sheets
DIST_DIR = dist
XCODE_BUILD_DIR = $(HOME)/Library/Developer/Xcode/DerivedData

help:
	@echo "Silk Sheets Distribution Makefile"
	@echo ""
	@echo "WORKFLOW:"
	@echo "  1. Open TaskEditorSource/TaskEditor.xcodeproj in Xcode"
	@echo "  2. Press Cmd+B (or Product → Build)"
	@echo "  3. Run 'make build' to copy the build to TaskEditor/"
	@echo "  4. Run 'make dist' to create distribution zip"
	@echo ""
	@echo "  Or simply: 'make' (runs build + dist automatically)"
	@echo ""
	@echo "TARGETS:"
	@echo "  make         - Build and create distribution (default)"
	@echo "  make build   - Copy latest Xcode build to TaskEditor/ folder"
	@echo "  make dist    - Create distributable zip file"
	@echo "  make clean   - Remove distribution files"
	@echo "  make help    - Show this help message"

all: build dist

# Copy latest Xcode build to TaskEditor folder
build:
	@echo "Finding latest TaskEditor build..."
	@latest=$$(find $(XCODE_BUILD_DIR) -name "TaskEditor.app" -path "*/Build/Products/Debug/*" -type d -exec stat -f "%m %N" {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-); \
	if [ -z "$$latest" ]; then \
		echo "Error: No TaskEditor build found in Xcode DerivedData"; \
		echo "Please build the app in Xcode first (Cmd+B)"; \
		exit 1; \
	fi; \
	echo "Found: $$latest"; \
	echo "Copying to TaskEditor/..."; \
	/bin/rm -rf TaskEditor/TaskEditor.app; \
	cp -R "$$latest" TaskEditor/; \
	echo "✓ Build copied successfully"

# Create distribution zip (assumes app is already built)
dist:
	@if [ ! -d "TaskEditor/TaskEditor.app" ]; then \
		echo "Error: TaskEditor.app not found!"; \
		echo "Please build and export the app first:"; \
		echo "  1. Open TaskEditorSource/TaskEditor.xcodeproj in Xcode"; \
		echo "  2. Product → Archive"; \
		echo "  3. Distribute App → Copy App"; \
		echo "  4. Save to TaskEditor/ folder"; \
		exit 1; \
	fi
	@echo "Creating distribution package..."
	@/bin/rm -rf $(DIST_DIR)
	@mkdir -p $(DIST_DIR)/$(DIST_NAME)
	
	@echo "Copying files..."
	@cp taskflow.html $(DIST_DIR)/$(DIST_NAME)/
	@cp -R data $(DIST_DIR)/$(DIST_NAME)/
	@cp -R assets $(DIST_DIR)/$(DIST_NAME)/
	@cp -R scripts $(DIST_DIR)/$(DIST_NAME)/
	@cp -R styles $(DIST_DIR)/$(DIST_NAME)/
	@cp -R TaskEditor $(DIST_DIR)/$(DIST_NAME)/
	
	@echo "Removing quarantine attributes..."
	@xattr -cr $(DIST_DIR)/$(DIST_NAME)/TaskEditor/TaskEditor.app 2>/dev/null || true
	
	@echo "Creating README..."
	@echo "Silk Sheets - Custom Task Sheet Creator" > $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "QUICK START:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "1. Edit Tasks:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Open the TaskEditor folder" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   FIRST TIME ONLY (macOS Security):" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Try to open TaskEditor.app (it will be blocked - this is normal)" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Open System Settings" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Go to Privacy & Security" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Scroll down to the Security section" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Click 'Open Anyway' next to the TaskEditor message" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Confirm by clicking 'Open'" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - After this one time, it will open normally" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   Then:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Add, edit, or delete tasks" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "2. Create Sheets:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   Note: macOS may ask for permission on first launch." >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   If you see a security warning, right-click the app and choose \"Open\"" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "2. Create Sheets:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Open taskflow.html in any web browser" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Drag tasks from the library on the left" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Click Print to save as PDF" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "3. Optional Letterhead:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - In TaskEditor.app, click the document icon" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - Add your clinic logo or letterhead image" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "   - It will appear at the top when you print" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "FOLDER STRUCTURE:" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- taskflow.html     : Main application (open in browser)" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- TaskEditor/       : Task editor application" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- data/             : Task library data" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- assets/           : Task images and letterhead" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- scripts/          : Application code" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "- styles/           : Styling" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "" >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	@echo "For questions or issues, contact your administrator." >> $(DIST_DIR)/$(DIST_NAME)/README.txt
	
	@echo "Creating zip file..."
	cd $(DIST_DIR) && zip -r ../$(DIST_NAME).zip $(DIST_NAME) -x "*.DS_Store"
	@echo ""
	@echo "✓ Distribution created: $(DIST_NAME).zip"
	@echo "  Size: $$(du -h $(DIST_NAME).zip | cut -f1)"
	@echo ""
	@echo "You can now upload $(DIST_NAME).zip to your web server."

# Clean build artifacts and distribution
clean:
	@echo "Cleaning distribution files..."
	@/bin/rm -rf $(DIST_DIR)
	@/bin/rm -f $(DIST_NAME).zip
	@echo "✓ Clean complete"