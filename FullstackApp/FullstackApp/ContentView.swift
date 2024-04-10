//
//  ContentView.swift
//  FullstackApp
//
//  Created by Maxwell Wayne on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.textToDisplay)
            HStack {
                Button("Fetch Text 1", action: viewModel.fetchTextOne).buttonStyle(.borderedProminent)
                Button("Fetch Text 2", action: viewModel.fetchTextTwo).buttonStyle(.borderedProminent)
                Button("Fetch Text 3", action: viewModel.fetchTextThree).buttonStyle(.borderedProminent)
            }
            Button("Reset Text", action: viewModel.resetText).buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
