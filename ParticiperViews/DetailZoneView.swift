//
//  DetailZoneView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 16/03/2024.
//

import SwiftUI

struct DetailZoneView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject private var zoneModel = ZoneViewModel()
    
    @StateObject private var benevoleModel = BenevoleViewModel()
    let zone: Zone
    let selectedHeure : String
    
    var body: some View {
        VStack {
            Text(zone.nomZone)
                .font(.largeTitle)
            Button(action: {
                benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                    guard let benevoleId = benevoleId else {
                        print("Impossible de récupérer l'ID du bénévole.")
                        return
                    }
                    if let horaireCota = zone.horaireCota.first(where: { $0.heure == selectedHeure }) {
                        let idHoraire = horaireCota.id
                        zoneModel.participerALaZone(idBenevole: benevoleId, idHoraire: idHoraire) { success, errorMessage in
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
