//
//  RegisterView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isLoading = false
    @State private var isGeneratingPseudo = false
    
    @State private var oldNom = ""
    @State private var oldPrenom = ""
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)

    var body: some View {
        NavigationView {
            Form {
                Section(header : Text("Informations obligatoires :")) {
                    Text("Merci de vous joindre à nous pour cette nouvelle édition du Festival du Jeu à Montpellier !")
                    TextField("Votre nom", text: $viewModel.benevole.nom)
                    
                    TextField("Votre prénom", text: $viewModel.benevole.prenom)
                    
                    TextField("Votre pseudo", text: $viewModel.benevole.pseudo)
                    SecureField("Votre mot de passe", text: $viewModel.benevole.password)
                    TextField("Votre mail", text: $viewModel.benevole.mail)
                    TextField("Votre association", text: $viewModel.benevole.association)
                    
                    Picker("Êtes-vous végétarien ?", selection: $viewModel.benevole.vegetarien) {
                        Text("Oui").tag(true)
                        Text("Non").tag(false)
                    }
                    
                    Picker("Sélectionnez une taille", selection: $viewModel.benevole.taille_tshirt) {
                        ForEach(["XS", "S", "M", "L", "XL", "XXL"], id: \.self) { taille_tshirt in
                            Text(taille_tshirt).tag(taille_tshirt)
                        }
                    }
                    
                    Picker("Sélectionnez une option d'hébergement", selection: $viewModel.benevole.hebergement) {
                        ForEach(["Rien", "Recherche", "Proposition"], id: \.self) { hebergement in
                            Text(hebergement).tag(hebergement)
                        }
                    }
                }
                Section(header : Text("Informations falcultatives :")) {
                    TextField("Votre numéro de téléphone (optionnel)", text: $viewModel.benevole.num_telephone)
                    TextField("Votre adresse (optionnel)", text: Binding(
                        get: { viewModel.benevole.adresse ?? "" },
                        set: { viewModel.benevole.adresse = $0 }
                    ))
                }

                HStack(spacing: 0) {
                    Spacer()
                    Button("Je m'inscris") {
                        if viewModel.isFormValid() {
                            isLoading = true
                            Task {
                                await viewModel.register()
                                isLoading = false
                            }
                        } else {
                            viewModel.errorMessage = "Veuillez remplir tous les champs requis."
                        }
                    }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color(customColor))
                        .cornerRadius(8)
                        .disabled(isLoading)
                    Spacer()
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Inscription")
                    
                    .overlay(
                        Image("logo_court")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .offset(x: 180, y: -80) // Ajustez l'offset selon vos besoins
                    , alignment: .topLeading
                    )
            .onAppear {
                if viewModel.benevole.hebergement.isEmpty {
                    viewModel.benevole.hebergement = "Rien"
                }
                if viewModel.benevole.taille_tshirt.isEmpty {
                    viewModel.benevole.taille_tshirt = "XS"
                }
            }
        }
    }
    private func generatePseudo() {
            viewModel.generatePseudoIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isGeneratingPseudo = false
            }
        }
}
