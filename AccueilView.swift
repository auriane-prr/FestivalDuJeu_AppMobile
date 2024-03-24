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
                if let festival = festivalModel.latestFestival {
                    VStack {
                        Text("Bienvenue au \(festival.nom) !")
                            .font(.title2)
                            .padding(.top, 100)
                            .padding(.bottom, 20)
                        Text("Cette année, le festival aura lieux du \(formatDate(date: festival.dateDebut)) au \(formatDate(date: festival.dateFin)).")
                    }
                    .padding()
                } else {
                    Text("Chargement des informations du festival...")
                        .padding()
                }
                
                Divider()

                VStack(alignment: .leading) {
                    Text("RECHERCHE JEUX")
                        .font(.headline)
                        .padding(.bottom, 10)
                    Text("Tu cherches un jeu à animer ?")
                    Text("Trouves sa zone ici : ")
                    
                    TextField("Rechercher un jeu", text: $gameModel.searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                .frame(maxWidth: .infinity)
                .padding()
            }
            .onAppear {
                festivalModel.loadLatestFestival()
            }
            .overlay(
                Image("nom_app")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .offset(y: -50),
                alignment: .top
            )
            .overlay(
                Image("logo_court")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .offset(x: 110, y: -90)
            )
        }
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }

}



#Preview{
    AccueilView()
}
