//
//  PhotosAlbumViewModel.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import Foundation
import Photos


final class PhotosAlbumViewModel: ObservableObject {
    @Published private var assets = [PHAsset]()
    @Published private var imageManager = PHCachingImageManager()
    @Published private var thumbnailSize: CGSize = .zero
    
    
}
