//
//  PreviewData.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 3/3/24.
//

import Foundation

class PreviewData {
    static func load<Video: Codable>(name: String) ->[Video] {
        if let path = Bundle.main.path(forResource: name, ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let results = try JSONDecoder().decode([Video].self, from: data)
                return results
            } catch{
                return []
            }
        }
        
        return[]
    }
}
