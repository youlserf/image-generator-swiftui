//
//  PhotosAlbumViewModel.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import Foundation
import Photos
import UIKit


final class PhotosAlbumViewModel: ObservableObject {
    @Published var imageManager = PHCachingImageManager()
    @Published var assets = [PHAsset]()
    @Published var thumbnailSize: CGSize = .zero
    
    func fetchAssets(forAlbumTitle albumTitle: String) {
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
        
        var fetchedAssets = [PHAsset]()
        assetsFetchResult.enumerateObjects({ object, _, _ in
            fetchedAssets.append(object)
        })
        
        DispatchQueue.main.async {
            self.assets = fetchedAssets
            self.thumbnailSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        }
    }
}

