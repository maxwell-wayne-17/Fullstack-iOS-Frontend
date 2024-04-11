//
//  ViewModel.swift
//  FullstackApp
//
//  Created by Maxwell Wayne on 4/10/24.
//

import Foundation

class ViewModel: ObservableObject {
    private static let defaultText = "Try fetching some text!"
    @Published var textToDisplay: String = ViewModel.defaultText
    
    private let currentIp = IP.home.rawValue
    
    func fetchTextOne() {
        Task { @MainActor in
            var displayText: String
            do {
                displayText = try await self.requestTextOne().text
            }
            catch NetworkError.invalidURL {
                displayText = "Invalid URL"
            } catch NetworkError.invalidResponse {
                displayText = "Invalid response"
            } catch NetworkError.invalidData {
                displayText = "Invalid data"
            } catch {
                displayText = "Error"
            }
            self.textToDisplay = displayText
        }
    }
    
    private func requestTextOne() async throws -> TextModel {
        let endpoint = "http://\(currentIp):8081/getall"
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let texts = try decoder.decode([TextModel].self, from: data)
            return texts[0]
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func fetchTextTwo() {
        self.textToDisplay = "Text two"
    }
    
    func fetchTextThree() {
        self.textToDisplay = "Text three"
    }
    
    func resetText() {
        self.textToDisplay = ViewModel.defaultText
    }
    
}
