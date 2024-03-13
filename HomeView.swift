//
//  HomeView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenue dans l'application !")
                // Autres éléments de votre HomeView
            }
            .navigationTitle("Bienvenue \(viewModel.username)")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.logout() // S'assurer que cette méthode réinitialise `isAuthenticated` à `false`
                    }) {
                        Text("Logout")
                    }
                }
            }
        }
    }
}
