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
    @EnvironmentObject var videoLibrary: VideoLibrary
    @State private var showDocumentPicker = false
    @State private var navigateToLibraryView = false
    @State private var selectedDocumentURL: URL?
    @State private var loadPreviousLibrary = true

    var body: some View {
        NavigationStack {
                VStack{
                    Button("Select Video Playlist") {
                        showDocumentPicker = true
                    } .padding()
                        .fullScreenCover(isPresented: $showDocumentPicker) {
                            DocumentPicker(documentTypes: [.json], onPick: { url in
                                // Handle the picked document URL
                                videoLibrary.copyFileToLibrariesFolder(sourceURL: url)
                                videoLibrary.loadVideos(from: url)
                                //print (url.absoluteString)
                                selectedDocumentURL = url
                                navigateToLibraryView = true
                            })
                        }
                        .navigationDestination(isPresented: $navigateToLibraryView) {
                            LibraryView(videos: videoLibrary.videos, libraryFileName: selectedDocumentURL?.lastPathComponent ?? "Default Library")
                        }
                    }.onAppear {
                        // Call your function here
                        if let firstFileURL = videoLibrary.getUrlOfFirstFileInLibrariesFolder() {
                            // Do something with the first file URL
                            loadPreviousLibrary = true
                            videoLibrary.loadVideos(from: firstFileURL)
                            navigateToLibraryView = true
                            // Optionally, load or process the file as needed
                        } else {
                            loadPreviousLibrary = false
                            showDocumentPicker = true
                        }
                    }
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

#Preview {
    ContentView()
        .environmentObject(VideoLibrary())
}

