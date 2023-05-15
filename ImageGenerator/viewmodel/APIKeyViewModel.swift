//
//  APIKeyViewModel.swift
//  ImageGenerator
//
//  Created by youlserf on 13/05/23.
//

import Foundation
import OpenAIKit

func deleteAPIKey() {
    UserDefaults.standard.removeObject(forKey: "api-key")
}

func saveAPIKey(apiKey: String) {
    UserDefaults.standard.set(apiKey, forKey: "api-key")
}

func validateAPIKey(apiKey: String) async -> Bool {
    let config = Configuration(organizationId: "Personal", apiKey: apiKey)
    let openai = OpenAI(config)
    
    do {
        _ = try await openai.listModels()
        DispatchQueue.main.async {
            saveAPIKey(apiKey: apiKey)
        }
        return true
    } catch {
        return false
    }
}
func getAPIKey() -> String? {
    return UserDefaults.standard.string(forKey: "api-key")
}


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
                
                saveAPIKey(apiKey: self.apiKey)
                self.isValid = true
                self.isLogged = true
            }
        } catch {
            DispatchQueue.main.async {
                saveAPIKey(apiKey: self.apiKey)
                self.isValid = false
                self.isLogged = false
                
                self.showAlert = true
            }
        }
    }
    
}


