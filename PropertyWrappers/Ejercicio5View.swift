//
//  Ejercicio5View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 15/07/2026.
//

import SwiftUI

struct Ejercicio5View: View {

    @State private var tasks: [MyTask3] = [
        MyTask3(name: "Go Shopping", priority: false),
        MyTask3(name: "Go to the grocery store", priority: true),
    ]

    @State private var tempTask: MyTask3?

    @State private var showingSheet: Bool = false
    @State private var showSuccessMessage: Bool = false
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false

    private var tasksNotFound: Bool {
        tasks.isEmpty
    }

    private var tempTaskNotFound: Bool {
        tempTask == nil
    }
    
    private var userPerformance: String {
        if isEditing {
            if isDeleting {
                "Task deleted successfully"
            } else {
               "Task updated successfully"
            }
        } else {
            "Task added successfully"
        }
    }
    
    private var userPerformanceButtonColor: Color {
        if isEditing {
            if isDeleting {
                .red.opacity(0.9)
            } else {
                .blue.opacity(0.9)
            }
        } else {
            .green.opacity(0.9)
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
                    isEditing = false
                    isDeleting = false
                    tempTask = nil
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                .padding(.trailing, 10)

            }

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
                            tempTask = task
                            showingSheet = true
                        }
                    }
                }

            }

        }
        .sheet(isPresented: $showingSheet) {
            Ejercicio5ViewSheet(
                onDelete: { task in
                    tasks.removeAll { $0.id == task.id }
                    print(tasks)
                },
                onSave: { task in
                    if let index = tasks.firstIndex(where: { $0.id == task.id })
                    {
                        tasks[index] = task
                    } else {
                        tasks.append(task)
                    }
                },
                messageIsShown: $showSuccessMessage,
                userIsEditing: $isEditing,
                userIsDeleting: $isDeleting,
                tempTask: $tempTask
            )
            .onAppear {
                if !tempTaskNotFound {
                    isEditing = true
                }
            }
        }
        .overlay(alignment: .top) {
            if showSuccessMessage {
                Text(userPerformance)
                .padding()
                .background(userPerformanceButtonColor)
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
    @Binding var userIsEditing: Bool
    @Binding var userIsDeleting: Bool
    @Binding var tempTask: MyTask3?

    @State var title: String = ""
    @State var priority: Bool = false

    var isTempTaskNameValid: Bool {
        !title.isEmpty
    }

    var isNewTaskTitleValid: Bool {
        let newTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return !newTitle.isEmpty

    }

    var isUserEditingATask: Bool {
        tempTask != nil
    }

    var buttonOpacity: Double {
        isUserEditingATask && !isTempTaskNameValid
            || !isUserEditingATask && !isNewTaskTitleValid ? 0.5 : 1
    }

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text(isUserEditingATask ? "Edit your task" : "Add a task")
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
                    let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !isUserEditingATask {
                        onSave(MyTask3(name: cleanTitle, priority: priority))
                    } else {
                        if isTempTaskNameValid {
                            guard let _tempTask = Binding($tempTask) else {
                                return
                            }
                            _tempTask.wrappedValue.name = cleanTitle
                            _tempTask.wrappedValue.priority = priority
                            onSave(_tempTask.wrappedValue)
                        }
                    }

                    messageIsShown = true
                    dismiss()

                } label: {
                    Text(isUserEditingATask ? "Save Changes" : "Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green.opacity(0.9))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                }
                .disabled(
                    isUserEditingATask
                        ? !isTempTaskNameValid : !isNewTaskTitleValid
                )
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
                        userIsDeleting = true
                        messageIsShown = true
                        guard let _tempTask = Binding($tempTask) else { return }
                        onDelete(_tempTask.wrappedValue)
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

#Preview {
    Ejercicio5View()
}

