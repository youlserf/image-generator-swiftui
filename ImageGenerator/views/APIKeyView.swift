//
//  APIKeyView.swift
//  ImageGenerator
//
//  Created by youlserf on 9/05/23.
//
import SwiftUI



struct APIKeyView: View {
    @StateObject var vm = APIKeyViewModel()
    var body: some View {
        NavigationStack {
            ZStack  {
                CarouselView()
               VStack {
                   
                   Text("If you don't have an API key, please refer to the tutorial to obtain one.")
                       .font(.largeTitle)
                       .foregroundColor(.white)
                       .padding()
                       .background(.black)
                       .cornerRadius(10)

                   VStack
                   {
                        TextField("Enter your API key", text: $vm.apiKey)
                            .padding()
                            .background()
                            .cornerRadius(15)
                        
                        HStack {
                            Button("Validate") {
                                Task {
                                    await vm.validateKey()
                                }
                            }
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .alert(isPresented: $vm.showAlert) {
                                Alert(
                                    title: Text("API Key is not valid."),
                                    message: Text("Please enter a valid APIKey")
                                )
                            }

                            Button(action: {
                                if let url = URL(string: "https://www.youtube.com/watch?v=nafDyRsVnXU") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Watch tutorial")
                                    .padding()
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                            })
                        }

                        
                    }
                }
                .padding(10)
            }
            NavigationLink(
                destination: HomeView(),
                isActive: $vm.isLogged,
                label: {
                    EmptyView()
                })
        }
        .onAppear {
            if getAPIKey() != nil {
                vm.isLogged = true
            }
        }
    }
}

struct APIKeyView_Previews: PreviewProvider {
    static var previews: some View {
        APIKeyView()
    }
}
