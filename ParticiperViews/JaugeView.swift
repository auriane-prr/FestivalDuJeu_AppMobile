//
//  JaugeView.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 15/03/2024.
//

import SwiftUI

struct JaugeView: View {
    let capaciteTotale: Int
    let nombreInscrits: Int

    var body: some View {
        let pourcentageRemplissage = capaciteTotale > 0 ? CGFloat(nombreInscrits) / CGFloat(capaciteTotale) * 100 : 0
        
        let fillingColor: Color = {
            if pourcentageRemplissage == 100 {
                return .green
            } else if pourcentageRemplissage > 0 {
                return .yellow
            } else {
                return .red
            }
        }()

        return ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: 20)
            Rectangle()
                .foregroundColor(fillingColor)
                .frame(width: pourcentageRemplissage * (UIScreen.main.bounds.width / CGFloat(capaciteTotale)), height: 20)
            HStack {
                Spacer()
                Text("\(nombreInscrits)/\(capaciteTotale)")
            }
        }
        .contentShape(Rectangle())
    }
}

