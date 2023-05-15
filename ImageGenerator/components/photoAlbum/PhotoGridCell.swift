//
//  PhotoGridCell.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import SwiftUI
import Photos

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

