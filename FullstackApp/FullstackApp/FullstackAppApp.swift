//
//  FullstackAppApp.swift
//  FullstackApp
//
//  Created by Maxwell Wayne on 4/10/24.
//

import SwiftUI

@main
struct FullstackAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
