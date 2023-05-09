//
//  APIKeyView.swift
//  ImageGenerator
//
//  Created by youlserf on 9/05/23.
//

import OpenAIKit
import SwiftUI

struct APIKeyView: View {
    @State private var apiKey = ""
    @State private var isValid = false
    @State private var showAlert = false
    func validateKey(key: String) async -> Bool {
        let config = Configuration(organizationId: "Personal", apiKey: key)
        let openai = OpenAI(config)
        
        do {
            _ = try await openai.listModels()
            return true
        } catch {
            return false
        }
    }


   var body: some View {
       
       VStack {
           TextField("Enter your API key", text: $apiKey)
               .padding()
           
           Button("Validate") {
               Task {
                              let response = await validateKey(key: apiKey)
                              self.isValid = response
                              
                              // Show alert based on validation result
                              self.showAlert = true
                          }
           }.alert(isPresented: $showAlert) {
               if isValid {
                   return Alert(title: Text("API Key is valid!"))
               } else {
                   return Alert(title: Text("API Key is not valid."))
               }
           }
    
       }
    }
}

struct APIKeyView_Previews: PreviewProvider {
    static var previews: some View {
        APIKeyView()
    }
}
