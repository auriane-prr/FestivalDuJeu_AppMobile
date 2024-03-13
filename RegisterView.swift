//
//  RegisterView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var pseudo: String = ""
    @State private var password: String = ""
    @State private var mail: String = ""
    @State private var association: String = ""
    @State private var vegetarien: String = "Oui"
        let options_vege = ["Oui", "Non"]
    @State private var taille_tshirt: String = "XS"
        let options_taille = ["XS", "S", "M", "L", "XL", "XXL"]
    @State private var num_telephone: String = ""
    @State private var hebergement: String = "Rien"
        let options_heber = ["Rien", "Recherche", "Proposition"]
    @State private var adresse: String = ""

    var body: some View {
        NavigationView {
            Form {
                        TextField("Entrez votre nom", text: $nom)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                        TextField("Entrez votre prénom", text: $prenom)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
               
                        TextField("Voici votre pseudo", text: $pseudo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                            .disabled(true)
                        TextField("Entrez votre mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                 
                        TextField("Entrez votre mail", text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                        TextField("Entrez votre association", text: $association)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
       
                        Picker("Sélectionnez une option", selection: $vegetarien) {
                            ForEach(options_vege, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        Picker("Sélectionnez une option", selection: $taille_tshirt) {
                            ForEach(options_taille, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
          
                        TextField("Entrez votre numéro de téléphone", text: $num_telephone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                        Picker("Sélectionnez une option", selection: $hebergement) {
                            ForEach(options_heber, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
            
                        TextField("Entrez votre adresse", text: $adresse)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
              
                Button("Register") {
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()
            }
            .navigationTitle("Inscription") // Ajouter un titre à la page d'inscription
        }
    }
}
