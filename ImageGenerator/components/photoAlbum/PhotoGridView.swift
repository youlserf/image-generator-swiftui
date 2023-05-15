//
//  PhotoGridView.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import SwiftUI
import Photos

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
