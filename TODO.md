# StaticToggle - Project Specification & TODO

## Project Overview

**StaticToggle** is a simple, lightweight macOS desktop UI application for managing static site generators. It provides an intuitive interface to start, stop, and monitor development servers for popular static site generators like Hugo, Jekyll, Eleventy, Gatsby, Next.js, and others.

### Core Purpose
Allow macOS developers to easily manage multiple static site generator projects from a single, clean interface without needing to remember CLI commands or juggle multiple terminal windows.

---

## Target Static Site Generators

- [ ] Hugo
- [ ] Jekyll
- [ ] Eleventy (11ty)
- [ ] Next.js
- [ ] Gatsby
- [ ] Astro
- [ ] Docusaurus
- [ ] VuePress
- [ ] Nuxt
- [ ] Hexo
- [ ] MkDocs
- [ ] Pelican
- [ ] Zola
- [ ] Gridsome

---

## Core Features

### 1. Project Management
- [ ] Add new projects (browse to select project directory)
- [ ] Remove projects from list
- [ ] Auto-detect static site generator type from project files
  - [ ] Check for `config.toml`/`config.yaml` (Hugo)
  - [ ] Check for `_config.yml` (Jekyll)
  - [ ] Check for `.eleventy.js` (Eleventy)
  - [ ] Check for `next.config.js` (Next.js)
  - [ ] Check for `gatsby-config.js` (Gatsby)
  - [ ] Check for `astro.config.mjs` (Astro)
  - [ ] etc.
- [ ] Edit project settings (custom commands, port numbers)
- [ ] Save/load project list (persist between sessions)
- [ ] Display project metadata (name, type, path, last used)

### 2. Server Control
- [ ] Start development server for selected project
- [ ] Stop running server
- [ ] Restart server
- [ ] View server status (running/stopped)
- [ ] Display server output/logs in real-time
- [ ] Auto-detect default ports and commands per generator type
- [ ] Support custom start commands per project
- [ ] Handle multiple projects running simultaneously
- [ ] Graceful shutdown of servers on app exit

### 3. Server Monitoring
- [ ] Display live server logs
- [ ] Show current port number
- [ ] Display local URL (e.g., `http://localhost:1313`)
- [ ] Click to open URL in default browser
- [ ] Show server uptime
- [ ] Display build errors/warnings prominently
- [ ] Real-time log filtering (errors, warnings, info)
- [ ] Log history (scrollable output)
- [ ] Clear logs button

### 4. User Interface
- [ ] Clean, modern UI design
- [ ] Project list sidebar
  - [ ] Show project name
  - [ ] Show generator type icon/badge
  - [ ] Show status indicator (green=running, grey=stopped, red=error)
- [ ] Main panel for selected project
  - [ ] Start/Stop/Restart buttons
  - [ ] Server information display
  - [ ] Log viewer
  - [ ] Quick actions toolbar
- [ ] System tray integration (minimize to tray)
- [ ] Global keyboard shortcuts
  - [ ] Quick start/stop for selected project
  - [ ] Switch between projects
  - [ ] Open browser
- [ ] Dark mode / Light mode toggle
- [ ] Responsive layout

### 5. Configuration & Settings
- [ ] Global settings panel
  - [ ] Default browser selection
  - [ ] Auto-start behavior
  - [ ] Theme selection
  - [ ] Log retention settings
- [ ] Per-project configuration
  - [ ] Custom start command
  - [ ] Custom build command
  - [ ] Custom port number
  - [ ] Environment variables
  - [ ] Pre-start scripts
  - [ ] Post-stop scripts
- [ ] Import/Export project configurations
- [ ] Backup/restore settings

### 6. Quick Actions
- [ ] "Open in Browser" button (launches default browser)
- [ ] "Open in Terminal" button (opens terminal at project directory)
- [ ] "Open in Finder" button
- [ ] "Open in Code Editor" button (configurable, e.g., VS Code, Sublime)
- [ ] "Build for Production" button
- [ ] Copy local URL to clipboard

### 7. Notifications
- [ ] System notifications when:
  - [ ] Server starts successfully
  - [ ] Server stops
  - [ ] Build errors occur
  - [ ] Port conflicts detected
- [ ] In-app notification center
- [ ] Notification preferences (enable/disable per type)

---

## Advanced Features (Phase 2)

### 8. Build Management
- [ ] Production build commands
- [ ] Build status tracking
- [ ] Build output preview
- [ ] Deploy integration hooks (Netlify, Vercel, GitHub Pages)
- [ ] Build time tracking and history

### 9. Process Management
- [ ] CPU and memory usage monitoring per server
- [ ] Auto-restart on crash
- [ ] Process health checks
- [ ] Automatic port conflict resolution
- [ ] Queue system for sequential builds

### 10. Multi-site Dashboard
- [ ] Grid/list view of all projects
- [ ] Bulk actions (start/stop multiple)
- [ ] Favorites/pinned projects
- [ ] Recent projects quick access
- [ ] Search/filter projects

### 11. Developer Tools
- [ ] Hot reload indicator
- [ ] Build time statistics
- [ ] Dependency checker (outdated packages)
- [ ] Git status integration
  - [ ] Show current branch
  - [ ] Show uncommitted changes
  - [ ] Quick commit/push buttons
- [ ] Network inspector (requests made by dev server)

### 12. Templates & Starters
- [ ] Built-in starter templates
- [ ] Create new project from template
- [ ] Custom template library
- [ ] Template download from URLs

### 13. Plugin System
- [ ] Support for custom plugins/extensions
- [ ] Community plugin marketplace
- [ ] Plugin API documentation

---

## Technical Implementation Tasks

