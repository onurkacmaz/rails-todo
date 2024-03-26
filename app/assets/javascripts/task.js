function ready(fn) {
    if (document.readyState !== 'loading') {
        fn();
    } else {
        document.addEventListener('DOMContentLoaded', fn);
    }
}

ready(async function () {
    let links = document.querySelectorAll('.delete-task');
    links.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            let taskId = link.getAttribute('href').split('/').pop();
            deleteTask(taskId);
        });
    });

    let showLinks = document.querySelectorAll('.show-task');
    showLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            let taskId = link.getAttribute('href').split('/').pop();
            getTask(taskId)
                .then((task) => {
                    let taskModal = document.querySelector('#taskModal');
                    taskModal.querySelector('.modal-title').textContent = task.title;
                    taskModal.querySelector('.modal-body').textContent = task.description;
                    taskModal.querySelector('.modal-footer').querySelector('.delete-task').setAttribute('href', '/tasks/' + task.id);
                    taskModal.querySelector('.modal-footer').querySelector('.edit-task').setAttribute('href', '/tasks/' + task.id);
                    window.task = task;
                    $('#taskModal').modal('show');
                })
        });
    });

    let markCompletedLinks = document.querySelectorAll('.mark-completed');
    markCompletedLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            let taskId = link.getAttribute('href').split('/').pop();
            if (window.task !== undefined) {
                window.task.isCompleted = true;
                changeStatus(task);
            }else {
                getTask(taskId)
                    .then((task) => {
                        task.isCompleted = true;
                        changeStatus(task);
                    });
            }
        });
    });

    let markIncompleteLinks = document.querySelectorAll('.mark-incomplete');
    markIncompleteLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            let taskId = link.getAttribute('href').split('/').pop();
            if (window.task !== undefined) {
                window.task.isCompleted = false;
                changeStatus(task);
            }else {
                getTask(taskId)
                    .then((task) => {
                        task.isCompleted = false;
                        changeStatus(task);
                    });
            }
        });
    });

    let editLinks = document.querySelectorAll('.edit-task');
    editLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            let taskId = link.getAttribute('href').split('/').pop();
            getTask(taskId)
                .then((task) => {
                    let formModal = document.querySelector('#formModal');
                    formModal.setAttribute('action', '/tasks/' + task.id);
                    formModal.setAttribute('method', 'PUT');
                    formModal.querySelector('.modal-title').textContent = task.title;
                    formModal.querySelector('.modal-body').querySelector('input[name="task[title]"]').value = task.title;
                    formModal.querySelector('.modal-body').querySelector('textarea[name="task[description]"]').value = task.description;
                    formModal.querySelector('.modal-body').querySelector('input[name="task[isCompleted]"]').checked = task.isCompleted;
                    formModal.querySelector('.modal-body').querySelector('input[name="task[user_id]"]').value = task.user_id;
                    formModal.querySelector('.modal-footer').querySelector('.save-task').setAttribute('href', '/tasks/' + task.id)
                    $('#formModal').modal('show');
                })
        });
    });

    let saveLinks = document.querySelectorAll('.save-task');
    saveLinks.forEach(function (link) {
        link.addEventListener('click', async function (event) {
            event.preventDefault();
            let formModal = document.querySelector('#formModal');
            let task = {
                title: formModal.querySelector('.modal-body').querySelector('input[name="task[title]"]').value,
                description: formModal.querySelector('.modal-body').querySelector('textarea[name="task[description]"]').value,
                isCompleted: formModal.querySelector('.modal-body').querySelector('input[name="task[isCompleted]"]').checked,
                user_id: formModal.querySelector('.modal-body').querySelector('input[name="task[user_id]"]').value
            };
            let url = formModal.getAttribute('action');
            await fetch(url, {
                method: formModal.getAttribute('method'),
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(task)
            }).then(function (response) {
                if (response.ok) {
                    window.location.reload();
                }
                return Promise.reject(response);
            }).catch(async function (error) {
                let err = await error.json().then(function (data) {
                    let parts = data.message.split(':')
                    let title = parts[0];
                    let errors = parts[1].split(',');

                    return { title, errors}
                })

                let errorList = document.querySelector('.errors');
                $(errorList).removeClass('d-none')
                errorList.innerHTML = '';
                errorList.innerHTML += `<h5>${err.title}</h5>`;
                errorList.innerHTML += '<ul>';
                err.errors.forEach(function (error) {
                    errorList.innerHTML += `<li>${error}</li>`;
                });
                errorList.innerHTML += '</ul>';
            })
        });
    });

    document.querySelector('.new-task').addEventListener('click', function (event) {
        event.preventDefault();
        let formModal = document.querySelector('#formModal');
        formModal.setAttribute('action', '/tasks');
        formModal.setAttribute('method', 'POST');
        formModal.querySelector('.modal-title').textContent = 'New Task';

        $('#formModal').modal('show');
    })
});

function deleteTask(taskId) {
    if (confirm('Are you sure?')) {
        var url = '/tasks/' + taskId;
        var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        fetch(url, {
            method: 'DELETE',
            headers: {
                'X-CSRF-Token': token,
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            if (response.ok) {
                window.location.reload();
            }
        });
    } else {
        return false;
    }
}

function getTask(taskId) {
    var url = '/tasks/' + taskId;
    return fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(function (response) {
        if (response.ok) {
            return response.json();
        }
    })
}

function changeStatus(task) {
    let url = '/tasks/' + task.id
    let token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    fetch(url, {
        method: 'PUT',
        headers: {
            'X-CSRF-Token': token,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ task: task })
    }).then(function (response) {
        if (response.ok) {
            window.location.reload();
        }
    });
}

$('#formModal').on('hidden.bs.modal', function (e) {
    let errorList = document.querySelector('.errors');
    $(errorList).addClass('d-none')
    errorList.innerHTML = '';

    let formModal = document.querySelector('#formModal');
    formModal.querySelector('.modal-body').querySelector('input[name="task[title]"]').value = '';
    formModal.querySelector('.modal-body').querySelector('textarea[name="task[description]"]').value = '';
    formModal.querySelector('.modal-body').querySelector('input[name="task[isCompleted]"]').checked = false;
})