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
                    TextField("Enter your API key", text: $vm.apiKey)
                        .padding()
                        .background()
                        .cornerRadius(15)
                    
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
                        if vm.isValid {
                            return Alert(title: Text("API Key is valid!"),  dismissButton: .default(Text("OK"), action: {
                                
                                self.vm.isLogged = true
                                
                            }))
                        } else {
                            return Alert(title: Text("API Key is not valid."))
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
    }
}

struct APIKeyView_Previews: PreviewProvider {
    static var previews: some View {
        APIKeyView()
    }
}