### Application Structure
- [ ] SwiftUI app bundle for UI, Go backend daemon (separate processes)
- [ ] Define IPC contract between SwiftUI front-end and Go backend
- [ ] Configure build system (Xcode project + Go modules)
- [ ] Set up development environment

### Backend/Core
- [ ] Process management module
  - [ ] Spawn child processes
  - [ ] Capture stdout/stderr
  - [ ] Handle process termination
  - [ ] Handle macOS process lifecycle quirks
- [ ] Project detection module
  - [ ] File system scanning
  - [ ] Configuration file parsing
  - [ ] Generator type identification
- [ ] Configuration management
  - [ ] JSON/YAML config files
  - [ ] Settings persistence
  - [ ] Migration system for config updates
- [ ] Command builder
  - [ ] Per-generator command templates
  - [ ] Custom command parser
  - [ ] Environment variable injection

### Frontend/UI (SwiftUI + Mock Data)
- [ ] Design system setup
  - [ ] Color palette
  - [ ] Typography
  - [ ] Component library
- [ ] Build SwiftUI-only shell backed by mock project data models
- [ ] Main window layout (projects list + detail panel) using mock state
- [ ] Log viewer component with seeded log entries
- [ ] Settings panel populated with placeholder values
- [ ] System tray menu stub (non-functional actions)
- [ ] Notification banner mock-ups

### macOS IPC Strategy
- [ ] gRPC or protobuf-based contract over UNIX domain sockets (fast, typed)
- [ ] Lightweight JSON-RPC over stdio pipes when spawning Go backend as child
- [ ] XPC service wrapper around Go binary (via launchd) for sandbox-friendly messaging
- [ ] Shared SQLite or file-based cache only for supplemental state (not primary IPC)
- [ ] Evaluate reconnect/backoff patterns and request multiplexing

### macOS-Specific Deliverables
- [ ] macOS build and signing (Apple Silicon + Intel)
- [ ] Notarization and stapling workflow
- [ ] Auto-update mechanism (Sparkle or similar)
- [ ] Native macOS integrations (menu bar, dock badges, notification center)

### Testing
- [ ] Unit tests for core modules
- [ ] Integration tests for process management
- [ ] UI component tests
- [ ] End-to-end tests
- [ ] macOS-specific regression testing (Apple Silicon + Intel)

### Documentation
- [ ] README.md with installation instructions
- [ ] User guide
- [ ] Configuration reference
- [ ] Troubleshooting guide
- [ ] Contributing guidelines
- [ ] API documentation (if plugin system)

### Deployment
- [ ] Set up CI/CD pipeline
- [ ] Automated macOS builds (Universal 2 binaries)
- [ ] Release process documentation
- [ ] Distribution channels (GitHub Releases, homebrew, etc.)
- [ ] Website/landing page

---

## MVP (Minimum Viable Product) Checklist

Priority features for initial release:

1. [ ] Add/remove projects
2. [ ] Auto-detect Hugo and Jekyll projects
3. [ ] Start/stop servers with default commands
4. [ ] Display real-time logs
5. [ ] Open browser button
6. [ ] Basic UI with project list and log viewer
7. [ ] Persist projects between sessions
8. [ ] Polish macOS experience (app bundle, codesigning, notarization)

---

## Nice-to-Have Features (Future Considerations)

- [ ] Remote project support (SSH)
- [ ] Cloud sync of project list
- [ ] Collaboration features (share project configs)
- [ ] Performance profiling tools
- [ ] Built-in HTTP proxy for custom headers
- [ ] Screenshot/video capture of running site
- [ ] Mobile companion app (view-only)
- [ ] CLI version of StaticToggle
- [ ] Browser extension for quick control
- [ ] Docker container support
- [ ] Kubernetes integration for preview environments
- [ ] Accessibility features (screen reader support)
- [ ] Internationalization (i18n) support
- [ ] Analytics dashboard (build times, popular generators)

---

## Known Challenges & Considerations

- [ ] Terminal emulation differences inside macOS (default Terminal vs. iTerm, Rosetta shells)
- [ ] Handling different macOS shell environments (bash, zsh)
- [ ] Port conflict detection and resolution
- [ ] Permission issues (admin rights for certain operations)
- [ ] Large log files (performance optimization needed)
- [ ] Different Node.js/Ruby/Python version requirements per project
- [ ] Graceful handling of crashed processes
- [ ] File watcher limitations on some systems
- [ ] Network-related issues (firewalls, proxy settings)

---

## Success Metrics

- [ ] Time to start a server < 3 seconds
- [ ] Application startup time < 2 seconds
- [ ] Memory usage < 150MB idle
- [ ] Support for 10+ simultaneous servers
- [ ] Zero-configuration for popular generators
- [ ] Apple Silicon and Intel feature parity

---

## Release Phases

### Phase 1: Core Functionality (v0.1.0 - MVP)
Focus on Hugo and Jekyll support with basic start/stop functionality on macOS

### Phase 2: Enhanced UX (v0.2.0)
Add more generators, improve UI, add macOS-native notifications

### Phase 3: Advanced Features (v0.3.0)
Build management, Git integration, developer tools

### Phase 4: Ecosystem (v1.0.0)
Plugin system, templates, community features tuned for macOS users

---

## Getting Started (For Developers)

When implementing StaticToggle, prioritize in this order:

1. Set up basic project structure and choose tech stack
2. Implement project detection for 2-3 popular generators
3. Build process management core (start/stop)
4. Create minimal UI with project list
5. Add log viewing capability
6. Implement project persistence
7. Add browser launch functionality
8. Iterate and expand based on user feedback

---

*Last Updated: December 2025*
*Status: Planning Phase*
