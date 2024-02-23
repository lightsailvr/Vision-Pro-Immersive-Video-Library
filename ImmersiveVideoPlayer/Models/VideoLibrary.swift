//
//  VideoLibrary.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/22/24.
//

import Foundation
import Observation
import Combine

class VideoLibrary : ObservableObject {
    @Published var videos: [Video] = []

        func loadVideos(from url: URL) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.videos = try decoder.decode([Video].self, from: data)
            } catch {
                print("Error loading or parsing JSON: \(error)")
            }
        }
}
