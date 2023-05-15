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
        Image("trump"),
        Image("muscle_g_1"),
        Image("biden"),
        Image("muscle_g_2"),
        Image("popeye"),
        Image("wwe")
    ]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height
            
            VStack(alignment: .center){
                ZStack(alignment: .center) {
                       images[currentIndex]
                           .resizable()
                           .scaledToFill()
                           .frame(maxWidth: frameWidth)
                           .frame(minWidth: frameWidth, minHeight: 400)
                           .clipped()
                      
                }
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
