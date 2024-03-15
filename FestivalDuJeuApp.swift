//
//  FestivalDuJeuApp.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

@main
struct FestivalDuJeuApp: App {
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // Navigation conditionnelle basée sur l'état d'authentification
            if viewModel.isAuthenticated {
                NavigationBarView()
                    .environmentObject(viewModel)
            } else {
                LoginView()
                    .environmentObject(viewModel)
            }
        }
    }
}
