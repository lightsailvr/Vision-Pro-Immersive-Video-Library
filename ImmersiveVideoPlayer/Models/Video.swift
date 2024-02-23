//
//  Video.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/22/24.
//

import Foundation

struct Video: Hashable, Codable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let posterName: String
    let description: String
    let projectionType: String
}
