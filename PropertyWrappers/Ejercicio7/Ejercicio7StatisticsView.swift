//
//  Ejercicio7StatisticsView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

struct Ejercicio7StatisticsView: View {
    @Environment(HabitStore.self) private var store
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Habit's Statistics")
                .font(.title)
                .fontWeight(.bold)
            
            if isLoading {
                VStack(spacing: 15) {
                    ProgressView()
                    Text("Loading stats...")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
            } else {
                VStack(alignment: .leading, spacing: 5){
                    Text("Total: \(store.habits.count)")
                    Text("Completados: \(store.completedHabits.count)")
                    Text("Pendientes: \(store.pendingCount)")
                    Text("Favoritos: \(store.favoriteHabits.count)")
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            isLoading = false
        }
    }
}

#Preview {
    Ejercicio7StatisticsView()
        .environment(HabitStore())
}
