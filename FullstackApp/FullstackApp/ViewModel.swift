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
    private let textOneId = "66158aa164b8f022a16c666e"
    private let textTwoId = "66184c7241eed97a069d64e0"
    private let textThreeId = "66184c7641eed97a069d64e2"
    
    // MARK: Fetch text
    
    func fetchTextOne() {
        self.issueRequestForText(withId: self.textOneId)
    }
    
    func fetchTextTwo() {
        self.issueRequestForText(withId: self.textTwoId)
    }
    
    func fetchTextThree() {
        self.issueRequestForText(withId: self.textThreeId)
    }
    
    func resetText() {
        self.textToDisplay = ViewModel.defaultText
    }
    
    private func issueRequestForText(withId id: String) {
        Task {
            do {
                let text = try await self.requestTextFor(id: id)
                DispatchQueue.main.async {
                    self.textToDisplay = text.text
                }
            } catch {
                DispatchQueue.main.async {
                    self.textToDisplay = self.getErrorText(for: error)
                }
            }
        }
    }
    
    private func requestTextFor(id: String) async throws -> TextModel {
        let endpoint = "http://\(currentIp):8081/get"
        
        let request = try self.createGetRequest(endpoint: endpoint, 
                                                queryItems: [URLQueryItem(name: TextModel.CodingKeys._id.rawValue, value: id)])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            let text = try decoder.decode(TextModel.self, from: data)
            return text
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    private func createGetRequest(endpoint: String, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: endpoint) else { throw NetworkError.invalidEndpoint }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        return request
    }
    
    private func getErrorText(for error: Error) -> String {
        guard let networkError = error as? NetworkError else { return "Unknown error" }
        switch networkError {
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        }
    }
    
    // MARK: Update text
    
    func updateTextOne(newText: String) {
        self.issueRequestForUpdateText(withId: self.textOneId, newText: newText)
    }
    
    func updateTextTwo(newText: String) {
        self.issueRequestForUpdateText(withId: self.textTwoId, newText: newText)
    }
    
    func updateTextThree(newText: String) {
        self.issueRequestForUpdateText(withId: self.textThreeId, newText: newText)
    }
    
    private func issueRequestForUpdateText(withId id: String, newText: String) {
        Task {
            do {
                try await self.updateText(id: id, newText: newText)
            } catch {
                print(self.getErrorText(for: error))
            }
        }
    }
    
    private func updateText(id: String, newText: String) async throws {
        let endpoint = "http://\(currentIp):8081/update"
        let request = try self.createPostRequest(endpoint: endpoint,
                                     requestBody: TextModel(id: id, text: newText))
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
    }
    
    private func createPostRequest(endpoint: String, requestBody: Encodable) throws -> URLRequest {
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        let jsonData = try JSONEncoder().encode(requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.httpMethod = HttpMethod.POST.rawValue
        return request
    }
    
}
