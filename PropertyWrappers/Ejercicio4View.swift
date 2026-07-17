//
//  Ejercicio4View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 14/07/2026.
//

import SwiftUI

struct Ejercicio4View: View {

    @State private var tasks: [MyTask] = [
        MyTask(name: "Go Shopping", priority: false),
        MyTask(name: "Go to the grocery store", priority: false)
    ]

    @State private var showingSheet: Bool = false
    @State private var showSuccessMessage: Bool = false

    private var tasksNotFound: Bool {
        tasks.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text("Tasks")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Spacer()

                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                .padding(.trailing, 10)
                .sheet(isPresented: $showingSheet) {
                    Ejercicio4ViewSheet(sheetIsShown: $showingSheet, messageIsShown: $showSuccessMessage, tasks: $tasks)
                }

            }

            if !tasksNotFound {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(tasks) { task in
                            HStack {
                                VStack(alignment: .leading ){
                                    Text(task.name)
                                        .padding()
                                    Divider()
                                }
                                
                                if task.priority {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            
        }
        .overlay(alignment: .top) {
            if showSuccessMessage {
                Text("Task added succesfully")
                    .padding()
                    .background(.green.opacity(0.9))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }

        }
        .animation(.easeInOut(duration: 0.15), value: showSuccessMessage)
        .onChange(of: showSuccessMessage) { _, newValue in
            if newValue {
                Task {
                    try? await Task.sleep(for: .seconds(0.5))
                    showSuccessMessage = false
                }
            }
        }

    }
}

struct Ejercicio4ViewSheet: View {
    @Binding var sheetIsShown: Bool
    @Binding var messageIsShown: Bool
    @Binding var tasks: [MyTask]
    @State var title: String = ""
    @State var priority: Bool = false
    
    var isTaskNameValid: Bool {
        !title.isEmpty
    }

    var body: some View {
        VStack {
            VStack(spacing: 20){
                Text("Add a task")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Name of the task", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    .textContentType(.name)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled()
                
                Toggle(isOn: $priority) {
                    Text("Is prioritary")
                }
                .toggleStyle(.switch)
                
            }
            
            HStack(spacing: 20){
                Button {
                    if isTaskNameValid {
                        tasks.append(MyTask(name: title, priority: priority))
                        messageIsShown = true
                        sheetIsShown = false
                        
                    }
                  
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
                .disabled(!isTaskNameValid)
                
                Spacer()
                                
                Button {
                    sheetIsShown = false
                    messageIsShown = false
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red.opacity(0.9))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)

    }
}
        
struct MyTask: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var priority: Bool
}

#Preview {
    Ejercicio4View()
}
