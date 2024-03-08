//
//  LibraryView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/23/24.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject var videoLibrary: VideoLibrary
    @EnvironmentObject var videoPlayer: VideoPlayer
    @State private var showImmersiveSpace = false
    @State private var showDetails = false
    @State private var searchText: String = ""
    @State private var isVideoLocal: Bool = false
    
    var videos: [Video]
    var libraryFileName: String
    
    init( videos: [Video], libraryFileName: String) {
        self.videos = videos
        self.libraryFileName = libraryFileName
        
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView (.horizontal, showsIndicators: false){
                HStack{
                    ForEach(videos) { video in
                        Button(action: {
                            setCurrentVideo(selectedVideo: video)
                            showDetails = true
                        }, label: {
                            PosterView(title: video.title, posterURL: video.poster, category: video.category, client: video.client)
                            
                        }).hoverEffect()
                    }.padding()
                        .buttonStyle(.plain)
                    
                }
            }.padding(.horizontal, 24)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading){
                        VStack (alignment: .leading, content: {
                            Text("Library")
                                .font(.largeTitle)
                            Text(libraryFileName)
                                .foregroundStyle(.tertiary)
                        }).padding(.top, 20)
                    }
                    ToolbarItem{
                        TextField("Search Library", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 250)
                            .padding(.top, 20)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomOrnament){
                        if showDetails {
                            DetailsView(showDetails: $showDetails, showImmersiveSpace: $showImmersiveSpace, isVideoLocal: $isVideoLocal)
                        }
                    }
                }
                .onChange(of: showImmersiveSpace) { _, newValue in
                    Task {
                        if newValue {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                            dismissWindow(id: "ContentLibrary")
                        } else {
                            showImmersiveSpace = false
                        }
                    }
                }
        }
    }
    func setCurrentVideo(selectedVideo: Video){
        print(selectedVideo.title)

        videoPlayer.currentVideoTitle = selectedVideo.title
        videoPlayer.currentVideoDescription = selectedVideo.description
        videoPlayer.currentVideoThumbnail = selectedVideo.thumbnail
        videoPlayer.videoURL = URL(string: selectedVideo.url)!
        isVideoLocal = videoPlayer.detectLocalVideo()
    }

}

#Preview {
    LibraryView(videos: PreviewData.load(name: "PreviewLibrary"), libraryFileName: "TestData.json")
}
