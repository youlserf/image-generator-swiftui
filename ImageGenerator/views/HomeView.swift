//
//  HomeView.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selection = 0
    let options = ["Generate image", "See all images"]
    let albumName: String = "My Album"
    var body: some View {
        
        NavigationView {
            VStack
            {
                Picker(selection: $selection, label: Text("Options")) {
                    ForEach(0 ..< 2) {
                        Text(self.options[$0]).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
                if selection == 0 {
                    ImageGeneratorView(albumName: albumName)
                } else {
                    PhotosAlbumView(albumTitle: albumName)
                }
                Spacer()
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
                                Button(action: {
            // Log the user out and take them to the login screen
            deleteAPIKey()
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "power")
                .foregroundColor(.black)
        }
        )
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
