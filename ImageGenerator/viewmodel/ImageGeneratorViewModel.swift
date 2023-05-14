//
//  ImageGeneratorViewModel.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import Foundation
import OpenAIKit
import UIKit
import Photos

final class ImageGeneratorViewModel: ObservableObject {
    private var openai: OpenAI?
    func setup(){
        if let apiKey = UserDefaults.standard.string(forKey: "api-key"){
            print(apiKey)
            openai = OpenAI(
                Configuration(organizationId: "Personal", apiKey:  apiKey))
        }
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        guard let openai = openai else {
            return nil
        }
        
        do {
            let params  = ImageParameters(prompt: prompt,
                                          resolution: .medium,
                                          responseFormat: .base64Json)
            let result = try await openai.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            return image
        }
        catch {
            print(String(describing: error))
            return nil
        }
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
    
    func requestPermisionToSaveImage(albumName: String, image: UIImage){
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
    }
    
}
