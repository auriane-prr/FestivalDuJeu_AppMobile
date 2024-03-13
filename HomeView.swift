//
//  HomeView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var isAuthenticated: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenue dans l'application !")
            }
            .navigationTitle("Accueil")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Logout")
                    }
                }
            }
        }
        .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
            self.isAuthenticated = isAuthenticated
            if !isAuthenticated {
                // Rediriger l'utilisateur vers LoginView
                viewModel.loginViewPresented = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.loginViewPresented) {
            LoginView()
                .environmentObject(viewModel)
        }
    }
}
