//
//  VideoPlayer.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/23/24, adapted from Michael Swanson
//

import Combine
import Foundation
import SwiftUI
import AVKit
import RealityKit
import RealityKitContent

class VideoPlayer: ObservableObject {
    
    @Published var videoURL: URL?
    @Published var videoInfo: VideoInfo = VideoInfo()
    @Published var isSpatialVideoAvailable: Bool = false
    @Published var shouldPlayInStereo: Bool = true
    @Published var isVideoLocal: Bool = false
    @Published var currentVideoTitle = ""
    @Published var currentVideoDescription = ""
    @Published var currentVideoThumbnail = ""
    @Published var currentlyPlaying = false
    @Published var player: AVPlayer = AVPlayer()
    
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
    
    func returnLocalURL(localVideoName: URL?) -> URL? {
        //scan the documents directory for videos that match the path names of videos
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        guard let fileName = localVideoName?.lastPathComponent else{
            print ("not given a valid URL")
            return URL(string:"")
        }
        // Construct the full path for where the video would be in the documents directory
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        return fileURL
    }
    
    func playVideo(){
        player.play()
        currentlyPlaying = true
    }
    
    func pauseVideo(){
        player.pause()
        currentlyPlaying = false
    }
    
    func restartVideo(){
        player.seek(to: CMTime.zero)
        player.play()
        currentlyPlaying = true
    }
}
