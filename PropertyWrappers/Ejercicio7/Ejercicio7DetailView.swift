//
//  Ejercicio7DetailView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

struct Ejercicio7DetailView: View {
    @Bindable var habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Project Details")
                .font(.title)
                .fontWeight(.bold)
            
            
            TextField("Name of the habit", text: $habit.name)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()

            DropDownMenu(selectedCategory: $habit.category)
            
            Toggle(isOn: $habit.isCompleted) {
                Text("Completed")
            }
            .toggleStyle(.switch)
            
            Toggle(isOn: $habit.isFavorite) {
                Text("Favorited")
            }
            .toggleStyle(.switch)
        }
        .padding([.horizontal, .vertical])

        Spacer()
    }
}

struct DropDownMenu: View {
    var habitCategories: [HabitCategory] = HabitCategory.allCases
    @Binding var selectedCategory: HabitCategory

    var body: some View {
        VStack {
            Picker("Category", selection: $selectedCategory) {
                ForEach(habitCategories, id: \.self) { habitCategory in
                    Text(habitCategory.rawValue)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Bindable var habit: Habit = Habit(name: "Walk 30 minutes", category: .health, isFavorite: true)
    Ejercicio7DetailView(habit: habit)
}
