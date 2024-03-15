//
//  LoginView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isAuthenticated {
                    NavigationBarView()
                        .environmentObject(viewModel) // Passez l'instance de AuthViewModel à HomeView
                } else {
                    // Interface de connexion
                    ScrollView {
                        VStack {
                            TextField("Username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .foregroundColor(.red)
                            }
                            
                            Button("Login") {
                                Task {
                                    await viewModel.login(username: username, password: password)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding()
                            
                            // Ajouter un NavigationLink ici
                            NavigationLink(destination: RegisterView()) {
                                Text("Pas encore inscrit ? Inscrivez-vous ici")
                                    .foregroundColor(.blue)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true) // Pour cacher la barre de navigation si vous ne souhaitez pas l'afficher
        }
    }
}

