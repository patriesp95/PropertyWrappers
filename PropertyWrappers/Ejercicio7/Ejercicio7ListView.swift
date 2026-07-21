//
//  Ejercicio7ListView.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 19/07/2026.
//

import SwiftUI

struct Ejercicio7ListView: View {
    @Environment(HabitStore.self) private var store
    @State private var isShowingCreationView = false
    @State private var isDelectionTriggered = false
    
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
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive) {
                        if let index = store.habits.firstIndex(where: { $0.id == habit.id }) {
                            isDelectionTriggered = true
                            store.deleteHabits(at: IndexSet(integer: index))
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                })
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            Ejercicio7StatisticsView()
                        } label: {
                            Image(systemName: "chart.bar")
                        }

                    }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreationView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreationView) {
                Ejercicio7CreationView(
                    onSave: { habit in
                        store.habits.append(habit)
                        isShowingCreationView = false
                    }
                )
            }
            .navigationLinkIndicatorVisibility(.hidden)
            .overlay(alignment: .top) {
                if isDelectionTriggered {
                    Text("Habit Deleted Successfully")
                        .padding()
                        .background(.red)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top).combined(
                                    with: .opacity
                                ),
                                removal: .move(edge: .leading).combined(
                                    with: .opacity
                                )
                            )
                        )
                }

            }
            .animation(.easeInOut(duration: 0.3), value: isDelectionTriggered)
            .onChange(of: isDelectionTriggered) { _, newValue in
                if newValue {
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        isDelectionTriggered = false
                    }

                }
            }
        }
    }
}

#Preview {
    Ejercicio7ListView()
            .environment(HabitStore())
}
