//
//  Ejercicio7ListView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

struct Ejercicio7ListView: View {
    @Environment(HabitStore.self) private var store
    
    var body: some View {
        NavigationStack {
            List(store.habits) { habit in
                NavigationLink {
                    Ejercicio7DetailView(habit: habit)
                } label: {
                    VStack{
                        HStack(spacing: 15){
                            @Bindable var habit = habit
                            Toggle(isOn: $habit.isCompleted) {
                                EmptyView()
                            }
                            .toggleStyle(.switch)
                            
                            VStack(alignment: .leading){
                                Text(habit.name)
                                    .font(.title3)
                                    .foregroundStyle(.primary)
                                
                                Text(habit.category.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if habit.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.vertical, 15)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "plus")
                }
            }
            .navigationLinkIndicatorVisibility(.hidden)
        }
    }
}

#Preview {
    Ejercicio7ListView()
            .environment(HabitStore())
}
