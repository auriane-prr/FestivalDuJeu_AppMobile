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
    @State private var isAuthenticated: Bool = false

    var body: some View {
        if isAuthenticated {
                    HomeView()
                        .environmentObject(viewModel) // Passez l'instance de AuthViewModel à HomeView
                } else {
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
                            if viewModel.isAuthenticated {
                                isAuthenticated = true
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
        }
    }
}
