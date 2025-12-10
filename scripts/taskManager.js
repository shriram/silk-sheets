// REPLACES the entire existing taskManager.js file
class TaskManager {
    constructor() {
        this.tasks = [];
        this.filteredTasks = [];
    }

    async loadTasks() {
        this.tasks = [...TASKS_DATA];
        this.tasks.sort((a, b) => a.name.localeCompare(b.name));
        this.filteredTasks = [...this.tasks];
        return this.tasks;
    }

    filterTasks(searchTerm) {
        const term = searchTerm.toLowerCase();
        this.filteredTasks = this.tasks.filter(task =>
            task.name.toLowerCase().includes(term) ||
            task.description.toLowerCase().includes(term)
        );
        return this.filteredTasks;
    }

    getFilteredTasks() {
        return this.filteredTasks;
    }
}