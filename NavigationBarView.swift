//
//  NavigationBarView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct NavigationBarView: View {
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
        .onAppear {
            selectedTab = "accueil" // Définir l'onglet par défaut si nécessaire
        }
    }
}
