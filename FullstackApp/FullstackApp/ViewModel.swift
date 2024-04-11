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
        do {
            try self.requestTextFor(id: "66158aa164b8f022a16c666e") { text in
                DispatchQueue.main.async {
                    self.textToDisplay = text.text
                }
            }
        } catch {
            self.textToDisplay = self.getErrorText(for: error)
        }
    }
    
    func fetchTextTwo() {
        do {
            try self.requestTextFor(id: "66184c7241eed97a069d64e0") { text in
                DispatchQueue.main.async {
                    self.textToDisplay = text.text
                }
            }
        } catch {
            self.textToDisplay = self.getErrorText(for: error)
        }
    }
    
    func fetchTextThree() {
        do {
            try self.requestTextFor(id: "66184c7641eed97a069d64e2") { text in
                DispatchQueue.main.async {
                    self.textToDisplay = text.text
                }
            }
        } catch {
            self.textToDisplay = self.getErrorText(for: error)
        }
    }
    
    func resetText() {
        self.textToDisplay = ViewModel.defaultText
    }
    
    private func requestTextFor(id: String, completionHandler: @escaping(TextModel)->()) throws {
        Task {
            let endpoint = "http://\(currentIp):8081/get"
            guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
            var request = URLRequest(url: url)
            request.setValue(id, forHTTPHeaderField: "_id")
            request.httpMethod = "GET"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
            
            do {
                let decoder = JSONDecoder()
                let text = try decoder.decode(TextModel.self, from: data)
                completionHandler(text)
            } catch {
                throw NetworkError.invalidData
            }
        }
    }
    
    private func getErrorText(for error: Error) -> String {
        guard let networkError = error as? NetworkError else { return "Unknown error" }
        switch networkError {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        }
    }
    
}
