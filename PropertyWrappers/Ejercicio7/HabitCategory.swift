//
//  HabitCategory.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//


enum HabitCategory: String, CaseIterable, Identifiable {
    case health
    case study
    case personal
    case unasigned
    var id: Self { self }
}
