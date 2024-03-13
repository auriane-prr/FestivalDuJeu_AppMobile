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
            LoginView()
                .environmentObject(viewModel) // Passez l'instance de AuthViewModel à LoginView
        }
    }
}
