//
//  VideoLibrary.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/22/24.
//

import Foundation
import Observation
import Combine
import SwiftUI

class VideoLibrary: ObservableObject {
    @Published var videos: [Video] = []
    
    @Published var currentVideo: Video? = nil
    
    
    func getUrlOfFirstFileInLibrariesFolder() -> URL? {
        let fileManager = FileManager.default
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let librariesPath = documentsPath.appendingPathComponent("Libraries")

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: librariesPath, includingPropertiesForKeys: nil, options: [])
            
            // Check if there are any files in the directory
            if let firstFileURL = fileURLs.first {
                print("First file URL: \(firstFileURL)")
                return firstFileURL
            } else {
                print("No files found in the Libraries directory.")
                return nil
            }
        } catch {
            print("Error scanning Libraries directory: \(error)")
            return nil
        }
    }
    
    func copyFileToLibrariesFolder(sourceURL: URL) {
            let fileManager = FileManager.default
            guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let librariesPath = documentsPath.appendingPathComponent("Libraries")
            
            // Create "Libraries" directory if it doesn't exist
            if !fileManager.fileExists(atPath: librariesPath.path) {
                do {
                    try fileManager.createDirectory(at: librariesPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Failed to create Libraries directory: \(error)")
                    return
                }
            }
            
            let destinationURL = librariesPath.appendingPathComponent(sourceURL.lastPathComponent)
            // Copy the file
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                print("File copied successfully to Libraries folder.")
            } catch {
                print("Failed to copy file: \(error)")
            }
        }
    
    
    
    
    
    
    func downloadImageAsset(video: Video) -> String {
        return VideoDownloader().downloadVideo(fileToDownload: URL(string: video.poster)!)
    }
    
    func loadVideos(from url: URL){
        print(url.absoluteString)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            videos = try decoder.decode([Video].self, from: data)
        } catch {
            print("Error loading or parsing JSON: \(error)")
            videos = []
        }
    }
    
    func setCurrentVideo(selectedVideo: Video) {
        // Assuming the ID is a valid index within the videos array
        let index = selectedVideo.id
        // Ensure the index is within the bounds of the videos array to avoid out-of-bounds errors
        if index >= 0 && index < videos.count {
            currentVideo = videos[index]
            print ("set current video to " + currentVideo!.title)
        } else {
            // Handle the case where the index is out of bounds
            print("Video ID is out of the array bounds")
            currentVideo = nil
        }
    }
}
