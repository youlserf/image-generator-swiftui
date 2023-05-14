//
//  CarouselView.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import SwiftUI

struct CarouselView: View {
    @State private var currentIndex = 0
    
    var images = [
        Image("waifu-1"),
        Image("waifu-2"),
        Image("waifu-3"),
    ]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height
            
            VStack(alignment: .center){
                ZStack(alignment: .center) { // align to the right and top
                    images[(currentIndex + 1) % images.count]
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .offset( x: -60, y: 60)
                    
                    images[currentIndex]
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .offset( x: -30, y: 30)
                    
                    images[(currentIndex + 2) % images.count]
                        .resizable()
                        .scaledToFit()
                        .clipped()
                }
                .offset(y: -45)
                .frame(width: frameWidth, height: 500)
            }
            .frame(width: frameWidth, height: frameHeight)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
        }
    }
}


struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
