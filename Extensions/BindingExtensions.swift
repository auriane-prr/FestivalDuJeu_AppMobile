//
//  BindingExtensions.swift
//  FestivalDuJeu
//
//  Created by Auriane POIRIER on 24/03/2024.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

