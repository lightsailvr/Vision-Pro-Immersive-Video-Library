//
//  PosterView.swift
//  ImmersiveVideoPlayer
//
//  Created by Matthew Celia on 2/23/24.
//

import SwiftUI

struct PosterView: View {

    let title: String
    let posterURL: String
    let category: String
    let client: String
    @State private var imageData: Data?

    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .frame(width: 258, height: 400)
                .opacity(0.3)
                
            
            VStack (alignment: .leading)
            {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 238, height: 334, alignment: .top)
                        .cornerRadius(15)
                        
                } else {
                    ProgressView()
                        .onAppear {
                            downloadImage()
                        }
                }
                HStack{
                    VStack (alignment: .leading) {
                        Text(title)
                            .font(.headline)
                        Text(client)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    Spacer()
                    Text(category)
                        .padding([.leading, .trailing], 4)
                        .padding([.top, .bottom], 4)
                        .background(RoundedRectangle(cornerRadius: 5).stroke())
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        
                }
            }.padding(20)
        }.frame(width: 258, height: 400)
    }
    
    
    
    private func downloadImage() {
            guard let url = URL(string: posterURL) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.imageData = data
                    }
                }
            }.resume()
        }
    
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(title: "Foo Fighters: The Next Stage", posterURL: "https://lightsail-public.s3.us-west-2.amazonaws.com/demo_content/posters/Canon_Poster_vp.png", category: "Commercial", client: "Meta")
    }
}
