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
    let client: String
    let description: String
    let poster: String
    let thumbnail: String
    let category: String
    let sphereType: String
    let stereoscopic: String
}

//EXAMPLE JSON:
//        "id": 3,
//        "url" : "https://lsvr-website.s3.us-west-1.amazonaws.com/soulsessions_umi/video_4k.mp4",
//        "title": "VideoName",
//        "client": "client",
//        "description": "description",
//        "poster": "https://lightsail-public.s3.us-west-2.amazonaws.com/demo_content/posters/Overtime_Poster_vp.png",
//        "thumbnail": "https://lightsail-public.s3.us-west-2.amazonaws.com/demo_content/thumbnails/Overtime_Thumb.png",
//        "category": "Documentary",
//        "sphereType": "360", | 180 or 360
//        "stereoscopic": "ou" | ou = over under, sbs = side by side, none = monoscopic
