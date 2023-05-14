//
//  APIKeyViewModel.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import Foundation
import OpenAIKit

final class APIKeyViewModel: ObservableObject {
    @Published var apiKey:String = ""
    @Published var isValid = false
    @Published var showAlert = false
    @Published var isLogged = false
    
    func validateKey() async  {
        let config = Configuration(organizationId: "Personal", apiKey: apiKey)
        let openai = OpenAI(config)
        
        do {
            _ = try await openai.listModels()
            DispatchQueue.main.async {
                self.isValid = true
                UserDefaults.standard.set(self.apiKey, forKey: "api-key")
                self.showAlert = true
            }
        } catch {
            DispatchQueue.main.async {
                self.isValid = true
                UserDefaults.standard.set(self.apiKey, forKey: "api-key")
                print("saving")
                self.showAlert = true
            }
        }
    }
    
}


