//
//  Ejercicio7CreationView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 21/07/2026.
//

import SwiftUI

struct Ejercicio7CreationView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Habit) -> Void
    @State var habit: Habit = .init(
        name: "",
        category: .unasigned
    )
    
    private var cleanName: String {
        habit.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isHabitNameValid: Bool {
        !cleanName.isEmpty
    }
     
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Habit's Creation")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Habit's name", text: $habit.name)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled()

                DropDownMenu(selectedCategory: $habit.category)
                
                HStack(spacing: 10) {
                    Button {
                        let newHabit = Habit(name: habit.name, category: habit.category)
                        onSave(newHabit)
                        dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green.opacity(0.9))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.top, 20)
                    }
                    .disabled(!isHabitNameValid)
                    .opacity(isHabitNameValid ? 1 : 0.5)

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.orange.opacity(0.9))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.top, 20)
                    }

                }

            }
            .padding([.horizontal, .vertical])

            Spacer()

        }
        .padding()
    }
}

#Preview {
    let myHabit = Habit(name: "test", category: .personal)
    Ejercicio7CreationView(onSave: { habit in
        print("Saved habit: \(habit.name)")
    })
}
