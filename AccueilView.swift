//
//  AccueilView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct AccueilView: View {
    @StateObject private var festivalModel = FestivalViewModel()
    @StateObject private var gameModel = JeuViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenue au Festival Du Jeu - 2024")
                Text("Tu cherches un jeu à animer, trouves sa zone ici : ")
                TextField("Rechercher un jeu", text: $gameModel.searchTerm)
                    .padding()

                List(gameModel.gameSuggestions) { gameWithZone in
                    VStack(alignment: .leading) {
                        Text(gameWithZone.nomJeu)
                            .font(.headline)
                        Text("Zone: \(gameWithZone.nomZone)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Accueil")
        }
    }
}


