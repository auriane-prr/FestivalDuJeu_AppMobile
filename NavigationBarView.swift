//
//  NavigationBarView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct NavigationBarView: View {
    @State private var selectedTab = "accueil"
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)

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
        .accentColor(Color(customColor)) 
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            selectedTab = "accueil"
        }
    }
}
