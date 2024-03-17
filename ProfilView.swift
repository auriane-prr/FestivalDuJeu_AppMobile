//
//  ProfilView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct ProfilView: View {
    @EnvironmentObject var authModel: AuthViewModel
    @StateObject var benevoleModel = BenevoleViewModel()
    
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var association: String = ""
    @State private var taille_tshirt: String = ""
    @State private var vegetarien: Bool = false
    @State private var mail: String = ""
    @State private var num_telephone: String = ""
    @State private var hebergement: String = ""
    @State private var adresse: String = ""
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationView { // Assurez-vous que NavigationView enveloppe tout le contenu
            VStack {
                if let benevole = benevoleModel.benevole {
                    Text("Bienvenue, \(benevole.pseudo)")
                        .font(.headline)
                    
                    Form {
                        HStack {
                            Text("Nom:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $nom)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Prénom:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $prenom)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Association:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $association)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Végétarien:")
                                .frame(width: 100, alignment: .leading)
                            Text(vegetarien ? "Oui" : "Non")
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Taille de tee-shirt:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $taille_tshirt)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("E-mail:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $mail)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Numéro de téléphone:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $num_telephone)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Hébergement:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $hebergement)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Adresse:")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $adresse)
                                .disabled(!isEditing)
                        }
                    }
                } else if benevoleModel.isLoading {
                    ProgressView()
                } else {
                    Text("Impossible de charger les données du bénévole.")
                }
                
                if let errorMessage = benevoleModel.errorMessage {
                                    Text("Erreur : \(errorMessage)")
                                        .foregroundColor(.red)
                                }
                                
                                if let successMessage = benevoleModel.successMessage {
                                    Text(successMessage)
                                        .foregroundColor(.blue)
                                }
                
                Button("Déconnexion", action: authModel.logout)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .onAppear {
                let pseudo = authModel.username
                benevoleModel.fetchBenevole(pseudo: pseudo)
            }
            .onReceive(benevoleModel.$benevole) { benevole in
                updateFields(with: benevole)
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                if isEditing {
                                    Button("Enregistrer") {
                                        let update = BenevoleUpdate(
                                            nom: nom,
                                            prenom: prenom,
                                            association: association,
                                            taille_tshirt: taille_tshirt,
                                            vegetarien: vegetarien,
                                            mail: mail,
                                            num_telephone: num_telephone,
                                            hebergement: hebergement,
                                            adresse: adresse
                                        )
                                        if let currentBenevole = benevoleModel.benevole {
                                            benevoleModel.modifyBenevole(benevole: currentBenevole, update: update)
                                        }
                                        isEditing = false
                                    }
                                } else {
                                    Button("Modifier") {
                                        isEditing = true
                                    }
                                }
                            }
                        }
        }
    }
    
    func updateFields(with benevole: Benevole?) {
        guard let loadedBenevole = benevole else { return }
        
        nom = loadedBenevole.nom
        prenom = loadedBenevole.prenom
        association = loadedBenevole.association
        vegetarien = loadedBenevole.vegetarien
        taille_tshirt = loadedBenevole.taille_tshirt
        mail = loadedBenevole.mail
        num_telephone = loadedBenevole.num_telephone
        hebergement = loadedBenevole.hebergement
        adresse = loadedBenevole.adresse ?? ""
    }
    
}
