//
//  PhotoAlbumView.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import SwiftUI
import Photos

extension PHAsset: Identifiable {}

struct PhotosAlbumView: View {

    let albumTitle: String
    @StateObject private var vm = PhotosAlbumViewModel()
    
    var body: some View {
   
            VStack {
                if vm.assets.isEmpty {
                    Text("No photos in album")
                        .font(.title)
                        .foregroundColor(.secondary)
                } else {
                    PhotoGridView(assets: vm.assets, imageManager: vm.imageManager, thumbnailSize: vm.thumbnailSize)
                }
            }
            .onAppear {
                vm.fetchAssets(forAlbumTitle: albumTitle)
            }
       
    }
}


struct PhotosAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosAlbumView(albumTitle: "My Album")
    }
}
