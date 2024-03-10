//
//  ContentView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.videoLibrary) private var videoLibrary
    
    @State private var showDocumentPicker = false
    @State private var navigateToLibraryView = false
    @State private var loadPreviousLibrary = true
    
    var body: some View {
        NavigationStack {
            VStack{
                Image("LSVR_Logo_2023_FullColor")
                    .resizable()
                    .frame(width: 400, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                Text("Immersive Video Player")
                    .font(.title)
                Text("Created by Matthew Celia")
                    .foregroundStyle(.secondary)
                Text("Version 1.0")
                    .foregroundStyle(.secondary)
                
                Button("Select Video Playlist") {
                    showDocumentPicker = true
                } .padding()
                    .fullScreenCover(isPresented: $showDocumentPicker) {
                        DocumentPicker(documentTypes: [.json], onPick: { url in
                            // Handle the picked document URL
                            videoLibrary.copyFileToLibrariesFolder(sourceURL: url)
                            videoLibrary.loadVideos(from: url)
                            navigateToLibraryView = true
                        })
                    }
                    .navigationDestination(isPresented: $navigateToLibraryView) {
                        LibraryView(videos: videoLibrary.videos)
                    }
            }.onAppear {
                if let firstFileURL = videoLibrary.getUrlOfFirstFileInLibrariesFolder() {
                    // Do something with the first file URL
                    loadPreviousLibrary = true
                    videoLibrary.loadVideos(from: firstFileURL)
                    navigateToLibraryView = true
                    // Optionally, load or process the file as needed
                } else {
                    loadPreviousLibrary = false
                    showDocumentPicker = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

