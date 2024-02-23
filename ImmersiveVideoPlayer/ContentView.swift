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

    //git@Binding var document: VideoDocument

    @StateObject private var videoLibrary = VideoLibrary()
    @State private var showDocumentPicker = false


    var body: some View {
        Button("Select Video Playlist") {
            showDocumentPicker = true
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(documentTypes: [.json], onPick: { url in
                // Handle the picked document URL
                videoLibrary.loadVideos(from: url)
            })
        }
        
        List(videoLibrary.videos) { video in
                Text(video.title) // Display the title or any other property
        }
        
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var documentTypes: [UTType]
    var onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ documentPicker: DocumentPicker) {
            self.parent = documentPicker
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let pickedURL = urls.first else { return }
            parent.onPick(pickedURL)
        }
    }
}
