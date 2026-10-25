# Codex setup

`AGENTS.md` supplies project context and validation commands. It does not install Codex or connect GitHub by itself.

For local CLI work, install Node.js/npm and then follow the current official CLI installation guidance:

```sh
npm install -g @openai/codex
cd relvia
codex
```

Complete sign-in interactively on your own computer. Ask Codex to summarize the repository instructions before the first implementation task.

Suggested first task: inspect docs/architecture.md, propose a precise connection/statement lifetime and error contract, and implement the agreed SQLite driver with meaningful integration tests.

For cloud work, publish the repository under your own GitHub account, allow Codex access to that repository and create a repository environment with a C++ compiler and CMake. Account authorization cannot be included in this archive.

Official documentation:
- https://developers.openai.com/codex/cli
- https://developers.openai.com/codex/guides/agents-md
