//
//  RegisterViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 13/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var benevole = Benevole(_id: "", admin: false, referent: false, nom: "", prenom: "", password: "", pseudo: "", association: "", taille_tshirt: "", vegetarien: false, mail: "", hebergement: "", num_telephone: "", adresse: "")
    
    @Published var errorMessage: String = ""
    @Published var successMessage: String? = ""
    
    func register(completion: @escaping (Bool, String) -> Void) async {
        
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
               let (_, response) = try await URLSession.shared.data(for: request)
               guard let httpResponse = response as? HTTPURLResponse else {
                   DispatchQueue.main.async {
                       completion(false, "Réponse invalide du serveur.")
                   }
                   return
               }

               if httpResponse.statusCode == 201 {
                   DispatchQueue.main.async {
                       completion(true, "Inscription réussie. Veuillez vous connecter.")
                   }
               } else if httpResponse.statusCode == 409 {
                   // Gérer le cas où le pseudo existe déjà
                   DispatchQueue.main.async {
                       completion(false, "Cet utilisateur existe déjà.")
                   }
               } else {
                   DispatchQueue.main.async {
                       completion(false, "Échec de l'inscription. Veuillez réessayer.")
                   }
               }
           } catch {
               DispatchQueue.main.async {
                   completion(false, "Erreur lors de l'inscription: \(error.localizedDescription)")
               }
           }
       }
    
    func isFormValid() -> Bool {
        return !benevole.nom.isEmpty && !benevole.prenom.isEmpty &&
            !benevole.password.isEmpty && !benevole.pseudo.isEmpty &&
            !benevole.mail.isEmpty && !benevole.association.isEmpty &&
            !benevole.hebergement.isEmpty
    }
}
