//
//  DownloadView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 3/1/24.
//

import SwiftUI
import Alamofire

struct DownloadView: View {

    @State private var downloadProgress: Float = 0
    @State private var downloadBarVisible = false
    var fileURL: String
    @Binding var isVideoLocal: Bool


    var body: some View {
        VStack {
            if downloadBarVisible {
                ProgressView(value: downloadProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
                Button("Cancel") {
                    AF.cancelAllRequests()
                    downloadBarVisible = false
                }
            }
            else{
                Button("Download File") {
                    downloadFile(url: URL(string: fileURL))
                }
                .padding()
                .frame(height: 60)
            }
        }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
    
    func downloadFile(url: URL?) {
        guard let url = url else { return }
        downloadBarVisible = true
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsPath.appendingPathComponent(url.lastPathComponent)
            
            // Overwrite existing file, if necessary
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, to: destination).downloadProgress { progress in
            DispatchQueue.main.async {
                self.downloadProgress = Float(progress.fractionCompleted)
            }
        }
        .responseData { response in
            if response.error == nil, let filePath = response.fileURL?.path {
                print("File downloaded to: \(filePath)")
                self.downloadBarVisible = false
                isVideoLocal = true
            }
        }
    }
}

#Preview {
    DownloadView(fileURL: "https://lsvr-website.s3.us-west-1.amazonaws.com/soulsessions_umi/umi_poster.png", isVideoLocal: .constant(false))
}
