import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct TaskEditorView: View {
    @Binding var task: Task?
    let taskManager: TaskManager
    let onSave: () -> Void
    let onDelete: (Task) -> Void
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var image: NSImage?
    @State private var imagePath: String = ""
    @State private var isDragging: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(task == nil ? "New Task" : "Edit Task")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                if task != nil {
                    Button(role: .destructive, action: {
                        if let task = task {
                            onDelete(task)
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Name")
                            .font(.headline)
                        TextField("Enter task name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Description Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Image Upload
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Image")
                            .font(.headline)
                        
                        ImageDropZone(
                            image: $image,
                            isDragging: $isDragging,
                            onImageSelected: { newImage in
                                image = newImage
                            }
                        )
                    }
                }
                .padding(20)
            }
            
            // Action Buttons - Always visible at bottom
            Divider()
            HStack(spacing: 12) {
                Button("Clear") {
                    clearForm()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Save") {
                    saveTask()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || image == nil)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .onChange(of: task) { _ in
            loadTaskIntoForm(task)
        }
        .onAppear {
            loadTaskIntoForm(task)
        }
    }
    
    private func loadTaskIntoForm(_ task: Task?) {
        if let task = task {
            name = task.name
            description = task.description
            imagePath = task.image
            
            // Load image from file using source file location
            let sourceFileURL = URL(fileURLWithPath: #file)
            let repoURL = sourceFileURL
                .deletingLastPathComponent()  // Remove TaskEditorView.swift
                .deletingLastPathComponent()  // Remove TaskEditor2
                .deletingLastPathComponent()  // Remove TaskEditor2
            
            let fullImagePath = repoURL.appendingPathComponent(task.image).path
            
            if let loadedImage = NSImage(contentsOfFile: fullImagePath) {
                image = loadedImage
            } else {
                image = nil
                print("Failed to load image from: \(fullImagePath)")
            }
        } else {
            clearForm()
        }
    }
    
    private func clearForm() {
        name = ""
        description = ""
        image = nil
        imagePath = ""
        task = nil
    }
    
    private func saveTask() {
        guard !name.isEmpty, let image = image else { return }
        
        let taskId = task?.id ?? taskManager.generateTaskId()
        
        // Save image and get path
        if let savedImagePath = taskManager.saveImage(image, taskId: taskId) {
            let newTask = Task(
                id: taskId,
                name: name,
                image: savedImagePath,
                description: description
            )
            
            // Update or add task
            if let existingIndex = taskManager.tasks.firstIndex(where: { $0.id == taskId }) {
                taskManager.tasks[existingIndex] = newTask
            } else {
                taskManager.tasks.append(newTask)
            }
            
            // Save to file
            taskManager.saveTasks()
            
            // Update binding
            task = newTask
            
            onSave()
        }
    }
}

struct ImageDropZone: View {
    @Binding var image: NSImage?
    @Binding var isDragging: Bool
    let onImageSelected: (NSImage) -> Void
    
    var body: some View {
        VStack {
            if let image = image {
                // Show current image
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .border(Color.gray.opacity(0.3), width: 1)
                
                HStack(spacing: 12) {
                    Button("Choose File") {
                        selectImageFile()
                    }
                    
                    Button("Paste from Clipboard") {
                        pasteImage()
                    }
                }
                .padding(.top, 8)
            } else {
                // Drop zone
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("Drag & drop image here")
                        .font(.headline)
                    
                    Text("or")
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        Button("Choose File") {
                            selectImageFile()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Paste from Clipboard") {
                            pasteImage()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .frame(width: 300, height: 200)
                .background(isDragging ? Color.accentColor.opacity(0.1) : Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: [8])
                        )
                        .foregroundColor(isDragging ? .accentColor : .gray.opacity(0.5))
                )
            }
        }
        .onDrop(of: [.image, .fileURL], isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, error in
                    if let data = item as? Data, let nsImage = NSImage(data: data) {
                        DispatchQueue.main.async {
                            onImageSelected(nsImage)
                        }
                    } else if let url = item as? URL, let nsImage = NSImage(contentsOf: url) {
                        DispatchQueue.main.async {
                            onImageSelected(nsImage)
                        }
                    }
                }
                return true
            }
            
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil),
                       let nsImage = NSImage(contentsOf: url) {
                        DispatchQueue.main.async {
                            onImageSelected(nsImage)
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    private func selectImageFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image, .png, .jpeg, .gif, .tiff, .bmp]
        
        if panel.runModal() == .OK, let url = panel.url, let nsImage = NSImage(contentsOf: url) {
            onImageSelected(nsImage)
        }
    }
    
    private func pasteImage() {
        let pasteboard = NSPasteboard.general
        
        if let imageData = pasteboard.data(forType: .tiff),
           let nsImage = NSImage(data: imageData) {
            onImageSelected(nsImage)
        } else if let imageData = pasteboard.data(forType: .png),
                  let nsImage = NSImage(data: imageData) {
            onImageSelected(nsImage)
        } else if pasteboard.canReadItem(withDataConformingToTypes: [NSPasteboard.PasteboardType.fileURL.rawValue]) {
            if let url = pasteboard.readObjects(forClasses: [NSURL.self])?.first as? URL,
               let nsImage = NSImage(contentsOf: url) {
                onImageSelected(nsImage)
            }
        }
    }
}
