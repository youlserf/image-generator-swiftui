//
//  HomeView.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import SwiftUI
import Photos

extension PHAsset: Identifiable {}

struct HomeView: View {
    let albumTitle: String

        @State private var assets = [PHAsset]()
        @State private var imageManager = PHCachingImageManager()
        @State private var thumbnailSize: CGSize = .zero

        var body: some View {
            NavigationView {
                VStack {
                    if assets.isEmpty {
                        Text("No photos in album")
                            .font(.title)
                            .foregroundColor(.secondary)
                    } else {
                        PhotoGridView(assets: assets, imageManager: imageManager, thumbnailSize: thumbnailSize)
                    }
                }
                .navigationTitle(Text(albumTitle))
                .onAppear {
                    fetchAssets()
                }
            }
        }

        func fetchAssets() {
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "title = %@", albumTitle)
            let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)

            guard let assetCollection = album.firstObject else {
                return
            }

            let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)

            guard assetsFetchResult.count > 0 else {
                return
            }

            assetsFetchResult.enumerateObjects({ object, _, _ in
                self.assets.append(object)
            })

            thumbnailSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        }
}

struct PhotoGridView: View {
  
    @State var selectedAsset: PHAsset?
    let assets: [PHAsset]
    let imageManager: PHCachingImageManager
    let thumbnailSize: CGSize
    
    var columns: [GridItem] {
        return Array(repeating: .init(.flexible()), count: 3)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(assets, id: \.self) { asset in
                    Button(action: {
                        selectedAsset = asset
                    }) {
                        PhotoGridCell(asset: asset, imageManager: imageManager, thumbnailSize: thumbnailSize)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .fullScreenCover(item: $selectedAsset) { asset in
            if let image = loadImage(for: asset) {
                FullscreenImageView(image: image)
            }
        }
    }
    
    func loadImage(for asset: PHAsset) -> UIImage? {
        var loadedImage: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
            loadedImage = image
        }
        return loadedImage
    }
    
}

struct FullscreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea(.all)
            .overlay(
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                })
                .padding(16),
                alignment: .topTrailing
            )
    }
}

struct PhotoGridCell: View {
    let asset: PHAsset
    let imageManager: PHCachingImageManager
    let thumbnailSize: CGSize
    
    @State private var thumbnail: UIImage?
    
    var body: some View {
        if let thumbnail = thumbnail {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                .clipped()
        } else {
            Color.gray
                .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                .onAppear {
                    self.loadThumbnail()
                }
        }
    }
    
    private func loadThumbnail() {
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { image, _ in
            self.thumbnail = image
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(albumTitle: "My Album")
    }
}
