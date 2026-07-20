//
//  HabitStore.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

@Observable
final class HabitStore {
    var habits: [Habit] = [
        Habit(name: "Walk 30 minutes", category: .health, isFavorite: true),
        Habit(name: "Study Swift", category: .study),
        Habit(name: "Read 20 pages", category: .personal, isFavorite: true)
    ]
    
    var completedHabits: [Habit] {
        habits.filter { $0.isCompleted }
    }
    
    var favoriteHabits: [Habit] {
        habits.filter { $0.isFavorite }
    }
    
    var completedCount: Int {
        completedHabits.count
    }
    
    var pendingCount: Int {
        habits.count - completedCount
    }
}
