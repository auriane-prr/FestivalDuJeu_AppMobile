//
//  DetailJeuView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 23/03/2024.
//

import SwiftUI


struct DetailJeuView: View {
    let jeu: Jeu

    var body: some View {
        List {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    // Affichage du titre en plus gros
                    Text(jeu.nomJeu)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    // Affichage du logo en plus gros
                    if let logoURL = jeu.logo, let url = URL(string: logoURL), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 20)
                    }
                }
                .listRowInsets(EdgeInsets())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.clear)
            
            Section(header: Text("Description")) {
                Text(jeu.description)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section(header: Text("Informations générales")) {
                // Vos champs d'informations ici, par exemple :
                HStack {
                    Text("Éditeur:")
                    Spacer()
                    Text(jeu.editeur)
                }
                HStack {
                    Text("Âge minimum:")
                    Spacer()
                    Text(jeu.ageMin ?? "N/A")
                }
                HStack {
                    Text("Durée:")
                    Spacer()
                    Text(jeu.duree ?? "N/A")
                }
                HStack {
                    Text("Nombre de joueurs:")
                    Spacer()
                    Text(jeu.nbJoueurs)
                }
                HStack {
                    Text("Thème:")
                    Spacer()
                    Text(jeu.theme ?? "N/A")
                }
                HStack {
                    Text("Mécanisme:")
                    Spacer()
                    Text(jeu.mecanisme ?? "N/A")
                }
                HStack {
                    Text("Tags:")
                    Spacer()
                    Text(jeu.tags ?? "N/A")
                }
                
                if let lien = jeu.lien, let url = URL(string: lien) {
                    Link("Lien vers les règles", destination: url)
                }
            }

            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}
