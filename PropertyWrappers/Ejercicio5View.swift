//
//  Ejercicio5View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 15/07/2026.
//

import SwiftUI

struct Ejercicio5View: View {

    @State private var tasks: [MyTask3] = []
    @State private var tempTask: MyTask3?
    @State private var showingSheet: Bool = false
    @State private var showSuccessMessage: Bool = false
    
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false
    @State private var isCreating: Bool = false
    
    @State private var sheetMode: TaskSheetMode?
    
    private var tasksNotFound: Bool {
        tasks.isEmpty
    }
    
    private var tempTaskNotFound: Bool {
        tempTask == nil
    }
    
    private var taskPerformance: String {
        var taskPerformanceMessage: String = ""
        if isEditing {
            taskPerformanceMessage = "Task updated successfully"
        } else if isCreating {
            taskPerformanceMessage =  "Task added successfully"
        } else if isDeleting {
            taskPerformanceMessage = "Task deleted successfully"
        }
        return taskPerformanceMessage
    }
    
    private var taskPerformanceButtonColor: Color {
        var taskPerformanceButtonColor: Color = .clear
        if isEditing {
            taskPerformanceButtonColor = .blue.opacity(0.9)
        } else if isCreating {
            taskPerformanceButtonColor = .green.opacity(0.9)
        } else if isDeleting {
            taskPerformanceButtonColor = .red.opacity(0.9)
        }
        return taskPerformanceButtonColor
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
                    sheetMode = .create
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                .padding(.trailing, 10)
            }
            .padding(.horizontal)

            if !tasksNotFound {
                List {
                    ForEach(tasks) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.name)
                                    .padding()
                            }
                            
                            if task.priority {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            sheetMode = .edit(task)
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
        .sheet(item: $sheetMode) { mode in
            switch mode {
            case .create:
                Ejercicio5ViewSheet(
                    onDelete: { task in
                        isDeleting = false
                        tasks.removeAll { $0.id == task.id }
                    },
                    onSave: { task in
                        if let index = tasks.firstIndex(where: { $0.id == task.id })
                        {
                            isEditing = false
                            tasks[index] = task
                        } else {
                            isCreating = true
                            tasks.append(task)
                        }
                    },
                    messageIsShown: $showSuccessMessage,
                    tempTask: nil
                )
            case .edit(let task):
                Ejercicio5ViewSheet(
                    onDelete: { task in
                        isDeleting = true
                        tasks.removeAll { $0.id == task.id }
                    },
                    onSave: { task in
                        if let index = tasks.firstIndex(where: { $0.id == task.id })
                        {
                            isEditing = true
                            tasks[index] = task
                        } else {
                            tasks.append(task)
                            isCreating = false
                        }
                    },
                    messageIsShown: $showSuccessMessage,
                    tempTask: task
                )
            }
        }
        .overlay(alignment: .top) {
            if showSuccessMessage {
                Text(taskPerformance)
                    .padding()
                    .background(taskPerformanceButtonColor)
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
        .animation(.easeInOut(duration: 1.2), value: showSuccessMessage)
        .onChange(of: showSuccessMessage) { _, newValue in
            if newValue {
                Task {
                    try? await Task.sleep(for: .seconds(0.5))
                    isEditing = false
                    isDeleting = false
                    isCreating = false
                    showSuccessMessage = false
                }
                
            }
        }
        
    }
}

struct Ejercicio5ViewSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onDelete: (MyTask3) -> Void
    let onSave: (MyTask3) -> Void
    
    @Binding var messageIsShown: Bool
    let tempTask: MyTask3?
    
    @State var title: String = ""
    @State var priority: Bool = false
    
    private var cleanTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isTaskNameValid: Bool {
        !cleanTitle.isEmpty
    }
    
    var isUserEditingATask: Bool {
        tempTask != nil
    }
    
    var buttonOpacity: Double {
        if isTaskNameValid {
            return 1
        } else {
            return 0.5
        }
    }
    
    var buttonDisability: Bool {        
        if isTaskNameValid {
            return false
        } else {
            return true
        }
    }
    
    var buttonNaming: String {
        if isUserEditingATask {
            return "Edit your task"
        } else {
            return "Add a task"
        }
    }
    
    var saveButtonNaming: String {
        if isUserEditingATask {
            return "Save Changes"
        } else {
            return "Save"
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text(buttonNaming)
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
                
                Button {
                    if !isUserEditingATask {
                        onSave(MyTask3(name: cleanTitle, priority: priority))
                    } else {
                        if isTaskNameValid {
                            guard var tempTask else { return }
                            tempTask.name = cleanTitle
                            tempTask.priority = priority
                            onSave(tempTask)
                        }
                    }
                    
                    messageIsShown = true
                    dismiss()
                    
                } label: {
                    Text(saveButtonNaming)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green.opacity(0.9))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                }
                .disabled(buttonDisability)
                .opacity(buttonOpacity)
                
                Button {
                    messageIsShown = false
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
                
                if isUserEditingATask {
                    Button {
                        messageIsShown = true
                        guard let tempTask else { return }
                        onDelete(tempTask)
                        dismiss()
                    } label: {
                        Text("Delete")
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
            .padding([.horizontal, .vertical])
            
            Spacer()
            
        }
        .onAppear {
            title = tempTask?.name ?? ""
            priority = tempTask?.priority ?? false
        }
        
    }
    
}

struct MyTask3: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var priority: Bool
}

enum TaskSheetMode: Identifiable, Equatable {
    case create
    case edit(MyTask3?)
    
    var id: String {
        switch self {
        case .create:
            "create"
            
        case .edit(let task):
            task?.id.uuidString ?? ""
        }
    }
}

#Preview {
    Ejercicio5View()
}
