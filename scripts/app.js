const taskManager = new TaskManager();
let draggedTaskData = null;

async function init() {
    await taskManager.loadTasks();
    renderTaskList();
    setupEventListeners();
    checkForLetterhead();
}

function checkForLetterhead() {
    // Check if letterhead exists (with cache-busting)
    const img = new Image();
    img.src = 'assets/images/letterhead.png?t=' + new Date().getTime();
    img.onload = function() {
        // Letterhead exists, enable it
        document.body.classList.add('has-letterhead');
        insertLetterheadIntoTasks();
        console.log('Letterhead loaded successfully');
    };
    img.onerror = function() {
        // No letterhead, remove the class if it exists
        document.body.classList.remove('has-letterhead');
        console.log('No letterhead found');
    };
}

function insertLetterheadIntoTasks() {
    if (!document.body.classList.contains('has-letterhead')) {
        return;
    }
    
    const patientTasks = document.getElementById('patientTasks');
    
    // Remove existing letterheads first
    patientTasks.querySelectorAll('.letterhead').forEach(lh => lh.remove());
    
    // Insert letterhead at the top (only once)
    const letterheadImg = document.createElement('img');
    letterheadImg.src = 'assets/images/letterhead.png';
    letterheadImg.className = 'letterhead';
    letterheadImg.alt = 'Letterhead';
    patientTasks.insertBefore(letterheadImg, patientTasks.firstChild);
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
    
    // Remove empty state if it exists
    const emptyState = patientTasks.querySelector('.empty-state');
    if (emptyState) {
        emptyState.remove();
    }
    
    const taskElement = document.createElement('div');
    taskElement.className = 'patient-task';
    taskElement.innerHTML = `
        <div class="patient-task-content">
            <h3>${task.name}</h3>
            <div class="patient-task-description">${task.description}</div>
        </div>
        <img src="${task.image}" alt="${task.name}">
        <button class="remove-task" onclick="removePatientTask(this)">×</button>
    `;
    
    patientTasks.appendChild(taskElement);
    insertLetterheadIntoTasks(); // Refresh letterheads
}

function removePatientTask(button) {
    button.parentElement.remove();
    insertLetterheadIntoTasks();
    
    // Show empty state if no tasks remain
    const patientTasks = document.getElementById('patientTasks');
    const tasks = patientTasks.querySelectorAll('.patient-task');
    if (tasks.length === 0) {
        const emptyState = document.createElement('div');
        emptyState.className = 'empty-state';
        emptyState.textContent = 'Drag items here from the library to build your sheet';
        patientTasks.appendChild(emptyState);
    }
}

init();