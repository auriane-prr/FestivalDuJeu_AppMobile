//
//  HomeView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct NavigationBarView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var selectedTab = "accueil"

    var body: some View {
        TabView(selection: $selectedTab) {

            ParticiperView()
                .tabItem {
                    Label("Inscription", systemImage: "pencil")
                }
                .tag("inscription")

            FlexibleView()
                .tabItem {
                    Label("Flexible", systemImage: "arrow.left.arrow.right")
                }
                .tag("flexible")
            
                AccueilView()
                    .tabItem {
                        Label("Accueil", systemImage: "house")
                    }
                    .tag("accueil")

            PlanningView()
                .tabItem {
                    Label("Planning", systemImage: "calendar")
                }
                .tag("planning")

            ProfilView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
                .tag("profil")
        }
        .accentColor(.primary) // Modifier ici pour changer la couleur de l'icône sélectionnée
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                logoutButton
            }
        }
        .onAppear {
            selectedTab = "accueil" // Définir l'onglet par défaut si nécessaire
        }
    }

    var logoutButton: some View {
        Button(action: {
            viewModel.logout() // Assurez-vous que cette action met à jour l'état d'authentification comme il se doit
        }) {
            Image(systemName: "power")
                .accessibilityLabel("Logout")
        }
    }
}

