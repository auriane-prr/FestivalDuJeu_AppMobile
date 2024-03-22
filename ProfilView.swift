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
    @State private var selectionVegetarienString: String = "Non"

    @State private var isEditing = false
    @State private var showingLogoutAlert = false
    @State private var showSuccessMessage = false
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)
    
    var body: some View {
        NavigationView { // Assurez-vous que NavigationView enveloppe tout le contenu
            VStack {
                if let benevole = benevoleModel.benevole {
                    Text("Bienvenue \(benevole.pseudo) !")
                        .font(.title)
                    
                    if let successMessage = benevoleModel.successMessage {
                                Text(successMessage)
                                    .foregroundColor(.green)
                                    .padding()
                                    .transition(.opacity)
                                    .onAppear {
                                        // Efface successMessage après 5 secondes
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            benevoleModel.successMessage = nil
                                        }
                                    }
                            }
                    
                    Form {
                        HStack {
                            Text("Nom :")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $nom)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Prénom :")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $prenom)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Association :")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $association)
                                .disabled(!isEditing)
                        }
                        Picker("Végétarien : ", selection: $selectionVegetarienString) {
                            Text("Oui").tag("Oui")
                            Text("Non").tag("Non")
                        }
                        .disabled(!isEditing)

                        
                            Picker("Taille de tee-shirt : ", selection: $taille_tshirt) {
                                ForEach(["XS", "S", "M", "L", "XL", "XXL"], id: \.self) { taille_tshirt in
                                    Text(taille_tshirt).tag(taille_tshirt)
                                }
                            }
                            .disabled(!isEditing)
                        
                        HStack {
                            Text("E-mail :")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $mail)
                                .disabled(!isEditing)
                        }
                        HStack {
                            Text("Numéro de téléphone :")
                                .frame(width: 100, alignment: .leading)
                            TextField("", text: $num_telephone)
                                .disabled(!isEditing)
                        }
                            Picker("Hébergement :", selection: $hebergement) {
                                ForEach(["Rien", "Recherche", "Proposition"], id: \.self) { hebergement in
                                    Text(hebergement).tag(hebergement)
                                }
                            }
                            .disabled(!isEditing)
                        
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
                
                Button("Déconnexion") {
                                    if isEditing {
                                        // Si l'utilisateur est en train d'éditer, afficher une alerte au lieu de déconnecter directement
                                        showingLogoutAlert = true
                                    } else {
                                        // Sinon, procéder à la déconnexion
                                        authModel.logout()
                                    }
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(customColor))
                                .cornerRadius(8)
                                .padding(.bottom)
                                .alert(isPresented: $showingLogoutAlert) {
                                    Alert(
                                        title: Text("Modifications non enregistrées"),
                                        message: Text("Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir vous déconnecter ?"),
                                        primaryButton: .destructive(Text("Déconnexion")) {
                                            authModel.logout()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                Spacer()
            }
            .onAppear {
                let pseudo = authModel.username
                benevoleModel.fetchBenevole(pseudo: pseudo)
                selectionVegetarienString = benevoleModel.benevole?.vegetarien ?? false ? "Oui" : "Non"
                
            }

            .onReceive(benevoleModel.$benevole) { benevole in
                updateFields(with: benevole)
                
            }
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
                                            vegetarien: selectionVegetarienString,
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
