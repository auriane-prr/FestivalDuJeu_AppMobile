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
    
    let customColor = UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8)

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isAuthenticated {
                    NavigationBarView()
                        .environmentObject(viewModel) // Passez l'instance de AuthViewModel à HomeView
                } else {
                    ScrollView {
                            VStack {
                                if let image = UIImage(named: "nom_app") {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 500, height: 200)
                                        .padding(.bottom, -80)
                                }

                                if let logo = UIImage(named: "logo_court") {
                                    Image(uiImage: logo)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 150)
                                }
                            }
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            TextField("Pseudo", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 350)
                                .padding()
                            
                            SecureField("Mot de passe", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 350)
                                .padding()
                            
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .foregroundColor(.red)
                            }
                            
                            Button("Je me connecte") {
                                Task {
                                    await viewModel.login(username: username, password: password)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color(customColor))
                            .cornerRadius(8)
                            .padding()
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Si tu n’as pas encore de compte, tu peux en créer un ici ")
                                    .foregroundColor(Color(customColor))
                                    .padding()
                                    .frame(width: 400)
                            }
                        }
                    .onAppear {
                        self.username = ""
                        self.password = ""
                    }
                    .onDisappear {
                        self.username = ""
                        self.password = ""
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
