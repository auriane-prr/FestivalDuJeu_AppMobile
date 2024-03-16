//
//  DetailStand.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct DetailStandView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @StateObject private var standModel = StandViewModel()
    let stand: Stand
    let selectedHeure : String

    var body: some View {
        VStack {
            Text(stand.nomStand)
                .font(.largeTitle)
            Text(stand.description)
                .padding()
            Button(action: {
            }) {
                Text("Participer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
    }
}



