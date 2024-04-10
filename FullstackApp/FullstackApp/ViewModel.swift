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
    
    func fetchTextOne() {
        self.textToDisplay = "Text one"
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
