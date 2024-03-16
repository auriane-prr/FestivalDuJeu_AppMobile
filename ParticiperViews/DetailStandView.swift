//
//  DetailStand.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct DetailStandView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject private var standModel = StandViewModel()
    let stand: Stand
    let selectedHeure : String

    var body: some View {
        VStack {
            Text(stand.nomStand)
                .font(.largeTitle)
            Text(stand.description)
                .padding()
            Button(action: {
                standModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                    guard let benevoleId = benevoleId else {
                        print("Impossible de récupérer l'ID du bénévole.")
                        return
                    }
                    if let horaireCota = stand.horaireCota.first(where: { $0.heure == selectedHeure }) {
                        let idHoraire = horaireCota.id
                        standModel.participerAuStand(idBenevole: benevoleId, idHoraire: idHoraire) { success, errorMessage in
                            if success {
                                print("Participation enregistrée avec succès.")
                            } else {
                                print("Erreur lors de la tentative de participation : \(errorMessage ?? "Erreur inconnue")")
                            }
                        }
                    } else {
                        print("Aucun horaire correspondant à \(selectedHeure) trouvé.")
                    }
                }
            }) {
                Text("Participer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
    }
}



