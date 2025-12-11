import Foundation
import AppKit

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var errorMessage: String?
    
    private let tasksFilePath: String
    private let imagesDirectory: String
    
    init() {
        // Use the source file location to find the repository root
        // This works both when running from Xcode and when exported
        let sourceFileURL = URL(fileURLWithPath: #file)
        // #file gives us: /Users/sk/Desktop/r/sk/silk-sheets/TaskEditor2/TaskEditor2/TaskManager.swift
        // Go up 3 levels: TaskManager.swift -> TaskEditor2 -> TaskEditor2 -> silk-sheets
        let repoURL = sourceFileURL
            .deletingLastPathComponent()  // Remove TaskManager.swift
            .deletingLastPathComponent()  // Remove TaskEditor2
            .deletingLastPathComponent()  // Remove TaskEditor2
        
        tasksFilePath = repoURL.appendingPathComponent("data").appendingPathComponent("tasks.js").path
        imagesDirectory = repoURL.appendingPathComponent("assets").appendingPathComponent("images").path
        
        print("Repository root: \(repoURL.path)")
        print("Tasks file: \(tasksFilePath)")
        print("Images dir: \(imagesDirectory)")
    }
    
    func loadTasks() {
        do {
            let content = try String(contentsOfFile: tasksFilePath, encoding: .utf8)
            
            // Parse the JavaScript file to extract JSON array
            // Format: const TASKS_DATA = [...];
            if let startRange = content.range(of: "const TASKS_DATA = "),
               let endRange = content.range(of: ";", options: [], range: startRange.upperBound..<content.endIndex) {
                let jsonString = String(content[startRange.upperBound..<endRange.lowerBound])
                
                if let jsonData = jsonString.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    tasks = try decoder.decode([Task].self, from: jsonData)
                    errorMessage = nil
                }
            }
        } catch {
            errorMessage = "Error loading tasks: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    func saveTasks() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(tasks)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // Format as JavaScript file
                let jsContent = "const TASKS_DATA = \(jsonString);\n"
                try jsContent.write(toFile: tasksFilePath, atomically: true, encoding: .utf8)
                errorMessage = nil
            }
        } catch {
            errorMessage = "Error saving tasks: \(error.localizedDescription)"
            print(errorMessage ?? "")
        }
    }
    
    func saveImage(_ image: NSImage, taskId: String) -> String? {
        // Resize to 200x200
        let resized = resizeImage(image, targetSize: NSSize(width: 200, height: 200))
        
        // Convert to PNG
        guard let tiffData = resized.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        
        // Save to file
        let filename = "\(taskId).png"
        let filePath = (imagesDirectory as NSString).appendingPathComponent(filename)
        
        do {
            // Ensure images directory exists
            try FileManager.default.createDirectory(atPath: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
            try pngData.write(to: URL(fileURLWithPath: filePath))
            return "assets/images/\(filename)"
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func deleteImage(_ imagePath: String) {
        let filename = (imagePath as NSString).lastPathComponent
        let fullPath = (imagesDirectory as NSString).appendingPathComponent(filename)
        
        try? FileManager.default.removeItem(atPath: fullPath)
    }
    
    func deleteTask(_ task: Task) {
        deleteImage(task.image)
        tasks.removeAll { $0.id == task.id }
        saveTasks()  // Save to file after deleting
    }
    
    private func resizeImage(_ image: NSImage, targetSize: NSSize) -> NSImage {
        let newImage = NSImage(size: targetSize)
        newImage.lockFocus()
        
        // Calculate aspect fit
        let imageSize = image.size
        let widthRatio = targetSize.width / imageSize.width
        let heightRatio = targetSize.height / imageSize.height
        let scale = min(widthRatio, heightRatio)
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        let x = (targetSize.width - scaledWidth) / 2
        let y = (targetSize.height - scaledHeight) / 2
        
        image.draw(in: NSRect(x: x, y: y, width: scaledWidth, height: scaledHeight),
                   from: NSRect(origin: .zero, size: imageSize),
                   operation: .sourceOver,
                   fraction: 1.0)
        
        newImage.unlockFocus()
        return newImage
    }
    
    func generateTaskId() -> String {
        return "task-\(Int(Date().timeIntervalSince1970 * 1000))"
    }
    
    // MARK: - Letterhead Management
    
    private var letterheadPath: String {
        return (imagesDirectory as NSString).appendingPathComponent("letterhead.png")
    }
    
    func hasLetterhead() -> Bool {
        return FileManager.default.fileExists(atPath: letterheadPath)
    }
    
    func loadLetterhead() -> NSImage? {
        if hasLetterhead() {
            return NSImage(contentsOfFile: letterheadPath)
        }
        return nil
    }
    
    func saveLetterhead(_ image: NSImage) {
        // Save letterhead at full width (e.g., 800px wide) instead of 200x200
        let targetWidth: CGFloat = 800
        let aspectRatio = image.size.height / image.size.width
        let targetHeight = targetWidth * aspectRatio
        
        let resized = resizeImage(image, targetSize: NSSize(width: targetWidth, height: targetHeight))
        
        // Convert to PNG
        guard let tiffData = resized.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return
        }
        
        // Save to file
        do {
            try FileManager.default.createDirectory(atPath: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
            try pngData.write(to: URL(fileURLWithPath: letterheadPath))
        } catch {
            print("Error saving letterhead: \(error)")
        }
    }
    
    func deleteLetterhead() {
        try? FileManager.default.removeItem(atPath: letterheadPath)
    }
}
