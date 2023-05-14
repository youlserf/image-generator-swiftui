//
//  ImageGeneratorView.swift
//  ImageGenerator
//
//  Created by youlserf on 9/05/23.
//

import SwiftUI
import Photos

struct ImageGeneratorView: View {
    var albumName: String
    @ObservedObject var vm = ImageGeneratorViewModel()
    @State var text = ""
    @State var image: UIImage? = UIImage(named: "trump")
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                if let image = image {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(minHeight: 400)
                            .frame(maxHeight: 400)
                        // Add save image button
                        Button(action: {
                            // Get the image from the image view.
                            //let albumName = "My Album"
                            vm.requestPermisionToSaveImage(albumName: albumName, image: image)
                        }, label: {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .clipShape(Circle())
                                .padding()
                        })
                        
                    }
                }
                else {
                    TextField("Type prompt here...", text: $text)
                        .padding()
                }
               
                Spacer()
                Button("Generate!") {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await vm.generateImage(prompt: text)
                            if result == nil {
                                print("Failed to get image")
                            }
                            self.image = result
                        }
                    }
                }
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            
            .onAppear{
                vm.setup()
            }
            .padding()
        }
    }
}

struct ImageGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGeneratorView(albumName: "My Album")
    }
}
