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
    @State private var referentPseudos: [String: String] = [:]

    let zone: Zone
    let selectedHeure: String
    let customColor = Color(UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8))

    var body: some View {
        ScrollView {
            VStack{
                Text("\(zone.nomZone) : \(selectedHeure)")
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Form {
                                    Section(header: Text("Informations générales")) {
                                        if !zone.referents.isEmpty {
                                            Text("Référents :")
                                            ForEach(zone.referents, id: \.id) { referent in
                                                Text(referentPseudos[referent.id, default: "Chargement du pseudo..."])
                                            }
                                        }
                                        
                                        if let horaireCota = zone.horaireCota.first(where: { $0.heure == selectedHeure }) {
                                            Text("Nombre de bénévoles requis : \(horaireCota.nbBenevole ?? 0)")
                                        }
                                    }
                    Section(header: Text("Liste des bénévoles déjà inscrits")) {
                                    if let horaireCota = zone.horaireCota.first(where: { $0.heure == selectedHeure }),
                                       let listeBenevole = horaireCota.listeBenevole, !listeBenevole.isEmpty {
                                        
                                            ForEach(listeBenevole, id: \.id) { benevole in
                                                Text(referentPseudos[benevole.id, default: "Chargement du pseudo..."])
                                            }
                                        
                                    } else {
                                            Text("Aucun bénévole inscrit pour cet horaire.")
                                        }
                                    }
                                    
                                    Section(header: Text("Jeux disponibles")) {
                                        if zoneModel.isLoading {
                                            Text("Chargement des jeux...")
                                        } else if !zoneModel.jeux.isEmpty {
                                            ForEach(zoneModel.jeux) { jeu in
                                                NavigationLink(destination: DetailJeuView(jeu: jeu)) {
                                                    Text(jeu.nomJeu)
                                                }
                                            }
                                        } else {
                                            Text("Aucun jeu trouvé dans cette zone.")
                                        }
                                    }
                                }
                .frame(height: 500)
                
                
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
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(customColor)
                        .cornerRadius(8)
                }
            }
        }
        .onAppear {
            zoneModel.fetchJeuxByZone(idZone: zone.id)
            for referent in zone.referents {
                benevoleModel.fetchPseudoById(id: referent.id) { pseudo in
                    if let pseudo = pseudo {
                        DispatchQueue.main.async {
                            self.referentPseudos[referent.id] = pseudo
                        }
                    }
                }
            }
            
            if let horaireCota = zone.horaireCota.first(where: { $0.heure == selectedHeure }), let listeBenevole = horaireCota.listeBenevole {
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
