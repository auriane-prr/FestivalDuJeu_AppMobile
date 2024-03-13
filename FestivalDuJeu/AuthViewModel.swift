//
//  LoginViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    func login() {
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/login") else { return }

        let body: [String: Any] = ["username": username, "password": password]
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Traiter la réponse ici, par exemple enregistrer le token d'authentification
                } else {
                    // Gérer l'erreur
                }
            }.resume()
    }
}

