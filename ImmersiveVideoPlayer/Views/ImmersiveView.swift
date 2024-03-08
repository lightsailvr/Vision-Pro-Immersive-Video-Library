//
//  ImmersiveView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/21/24 with apologies to Michael Swanson
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation
import AVKit
import Foundation
import Combine

struct ImmersiveView: View {
    
    @EnvironmentObject var videoLibrary: VideoLibrary
    @EnvironmentObject var videoPlayer: VideoPlayer
    
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var player: AVPlayer = AVPlayer()
    @State private var isURLSecurityScoped: Bool = false
    @State private var videoMaterial: VideoMaterial?
    
    var body: some View {
        RealityView { content in
            guard let url = videoPlayer.videoURL else {
                print("No video URL selected")
                return
            }
            
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            
            guard let videoInfo = await VideoToolkit.getVideoInfo(asset: asset) else {
                print("Failed to get video info")
                return
            }
            videoPlayer.videoInfo = videoInfo
            videoPlayer.isSpatialVideoAvailable = videoInfo.isSpatial
            
            guard let (mesh, transform) = await VideoToolkit.makeVideoMesh(videoInfo: videoInfo) else {
                print("Failed to get video mesh")
                return
            }
            
            videoMaterial = VideoMaterial(avPlayer: player)
            guard let videoMaterial else {
                print("Failed to create video material")
                return
            }
            
            updateStereoMode()
            let videoEntity = Entity()
            videoEntity.components.set(ModelComponent(mesh: mesh, materials: [videoMaterial]))
            videoEntity.transform = transform
            content.add(videoEntity)
            
            // A 20m box that receives hits to enable tap gesture
            let collisionBox = makeCollisionBox(size: 20)
            content.add(collisionBox)
            
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        .onDisappear {
            if isURLSecurityScoped, let url = videoPlayer.videoURL {
                url.stopAccessingSecurityScopedResource()
            }
        }
        .onChange(of: videoPlayer.shouldPlayInStereo) { _, newValue in
            updateStereoMode()
        }
        .gesture(tapGesture)
    }
    func updateStereoMode() {
        if let videoMaterial {
            videoMaterial.controller.preferredViewingMode =
            videoPlayer.isStereoEnabled ? .stereo : .mono
        }
    }
    
    private var tapGesture: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded{ _ in
                //                    playerControlVisible.toggle()
                //                    if playerControlVisible {
                //                        openPlayerControls(id: "playercontrols")
                //                    } else {
                //                        closePlayerControls(id: "playercontrols")
                //                    }
            }
    }
    
    func makeCollisionBox(size: Float) -> Entity {
        
        let smallDimension: Float = 0.001
        let offset = size / 2
        
        // right face
        let right = Entity()
        right.name = "right"
        right.components.set(CollisionComponent(shapes: [.generateBox(width: smallDimension, height: size, depth: size)]))
        right.position.x = offset
        
        // left face
        let left = Entity()
        left.name = "left"
        left.components.set(CollisionComponent(shapes: [.generateBox(width: smallDimension, height: size, depth: size)]))
        left.position.x = -offset
        
        // top face
        let top = Entity()
        top.name = "top"
        top.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: smallDimension, depth: size)]))
        top.position.y = offset
        
        // bottom face
        let bottom = Entity()
        bottom.name = "bottom"
        bottom.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: smallDimension, depth: size)]))
        bottom.position.y = -offset
        
        // front face
        let front = Entity()
        front.name = "front"
        front.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: size, depth: smallDimension)]))
        front.position.z = offset
        
        // back face
        let back = Entity()
        back.name = "back"
        back.components.set(CollisionComponent(shapes: [.generateBox(width: size, height: size, depth: smallDimension)]))
        back.position.z = -offset
        
        // All faces.
        let faces = [right, left, top, bottom, front, back]
        
        for face in faces {
            face.components.set(InputTargetComponent())
        }
        
        // parent to hold all of the entities.
        let entity = Entity()
        entity.children.append(contentsOf: faces)
        
        return entity
    }
}

//#Preview {
//    ImmersiveView()
//        .previewLayout(.sizeThatFits)
//}
