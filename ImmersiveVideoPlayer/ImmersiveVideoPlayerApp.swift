//
//  ImmersiveVideoPlayerApp.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/21/24.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct ImmersiveVideoPlayerApp: App {
    var body: some Scene {
        WindowGroup{
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}

struct VideoDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var videos: [Video]

    init(videos: [Video] = []) {
        self.videos = videos
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let decodedVideos = try? JSONDecoder().decode([Video].self, from: data) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        videos = decodedVideos
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(videos)
        return FileWrapper(regularFileWithContents: data)
    }
}
