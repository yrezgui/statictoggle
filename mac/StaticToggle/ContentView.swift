//
//  ContentView.swift
//  StaticToggle
//
//  Created by Yacine Rezgui on 15.12.2025.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @State private var projects = MockData.projects
    @State private var selectedProject: StaticSiteProject? = MockData.projects.first
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var showingSettings = false

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ProjectListView(projects: projects, selectedProject: $selectedProject)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showingSettings = true
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }
        } detail: {
            if let project = selectedProject {
                ProjectDetailView(project: project)
            } else {
                PlaceholderView()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct ProjectListView: View {
    let projects: [StaticSiteProject]
    @Binding var selectedProject: StaticSiteProject?

    var body: some View {
        List(selection: $selectedProject) {
            Section("Projects") {
                ForEach(projects) { project in
                    ProjectRowView(project: project)
                        .tag(project)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

struct ProjectRowView: View {
    let project: StaticSiteProject

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(project.status.tint)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(project.name)
                    .font(.headline)
                Text("\(project.generator.rawValue) • \(project.status.description)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("#\(project.port)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ProjectDetailView: View {
    let project: StaticSiteProject

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProjectHeaderView(project: project)

                ServerInfoGrid(project: project)

                QuickActionsView(actions: project.quickActions)

                LogViewer(logs: project.logEntries)

                NotesCard(notes: project.notes)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.appWindowBackground)
    }
}

struct ProjectHeaderView: View {
    let project: StaticSiteProject

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.system(size: 28, weight: .bold))
                Text(project.path)
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            StatusBadge(status: project.status)

            HStack(spacing: 8) {
                Button("Start") {}
                    .buttonStyle(.borderedProminent)
                    .disabled(project.status == .running)
                Button("Stop") {}
                    .buttonStyle(.bordered)
                    .disabled(project.status == .stopped)
                Button("Restart") {}
                    .buttonStyle(.bordered)
            }
        }
    }
}

struct StatusBadge: View {
    let status: ServerStatus

    var body: some View {
        Label(status.description, systemImage: status.icon)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.tint.opacity(0.15))
            .foregroundColor(status.tint)
            .clipShape(Capsule())
    }
}

struct ServerInfoGrid: View {
    let project: StaticSiteProject

    var body: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            GridRow {
                InfoCard(
                    title: "Generator",
                    value: project.generator.rawValue,
                    icon: "shippingbox.fill",
                    tint: project.generator.accentColor
                )
                InfoCard(
                    title: "Port",
                    value: "\(project.port)",
                    icon: "number",
                    tint: .blue
                )
                InfoCard(
                    title: "URL",
                    value: project.url,
                    icon: "link",
                    tint: .teal
                )
            }
            GridRow {
                InfoCard(
                    title: "Status",
                    value: project.status.description,
                    icon: project.status.icon,
                    tint: project.status.tint
                )
                InfoCard(
                    title: "Last Used",
                    value: project.lastUsed,
                    icon: "clock",
                    tint: .indigo
                )
                InfoCard(
                    title: "Path",
                    value: project.path,
                    icon: "folder",
                    tint: .gray
                )
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(tint)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct QuickActionsView: View {
    let actions: [QuickAction]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(actions) { action in
                    Button {
                        // UI only mock
                    } label: {
                        HStack {
                            Image(systemName: action.icon)
                                .frame(width: 20)
                            Text(action.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct LogViewer: View {
    let logs: [LogEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Logs")
                    .font(.headline)
                Spacer()
                Button("Clear") {}
                    .disabled(true)
            }

            RoundedRectangle(cornerRadius: 12)
                .fill(.thinMaterial)
                .overlay(
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(logs) { entry in
                                LogRow(entry: entry)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                Divider()
                            }
                        }
                        .padding(.vertical)
                    }
                )
                .frame(minHeight: 200, maxHeight: 320)
        }
    }
}

struct LogRow: View {
    let entry: LogEntry

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(entry.formattedTimestamp)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 68, alignment: .leading)
            Text(entry.level.rawValue)
                .font(.system(.caption, design: .monospaced))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(entry.level.labelColor.opacity(0.15))
                .foregroundColor(entry.level.labelColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(entry.message)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct NotesCard: View {
    let notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
            Text(notes)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "macwindow")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("Select a project to see details")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appWindowBackground)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var defaultBrowser = "Safari"
    @State private var openBrowserOnStart = true
    @State private var autoStartLastProject = false
    @State private var theme: ThemeOption = .system

    enum ThemeOption: String, CaseIterable, Identifiable {
        case light, dark, system
        var id: String { rawValue }
        var label: String {
            rawValue.capitalized
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("StaticToggle Preferences")
                    .font(.headline)
                Spacer()
                Button("Done") { dismiss() }
            }
            .padding()

            Divider()

            Form {
                Section("General") {
                    Picker("Default Browser", selection: $defaultBrowser) {
                        Text("Safari").tag("Safari")
                        Text("Arc").tag("Arc")
                        Text("Chrome").tag("Chrome")
                    }
                    Toggle("Open browser when server starts", isOn: $openBrowserOnStart)
                    Toggle("Reopen last project on launch", isOn: $autoStartLastProject)
                }

                Section("Appearance") {
                    Picker("Theme", selection: $theme) {
                        ForEach(ThemeOption.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .formStyle(.grouped)
        }
        .frame(width: 420, height: 360)
    }
}

extension Color {
    static var appWindowBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(.systemGroupedBackground)
        #endif
    }
}

enum GeneratorType: String, CaseIterable, Identifiable {
    case hugo = "Hugo"
    case jekyll = "Jekyll"
    case eleventy = "Eleventy"
    case next = "Next.js"
    case astro = "Astro"

    var id: String { rawValue }

    var accentColor: Color {
        switch self {
        case .hugo: return .purple
        case .jekyll: return .red
        case .eleventy: return .mint
        case .next: return .blue
        case .astro: return .orange
        }
    }
}

enum ServerStatus: String {
    case running
    case stopped
    case error

    var icon: String {
        switch self {
        case .running: return "play.circle.fill"
        case .stopped: return "pause.circle"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .running: return .green
        case .stopped: return .gray
        case .error: return .orange
        }
    }

    var description: String {
        switch self {
        case .running: return "Running"
        case .stopped: return "Stopped"
        case .error: return "Needs Attention"
        }
    }
}

enum LogLevel: String {
    case info = "INFO"
    case warning = "WARN"
    case error = "ERROR"

    var labelColor: Color {
        switch self {
        case .info: return .secondary
        case .warning: return .orange
        case .error: return .red
        }
    }
}

struct LogEntry: Identifiable, Hashable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let message: String

    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: timestamp)
    }
}

struct QuickAction: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
}

struct StaticSiteProject: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let generator: GeneratorType
    let path: String
    let status: ServerStatus
    let port: Int
    let url: String
    let lastUsed: String
    let logEntries: [LogEntry]
    let quickActions: [QuickAction]
    let notes: String
}

enum MockData {
    static let timestamp: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 12
        components.day = 15
        components.hour = 10
        components.minute = 22
        let calendar = Calendar.current
        return calendar.date(from: components) ?? .now
    }()

    static let logSamples: [LogEntry] = [
        LogEntry(timestamp: timestamp, level: .info, message: "Starting Hugo development server on port 1313"),
        LogEntry(timestamp: timestamp.addingTimeInterval(8), level: .info, message: "Watching 12 content files for changes"),
        LogEntry(timestamp: timestamp.addingTimeInterval(16), level: .warning, message: "Asset pipeline detected slow build (> 1.5s)"),
        LogEntry(timestamp: timestamp.addingTimeInterval(22), level: .error, message: "Failed to render partial 'hero.html'"),
        LogEntry(timestamp: timestamp.addingTimeInterval(30), level: .info, message: "Site recompiled in 856ms after content update")
    ]

    static let quickActions: [QuickAction] = [
        QuickAction(title: "Open Browser", icon: "safari"),
        QuickAction(title: "Open Finder", icon: "folder"),
        QuickAction(title: "Open Terminal", icon: "terminal"),
        QuickAction(title: "Open in VS Code", icon: "chevron.left.forwardslash.chevron.right")
    ]

    static let projects: [StaticSiteProject] = [
        StaticSiteProject(
            name: "hania-website",
            generator: .hugo,
            path: "~/Sites/hania",
            status: .running,
            port: 1313,
            url: "http://localhost:1313",
            lastUsed: "Today at 09:54",
            logEntries: logSamples,
            quickActions: quickActions,
            notes: "Primary marketing site. Uses Tailwind + Hugo Pipes."
        ),
        StaticSiteProject(
            name: "docs",
            generator: .jekyll,
            path: "~/Sites/docs",
            status: .stopped,
            port: 4000,
            url: "http://localhost:4000",
            lastUsed: "Yesterday at 16:20",
            logEntries: Array(logSamples.prefix(3)),
            quickActions: quickActions,
            notes: "Internal engineering handbook."
        ),
        StaticSiteProject(
            name: "astro-blog",
            generator: .astro,
            path: "~/Sites/blog",
            status: .error,
            port: 4321,
            url: "http://localhost:4321",
            lastUsed: "Today at 07:12",
            logEntries: logSamples,
            quickActions: quickActions,
            notes: "Experimental Astro blog."
        )
    ]
}

#Preview {
    ContentView()
}
