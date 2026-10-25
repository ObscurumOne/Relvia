# Codex setup

`AGENTS.md` supplies project context and validation commands. It does not install Codex or connect GitHub by itself.

## Local build validation

On Windows, run from the repository root in PowerShell:

```powershell
# If required by the session policy (do not bypass an enforced policy):
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
.\scripts\build-windows.ps1 -Clean
```

This command was verified on Windows with MSVC x64. It discovers Visual Studio
through vswhere, including Build Tools and prerelease installations, and requires
the C++ x64/x86 tools component. To select a specific installation, pass
`-VisualStudioPath '<installation directory>'`. CMake 3.20+, Ninja and the Visual
Studio Installer's vswhere must be available; the script installs nothing.

The script initializes Developer PowerShell for x64 within its process, checks
MSVC and its standard headers, then configures Ninja Debug, builds and runs CTest
in sequence. `-Clean` adds `--clean-first`; omit it for an incremental build.
Failures stop the sequence with a nonzero exit code. Execution policy is never
changed by the script. Its `build/windows-msvc` directory is independent of
CLion's `cmake-build-*` cache.

On Linux/macOS:

```sh
cmake -S . -B build -DBUILD_TESTING=ON
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

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
