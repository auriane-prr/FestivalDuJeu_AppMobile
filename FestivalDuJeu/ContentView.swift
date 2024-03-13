//
//  ContentView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel() // Utilisez @StateObject ici

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                HomeView()
                    .environmentObject(viewModel) // Injecter viewModel dans HomeView
            } else {
                LoginView()
                    .environmentObject(viewModel) // Injecter viewModel dans LoginView
            }
        }
        .id(viewModel.isAuthenticated)
    }
}
