//
//  ContentView.swift
//  FullstackApp
//
//  Created by Maxwell Wayne on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var updatedTextOne: String = ""
    @State private var updatedTextTwo: String = ""
    @State private var updatedTextThree: String = ""
    
    var body: some View {
        VStack {
            Text(viewModel.textToDisplay)
            HStack {
                self.fetchTextButton(withTitle: "Fetch Text 1", action: self.viewModel.fetchTextOne)
                self.fetchTextButton(withTitle: "Fetch Text 2", action: self.viewModel.fetchTextTwo)
                self.fetchTextButton(withTitle: "Fetch Text 3", action: self.viewModel.fetchTextThree)
            }
            self.fetchTextButton(withTitle: "Reset Text", action: self.viewModel.resetText)
            self.updateTextView(buttonTitle: "Update Text 1",
                                buttonAction: {
                self.viewModel.updateTextOne(newText: self.updatedTextOne)
            },
                                textPreview: "Update text 1 here",
                                text: self.$updatedTextOne)
            self.updateTextView(buttonTitle: "Update Text 2",
                                buttonAction: {
                self.viewModel.updateTextTwo(newText: self.updatedTextTwo)
            },
                                textPreview: "Update text 2 here",
                                text: self.$updatedTextTwo)
            self.updateTextView(buttonTitle: "Update Text 3",
                                buttonAction: {
                self.viewModel.updateTextThree(newText: self.updatedTextThree)
            },
                                textPreview: "Update text 3 here",
                                text: self.$updatedTextThree)
        }
    }
    
    func fetchTextButton(withTitle title: String, action: @escaping () -> Void) -> some View {
        return Button(title, action: action).buttonStyle(.borderedProminent)
    }
    
    func updateTextView(buttonTitle: String,
                        buttonAction: @escaping () -> Void,
                        textPreview: String,
                        text: Binding<String>) -> some View {
        return HStack {
            Spacer()
            Button(buttonTitle, action: buttonAction).buttonStyle(.borderedProminent)
            TextField(textPreview, text: text)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
    }
    
}

#Preview {
    ContentView(viewModel: ViewModel())
}
