//
//  RegisterViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var benevole = Benevole(admin: false, referent: false, nom: "", prenom: "", pseudo: "", password: "", association: "", taille_tshirt: "", vegetarien: false, mail: "", hebergement: "", adresse: nil, num_telephone: nil)
    
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil

    func register() async {
        // Validation des champs
        guard validateFields() else { return }

        guard let url = URL(string: "https://festivaldujeuback.onrender.com/benevole/signup") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL incorrecte."
            }
            return
        }

        guard let finalBody = try? JSONEncoder().encode(benevole) else {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur de formatage des données."
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Échec de l'inscription. Veuillez réessayer."
                }
                return
            }

            DispatchQueue.main.async {
                self.successMessage = "Inscription réussie. Veuillez vous connecter."
                // Vous pouvez choisir de réinitialiser les champs ici
                self.benevole = Benevole(admin: false, referent: false, nom: "", prenom: "", pseudo: "", password: "", association: "", taille_tshirt: "", vegetarien: false, mail: "", hebergement: "", adresse: nil, num_telephone: nil)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur lors de l'inscription: \(error.localizedDescription)"
            }
        }
    }

    private func validateFields() -> Bool {
        // Implémentez la validation des champs ici
        // Retournez false et définissez errorMessage si une validation échoue
        // Exemple simple:
        if benevole.nom.isEmpty || benevole.prenom.isEmpty || benevole.pseudo.isEmpty || benevole.password.isEmpty || benevole.mail.isEmpty {
            errorMessage = "Veuillez remplir tous les champs obligatoires."
            return false
        }
        return true
    }
}


