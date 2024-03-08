//
//  VideoDownloader.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/27/24.
//

import Foundation
import Alamofire

class VideoDownloader {
    
    func downloadVideo(fileToDownload: URL) -> String{
        
        var fileDownloadPath: String = ""
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileToDownload.lastPathComponent)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(fileToDownload, to: destination).response { response in
            debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path {
                print ("file download complete")
                fileDownloadPath = imagePath
            }
        }.downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        
        return fileDownloadPath
    }
    
    
    
    
    
}
