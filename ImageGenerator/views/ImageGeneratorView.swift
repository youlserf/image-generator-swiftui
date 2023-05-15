//
//  ImageGeneratorView.swift
//  ImageGenerator
//
//  Created by youlserf on 9/05/23.
//

import SwiftUI
import Photos

struct ImageGeneratorView: View {
    var albumName: String
    @ObservedObject var vm = ImageGeneratorViewModel()
    @State var text = ""
    @State var image: UIImage? //= UIImage(named: "trump")
    @State var showAlert = false
    
    var body: some View {
        
        ZStack(alignment: .center) {
            VStack(alignment: .center
            ) {
                
                Spacer()
                    if let image = image {
                        ZStack(alignment: .top) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                            // Add save image button
                            HStack{
                                Button(action: {
                                    // Get the image from the image view.
                                    //let albumName = "My Album"
                                    vm.requestPermisionToSaveImage(albumName: albumName, image: image)
                                }, label: {
                                    Image(systemName: "square.and.arrow.down")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .padding()
                                        .background(Color.black.opacity(0.8))
                                        .clipShape(Circle())
                                        .padding()
                                })
                                Spacer()
                                Button(action: {
                                    self.image = nil
                                    self.text = ""
                                }, label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .padding()
                                        .background(Color.black.opacity(0.8))
                                        .clipShape(Circle())
                                        .padding()
                                })
                            }
                        }
                    }
                    else {
                        
                        TextField("Describe your image here...", text: $text)
                            .padding()
                    }
                
                Spacer()
                if image == nil {
                    Button("Generate!") {
                        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                            Task {
                                let result = await vm.generateImage(prompt: text)
                                if result == nil {
                                    print("Failed to get image")
                                    showAlert = true
                                    
                                }
                                self.image = result
                            }
                        }
                    }
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                }
            }
            .onAppear{
                vm.setup()
                
                
            }
            
            .padding()
            if showAlert {
                // Display the alert
                ModalView(isPresented: $showAlert)
            }
        }
        
    }
}


struct ModalView: View {
    @Binding var isPresented: Bool
    @State private var apiKey: String = ""
    @State private var showAlert = false
    @State private var taskRunning = false
    
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.4))
            .edgesIgnoringSafeArea(.all)
        
        VStack {
            Text("Enter your API Key:")
            TextField("", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Button("OK") {
                    taskRunning = true
                    Task {
                        // Validate the API key and dismiss the alert
                        let isValidKey = await validateAPIKey(apiKey: apiKey)
                        if isValidKey {
                            isPresented = false
                        } else {
                            showAlert = true
                        }
                        taskRunning = false
                    }
                }
                .padding()
                .disabled(apiKey.isEmpty || taskRunning)
                .foregroundColor(apiKey.isEmpty || taskRunning ? .gray : .blue)
                
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(width: 300, height: 200)
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        .alert(isPresented: $showAlert) {
            
            return Alert(title: Text("API Key is not valid."))
            
        }
    }
}

struct ImageGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGeneratorView(albumName: "My Album")
    }
}
