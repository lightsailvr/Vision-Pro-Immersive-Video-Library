//
//  VideoPlayer.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/23/24, adapted from Michael Swanson
//

import Combine
import Foundation

class VideoPlayer: ObservableObject {
    @Published var videoURL: URL?
    @Published var videoInfo: VideoInfo = VideoInfo()
    @Published var isSpatialVideoAvailable: Bool = false
    @Published var shouldPlayInStereo: Bool = true
    @Published var isVideoLocal: Bool = false
    @Published var currentVideoTitle = ""
    @Published var currentVideoDescription = ""
    @Published var currentVideoThumbnail = ""
    
    var isStereoEnabled: Bool {
        isSpatialVideoAvailable && shouldPlayInStereo
    }
    
    func detectLocalVideo() -> Bool{
        //scan the documents directory for videos that match the path names of videos
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let videoFileName = videoURL!.lastPathComponent
        // Construct the full path for where the video would be in the documents directory
        let fileURL = documentsDirectory.appendingPathComponent(videoFileName)
        
        // Check if the file exists at that path
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("File exists: \(fileURL.path)")
            isVideoLocal = true
        } else {
            print("File does not exist: \(fileURL.path)")
            isVideoLocal = false
        }
        
        return isVideoLocal
    }
}
