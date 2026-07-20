//
//  Habit.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

@Observable
final class Habit: Identifiable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var isCompleted: Bool
    var isFavorite: Bool
    
    init(id: UUID = UUID(), name: String, category: HabitCategory, isCompleted: Bool = false, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.category = category
        self.isCompleted = isCompleted
        self.isFavorite = isFavorite
    }
}
