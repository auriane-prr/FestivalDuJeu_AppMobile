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
    @StateObject private var benevoleModel = BenevoleViewModel()
    @State private var referentPseudos: [String: String] = [:]
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let stand: Stand
    let selectedHeure: String
    
    let customColor = Color(UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8))
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(stand.nomStand) : \(selectedHeure)")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                Form {
                    Section(header: Text("Informations générales")) {
                        Text("Description : \(stand.description)")
                        if !stand.referents.isEmpty {
                            Text("Référents :")
                            ForEach(stand.referents, id: \.id) { referent in
                                Text(referentPseudos[referent.id, default: "Chargement du pseudo..."])
                            }
                        }
                        
                        if let horaireCota = stand.horaireCota.first(where: { $0.heure == selectedHeure }) {
                            Text("Nombre de bénévoles requis : \(horaireCota.nbBenevole ?? 0)")
                        }
                    }
                    Section(header: Text("Liste des bénévoles déjà inscrits")) {
                        if let horaireCota = stand.horaireCota.first(where: { $0.heure == selectedHeure }),
                           let listeBenevole = horaireCota.listeBenevole, !listeBenevole.isEmpty {
                            
                            ForEach(listeBenevole, id: \.id) { benevole in
                                Text(referentPseudos[benevole.id, default: "Chargement du pseudo..."])
                            }
                            
                        } else {
                            Text("Aucun bénévole inscrit pour cet horaire.")
                        }
                    }
                }
                
                Button(action: {
                                    benevoleModel.getBenevoleId(pseudo: authModel.username) { benevoleId in
                                        guard let benevoleId = benevoleId else {
                                            print("Impossible de récupérer l'ID du bénévole.")
                                            return
                                        }
                                        if let horaireCota = stand.horaireCota.first(where: { $0.heure == selectedHeure }) {
                                            let idHoraire = horaireCota.id
                                            standModel.participerAuStand(idBenevole: benevoleId, idHoraire: idHoraire) { success, message in
                                                alertMessage = message ?? (success ? "Votre participation a été enregistrée avec succès." : "Erreur lors de la participation.")
                                                showingAlert = true
                                            }
                                        } else {
                                            print("Aucun horaire correspondant à \(selectedHeure) trouvé.")
                                        }
                                    }
                                }) {
                                    Text("Participer")
                                        .foregroundColor(.white)
                                        .frame(width: 300, height: 50)
                                        .background(customColor)
                                        .cornerRadius(8)
                                }
                                .padding(.top, 20)
                
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                }
                            }
                        }
        .onAppear {
            for referent in stand.referents {
                benevoleModel.fetchPseudoById(id: referent.id) { pseudo in
                    if let pseudo = pseudo {
                        DispatchQueue.main.async {
                            self.referentPseudos[referent.id] = pseudo
                        }
                    }
                }
            }
            
            if let horaireCota = stand.horaireCota.first(where: { $0.heure == selectedHeure }), let listeBenevole = horaireCota.listeBenevole {
                for benevole in listeBenevole {
                    benevoleModel.fetchPseudoById(id: benevole.id) { pseudo in
                        if let pseudo = pseudo {
                            DispatchQueue.main.async {
                                self.referentPseudos[benevole.id] = pseudo
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
