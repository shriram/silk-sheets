const taskManager = new TaskManager();
let draggedTaskData = null;

async function init() {
    await taskManager.loadTasks();
    renderTaskList();
    setupEventListeners();
}

function renderTaskList() {
    const taskList = document.getElementById('taskList');
    const tasks = taskManager.getFilteredTasks();
    
    taskList.innerHTML = tasks.map((task, index) => `
        <div class="task-item" draggable="true" data-task-index="${index}">
            <img src="${task.image}" alt="${task.name}">
            <div class="task-item-name">${task.name}</div>
        </div>
    `).join('');

    document.querySelectorAll('.task-item').forEach(item => {
        item.addEventListener('dragstart', handleDragStart);
        item.addEventListener('dragend', handleDragEnd);
    });
}

function handleDragStart(e) {
    const taskIndex = parseInt(e.currentTarget.dataset.taskIndex);
    draggedTaskData = taskManager.getFilteredTasks()[taskIndex];
    e.currentTarget.style.opacity = '0.5';
}

function handleDragEnd(e) {
    e.currentTarget.style.opacity = '1';
}

function setupEventListeners() {
    const searchInput = document.getElementById('search');
    searchInput.addEventListener('input', (e) => {
        taskManager.filterTasks(e.target.value);
        renderTaskList();
    });

    const patientTasks = document.getElementById('patientTasks');
    patientTasks.addEventListener('dragover', handleDragOver);
    patientTasks.addEventListener('dragleave', handleDragLeave);
    patientTasks.addEventListener('drop', handleDrop);

    document.getElementById('printButton').addEventListener('click', () => {
        window.print();
    });
}

function handleDragOver(e) {
    e.preventDefault();
    e.currentTarget.classList.add('drag-over');
}

function handleDragLeave(e) {
    if (e.currentTarget === e.target) {
        e.currentTarget.classList.remove('drag-over');
    }
}

function handleDrop(e) {
    e.preventDefault();
    e.currentTarget.classList.remove('drag-over');
    
    if (draggedTaskData) {
        addTaskToPatientSheet(draggedTaskData);
        draggedTaskData = null;
    }
}

function addTaskToPatientSheet(task) {
    const patientTasks = document.getElementById('patientTasks');
    
    const taskElement = document.createElement('div');
    taskElement.className = 'patient-task';
    taskElement.innerHTML = `
        <div class="patient-task-content">
            <h3>${task.name}</h3>
            <div class="patient-task-description">${task.description}</div>
        </div>
        <img src="${task.image}" alt="${task.name}">
        <button class="remove-task" onclick="this.parentElement.remove()">×</button>
    `;
    
    patientTasks.appendChild(taskElement);
}

init();