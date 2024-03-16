//
//  ProfilView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct ProfilView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            Text("Vous êtes sur la page profil")
            .navigationTitle("Profil")
        }
    }
}
