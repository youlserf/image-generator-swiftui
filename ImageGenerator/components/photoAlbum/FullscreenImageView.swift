//
//  FullscreenImageView.swift
//  ImageGenerator
//
//  Created by youlserf on 14/05/23.
//

import SwiftUI
import Photos

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
