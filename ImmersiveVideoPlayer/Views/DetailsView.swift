//
//  DetailsView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 3/4/24.
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject private var videoPlayer: VideoPlayer
    @State private var imageData: Data?
    
    @Binding var showDetails: Bool
    @Binding var showImmersiveSpace: Bool
    @Binding var isVideoLocal: Bool
    var currentVideoTitle: String
    var currentVideoDescription: String
    
    var body: some View {
        HStack {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 160, alignment: .leading)
                    .cornerRadius(15)
            } else {
                ProgressView()
                    
            }
            VStack(alignment: .leading, content: {
                Text(currentVideoTitle)
                    .font(.headline)
                Text(currentVideoDescription)
                    .foregroundStyle(.secondary)
                
            }).frame(width: 500, alignment: .leading)
                .padding()
            VStack{
                if !isVideoLocal {
                    DownloadView(fileURL: videoPlayer.videoURL!.absoluteString, isVideoLocal: $isVideoLocal)
                } else {
                    Button(action: {
                        showImmersiveSpace = true
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    })
                }
            }
            
            
        }.padding(30)
            .onReceive(videoPlayer.$currentVideoThumbnail) { _ in
                downloadThumbnailImage(thumbnailImage: videoPlayer.currentVideoThumbnail)
            }

    }
    
    func downloadThumbnailImage(thumbnailImage: String) {
        guard let url = URL(string: thumbnailImage) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}

#Preview {
    DetailsView(showDetails: .constant(true), showImmersiveSpace: .constant(false), isVideoLocal: .constant(true), currentVideoTitle: "Introduction to 180 VR", currentVideoDescription: "Put on your VR headset and let director Matthew Celia guide you on an immersive introduction to stereoscopic 3D 180° VR filmmaking. As the Creative Director of Light Sail VR, Celia has made many immersive films using a variety of equipment, but nothing has him more excited than Canon’s revolutionary VR lens: the RF5.2mm F2.8 L Dual Fisheye Lens for the EOS VR System.")
        .environmentObject(VideoPlayer())
}
