//
//  ProfilView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct ProfilView: View {
    @EnvironmentObject var authModel: AuthViewModel
    @StateObject var benevoleViewModel = BenevoleViewModel()

    var body: some View {
        VStack {
            if let benevole = benevoleViewModel.benevole {
                // Utilisation de Text pour afficher les informations
                Text("Bienvenue, \(benevole.pseudo)").font(.headline)
                Group {
                    Text("Nom: \(benevole.nom)")
                    Text("Prénom: \(benevole.prenom)")
                    Text("Pseudo: \(benevole.pseudo)")
                    Text("Association: \(benevole.association)")
                    Text("Taille de T-shirt: \(benevole.taille_tshirt)")
                    Text("Végétarien: \(benevole.vegetarien ? "Oui" : "Non")")
                    Text("E-mail: \(benevole.mail)")
                    Text("Téléphone: \(benevole.num_telephone)")
                    if let adresse = benevole.adresse {
                        Text("Adresse: \(adresse)")
                    }
                    Text("Hébergement: \(benevole.hebergement)")
                }
                .padding(.vertical, 2)
            } else if benevoleViewModel.isLoading {
                ProgressView()
            } else {
                Text("Impossible de charger les données du bénévole.")
            }
        }
        .padding()
        .onAppear {
            benevoleViewModel.fetchBenevole(pseudo: authModel.username)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}
