//
//  ImageGeneratorView.swift
//  ImageGenerator
//
//  Created by youlserf on 9/05/23.
//

import SwiftUI
import Photos

struct ImageGeneratorView: View {
    @ObservedObject var viewModel = ImageGeneratorViewModel()
    @State var text = ""
    @State var image: UIImage?
    @State var showSaveAlert = false
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    Image("waifu-3")
                        .resizable()
                        .scaledToFill()
                        .frame(minHeight: 400)
                        .frame(maxHeight: 400)
                    // Add save image button
                    Button(action: {
                        // Get the image from the image view.
                        let albumName = "My Album"
                        guard let image = UIImage(named: "waifu-3") else { return }
                        PHPhotoLibrary.requestAuthorization { status in
                            if status == .authorized {
                                var assetPlaceholder: PHObjectPlaceholder?
                                
                                // Check if album already exists
                                let fetchOptions = PHFetchOptions()
                                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                                let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                                
                                // Create album if it does not exist
                                if let firstObject = collection.firstObject {
                                    // Album already exists
                                    self.saveImageToAlbum(image: image, assetCollection: firstObject)
                                } else {
                                    // Album does not exist, create it
                                    PHPhotoLibrary.shared().performChanges({
                                        let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                                        assetPlaceholder = request.placeholderForCreatedAssetCollection
                                    }, completionHandler: { success, error in
                                        if success, let placeholder = assetPlaceholder {
                                            let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                                            if let album = collectionFetchResult.firstObject {
                                                self.saveImageToAlbum(image: image, assetCollection: album)
                                            }
                                        } else {
                                            print("Error creating album: \(error?.localizedDescription ?? "")")
                                        }
                                    })
                                }
                            } else {
                                print("Permission denied")
                            }
                        }
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
                Spacer()
                
                TextField("Type prompt here...", text: $text)
                    .padding()
                
                Button("Generate!") {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await viewModel.generateImage(prompt: text)
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
                viewModel.setup()
            }
            .padding()
        }
        .navigationTitle("DALL-E Image Generator")
    }
    
    func saveImageToAlbum(image: UIImage, assetCollection: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
        }, completionHandler: { success, error in
            if success {
                print("Image saved to album")
            } else {
                print("Error saving image: \(error?.localizedDescription ?? "")")
            }
        })
    }
}

struct ImageGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGeneratorView()
    }
}
