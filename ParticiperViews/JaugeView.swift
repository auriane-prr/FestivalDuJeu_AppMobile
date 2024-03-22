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
    
    let customColor = Color(UIColor(red: 29/255, green: 36/255, blue: 75/255, alpha: 0.8))

    var body: some View {
        ProgressView(value: Double(nombreInscrits), total: Double(capaciteTotale))
                        .progressViewStyle(LinearProgressViewStyle(tint: customColor))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
    }
}
