//
//  ContentView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 13/07/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Ejercicio7View()
        }
        .ignoresSafeArea(.all, edges: [.leading, .trailing, .bottom])
        .padding(.top, 5)

    }
}

struct Project: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var isFavorite: Bool
}

#Preview {
    ContentView()
}
