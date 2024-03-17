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

    var body: some View {
        NavigationView {
            Form {
                TextField("Entrez votre nom", text: $viewModel.benevole.nom)
                  
                TextField("Entrez votre prénom", text: $viewModel.benevole.prenom)
                
                TextField("Voici votre pseudo", text: $viewModel.benevole.pseudo)
                    .disabled(true)
                SecureField("Entrez votre mot de passe", text: $viewModel.benevole.password)
                TextField("Entrez votre mail", text: $viewModel.benevole.mail)
                TextField("Entrez votre association", text: $viewModel.benevole.association)
                
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
                
                TextField("Entrez votre numéro de téléphone (optionnel)", text: $viewModel.benevole.num_telephone)
                TextField("Entrez votre adresse (optionnel)", text: Binding(
                    get: { viewModel.benevole.adresse ?? "" },
                    set: { viewModel.benevole.adresse = $0 }
                ))


                Button("Register") {
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
                .background(Color.blue)
                .cornerRadius(8)
                .disabled(isLoading)

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Inscription")
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
