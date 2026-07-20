//
//  Ejercicio7View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

struct Ejercicio7View: View {
    
    @State private var store = HabitStore()
    
    var body: some View {
        Ejercicio7ListView()
            .environment(store)
    }
}

#Preview {
    Ejercicio7View()
}
