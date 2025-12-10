import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var selectedTask: Task?
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var taskToDelete: Task?
    @State private var showingSaveSuccess = false
    
    var filteredTasks: [Task] {
        let tasks = searchText.isEmpty ? taskManager.tasks : taskManager.tasks.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return tasks.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        HSplitView {
            // Left: Task List
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Task Library")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search tasks...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(8)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Task List
                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(filteredTasks) { task in
                            TaskRow(task: task, isSelected: selectedTask?.id == task.id)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedTask = task
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // New Task Button
                Button(action: {
                    selectedTask = nil
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Task")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .frame(minWidth: 300, maxWidth: 400)
            
            // Right: Task Editor
            TaskEditorView(
                task: $selectedTask,
                taskManager: taskManager,
                onSave: {
                    showingSaveSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingSaveSuccess = false
                    }
                },
                onDelete: { task in
                    taskToDelete = task
                    showingDeleteAlert = true
                }
            )
        }
        .frame(minWidth: 1000, minHeight: 600)
        .onAppear {
            taskManager.loadTasks()
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert, presenting: taskToDelete) { task in
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                taskManager.deleteTask(task)
                if selectedTask?.id == task.id {
                    selectedTask = nil
                }
            }
        } message: { task in
            Text("Are you sure you want to delete '\(task.name)'? This cannot be undone.")
        }
        .overlay(alignment: .top) {
            if showingSaveSuccess {
                Text("✓ Saved successfully")
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 20)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showingSaveSuccess)
    }
}

struct TaskRow: View {
    let task: Task
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(task.name)
                .font(.system(size: 14))
                .lineLimit(1)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isSelected ? Color.accentColor.opacity(0.2) : Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
    }
}
