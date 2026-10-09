import SwiftUI

/// A screen for one Swift Export feature: a short explanation followed by live demo rows.
struct FeatureScreen<Content: View>: View {
    let title: String
    let summary: String
    @ViewBuilder let content: Content

    var body: some View {
        List {
            Section {
                Text(summary)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            content
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// One Swift expression that calls into Kotlin, and what it returned.
struct DemoRow: View {
    let code: String
    let result: String

    init(_ code: String, _ result: String) {
        self.code = code
        self.result = result
    }

    init(_ code: String, _ result: some CustomStringConvertible) {
        self.init(code, result.description)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(code)
                .font(.system(.footnote, design: .monospaced))
            Text("→ \(result)")
                .foregroundStyle(.secondary)
        }
    }
}

/// A row in the catalog that opens a feature screen.
struct FeatureLink<Destination: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let destination: () -> Destination

    init(_ title: String, _ subtitle: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.subtitle = subtitle
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
