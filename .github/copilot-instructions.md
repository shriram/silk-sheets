This is an application being written for a highly non-technical user. There are two main applications:
1. A program that, given a library of tasks, gives the user the ability to assemble a taskflow by selecting and configuring tasks from the library.
2. A program that lets the user edit the library of tasks.
It is critical that two systems be as simple as possible. As much as possible there should not be any servers to run, Docker, git, etc. The user should be able to just download and run the applications. The taskflow creator should be just a Web application that doesn't even require a server to run. The task library editor can be a simple desktop application, but it should not require installation of third-party software (Python, etc.). It only needs to run on MacOS.

## Terminology
- **taskflow** (application-specific): A user-assembled sequence of configured tasks from the task library. This is a domain concept specific to this application.
- **workflow** (standard technical term): Only used in the general software engineering sense (e.g., developer workflows, CI/CD workflows). Do not use "workflow" when referring to the application's taskflow concept.