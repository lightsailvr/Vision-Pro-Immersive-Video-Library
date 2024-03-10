//
//  PlayerControls.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 3/8/24.
//

import SwiftUI
import AVFoundation
import AVKit


struct PlayerControls: View {
    @EnvironmentObject var videoPlayer: VideoPlayer
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) var returnToLibrary
    @Environment(\.dismissWindow) var closePlayerControls
    
    var body: some View {
        HStack {
            Button(action: {
                Task{
                    returnToLibrary(id: "ContentLibrary")
                    await dismissImmersiveSpace()
                    closePlayerControls()
                }
            }, label: {
                Text("Exit")
            }).padding(.horizontal, 20)
            
            VStack (alignment: .leading){
                Text("Spatial:").bold() + Text(" \(videoPlayer.videoInfo.isSpatial ? "Yes" : "No")")
                Text("Size:").bold() + Text(" \(videoPlayer.videoInfo.sizeString)")
                Text("Projection:").bold() + Text(" \(videoPlayer.videoInfo.projectionTypeString)")
                Text("Horizontal FOV:").bold() + Text(" \(videoPlayer.videoInfo.horizontalFieldOfViewString)")
            }
            .padding()
            . background(.ultraThickMaterial)
            
            if (videoPlayer.currentlyPlaying) {
                Button(action: {
                    videoPlayer.pauseVideo()
                }, label: {
                    Text("Pause")
                }).padding(.horizontal, 20)
            } else {
                Button(action: {
                    videoPlayer.playVideo()
                }, label: {
                    Text("Play")
                }).padding(.horizontal, 20)
            }
            Button(action: {
                videoPlayer.restartVideo()
            }, label: {
                Text("Restart")
            }).padding(.trailing, 20)
        }
        .padding(.vertical, 20)
        .glassBackgroundEffect()
            
    }
    
}
#Preview {
    PlayerControls()
        .environmentObject(VideoPlayer())
}
