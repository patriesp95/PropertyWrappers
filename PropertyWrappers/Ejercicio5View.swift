//
//  Ejercicio5View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 15/07/2026.
//

import SwiftUI

struct Ejercicio5View: View {

    @State private var tasks: [MyTask3] = []
    @State private var sheetMode: TaskSheetMode?
    @State private var lastAction: TaskAction?

    private var isTaskListEmpty: Bool {
        tasks.isEmpty
    }

    private var taskPerformance: String {
        switch lastAction {
        case .created:
            "Task added successfully"
        case .updated:
            "Task updated successfully"
        case .deleted:
            "Task deleted successfully"
        case nil:
            ""
        }
    }

    private var taskPerformanceButtonColor: Color {
        switch lastAction {
        case .created:
            .green.opacity(0.9)
        case .updated:
            .blue.opacity(0.9)
        case .deleted:
            .red.opacity(0.9)
        case nil:
            .clear
        }
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

            if !isTaskListEmpty {
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
                        tasks.removeAll { $0.id == task.id }
                    },
                    onSave: { task in
                        if let index = tasks.firstIndex(where: {
                            $0.id == task.id
                        }) {
                            tasks[index] = task
                        } else {
                            lastAction = .created
                            tasks.append(task)
                        }
                    },
                    tempTask: nil
                )
            case .edit(let task):
                Ejercicio5ViewSheet(
                    onDelete: { task in
                        lastAction = .deleted
                        tasks.removeAll { $0.id == task.id }
                    },
                    onSave: { task in
                        if let index = tasks.firstIndex(where: {
                            $0.id == task.id
                        }) {
                            lastAction = .updated
                            tasks[index] = task
                        } else {
                            tasks.append(task)
                        }
                    },
                    tempTask: task
                )
            }
        }
        .overlay(alignment: .top) {
            if lastAction != nil {
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
        .animation(.easeInOut(duration: 0.3), value: lastAction)
        .onChange(of: lastAction) { _, newValue in
            if newValue != nil {
                Task {
                    try? await Task.sleep(for: .seconds(1.5))
                    lastAction = nil
                }

            }
        }

    }
}

struct Ejercicio5ViewSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onDelete: (MyTask3) -> Void
    let onSave: (MyTask3) -> Void

    var tempTask: MyTask3?

    @State private var title: String = ""
    @State private var priority: Bool = false

    private var cleanTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isTaskNameValid: Bool {
        !cleanTitle.isEmpty
    }

    private var isUserEditingATask: Bool {
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
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled()

                Toggle(isOn: $priority) {
                    Text("Priority")
                }
                .toggleStyle(.switch)

                Button {
                    let taskToSave: MyTask3
                    if var tempTask {
                        tempTask.name = cleanTitle
                        tempTask.priority = priority
                        taskToSave = tempTask
                    } else {
                        taskToSave = MyTask3 (
                            name: cleanTitle,
                            priority: priority
                        )
                    }
                    
                    onSave(taskToSave)
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
                        if let tempTask {
                            onDelete(tempTask)
                            dismiss()
                        }
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
    let id: UUID = UUID()
    var name: String
    var priority: Bool
}

enum TaskSheetMode: Identifiable, Equatable {
    case create
    case edit(MyTask3)

    var id: String {
        switch self {
        case .create:
            "create"

        case .edit(let task):
            task.id.uuidString
        }
    }
}

enum TaskAction {
    case created
    case updated
    case deleted
}

#Preview {
    Ejercicio5View()
}
