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
        Gauge(value: Double(nombreInscrits), in: 0...Double(capaciteTotale)) {
        } currentValueLabel: {
            Text("\(nombreInscrits)/\(capaciteTotale)")
        }
    }
    
    private func couleurDeRemplissage() -> Color {
        let pourcentageRemplissage = Double(nombreInscrits) / Double(capaciteTotale)
        switch pourcentageRemplissage {
        case 0..<0.5:
            return .red
        case 0.5..<1.0:
            return .yellow
        default:
            return .green
        }
    }
}
