//
//  ParticiperViewModel.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import Foundation

class FestivalViewModel: ObservableObject {
    @Published var selectedDate: Date = Date() {
            willSet {
                print("Date sélectionnée : \(formatDate(date: newValue))")
            }
        }
    @Published var selectableDates: [Date] = []
    @Published var latestFestival: Festival?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadLatestFestival() {
        guard let url = URL(string: "https://festivaldujeuback.onrender.com/festival/latest") else {
            DispatchQueue.main.async {
                self.errorMessage = "L'URL du festival est invalide."
            }
            return
        }

        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Échec du chargement : \(error.localizedDescription)"
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                    self?.errorMessage = "Réponse invalide du serveur."
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let festival = try decoder.decode(Festival.self, from: data)
                    self?.latestFestival = festival
                    // Après le chargement, définissez les dates sélectionnables et la date sélectionnée par défaut
                    self?.selectableDates = [festival.dateDebut, festival.dateFin]
                    self?.selectedDate = festival.dateDebut
                } catch {
                    self?.errorMessage = "Échec de décodage : \(error.localizedDescription)"
                }
            }
        }
        task.resume()
    }
    
    private func formatDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
