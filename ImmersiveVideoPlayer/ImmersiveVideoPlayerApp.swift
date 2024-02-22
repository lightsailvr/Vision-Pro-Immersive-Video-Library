//
//  ImmersiveVideoPlayerApp.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/21/24.
//

import SwiftUI

@main
struct ImmersiveVideoPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
