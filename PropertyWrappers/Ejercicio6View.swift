//
//  Ejercicio6View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 18/07/2026.
//

import SwiftUI

@Observable
final class ProjectStore {

    var myProjects: [MyProject1] = []

    var isProjectListEmpty: Bool {
        myProjects.isEmpty
    }
}

struct Ejercicio6View: View {
    @State private var store = ProjectStore()
    @State private var showingSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Projects")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()

                    Spacer()

                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.trailing, 10)

                if !store.isProjectListEmpty {
                    List($store.myProjects) { $myProject in
                        NavigationLink {
                            Ejercicio6ViewDetalle(project: $myProject)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(myProject.name)
                                        .font(.title2)
                                        .foregroundStyle(.primary)

                                    Text(myProject.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if myProject.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }
                            .padding(.vertical, 10)
                        }

                    }
                    .listStyle(.plain)

                } else {
                    VStack {
                        ContentUnavailableView(
                            "No projects",
                            systemImage: "folder",
                            description: Text(
                                "Tap the + button to create your first project."
                            )
                        )
                    }
                }
            }
            .navigationLinkIndicatorVisibility(.hidden)
            
        }
        .sheet(isPresented: $showingSheet) {
            Ejercicio6ViewSheet(
                onSave: { project in
                    store.myProjects.append(project)
                }
            )
        }

    }
}

struct Ejercicio6ViewSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (MyProject1) -> Void

    @State private var name: String = ""
    @State private var description: String = ""

    private var cleanName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var cleanDescription: String {
        description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isProjectNameValid: Bool {
        !cleanName.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add A Project")
                .font(.title)
                .fontWeight(.bold)

            TextField("Name of the project", text: $name)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()

            TextField(
                "Description of the project",
                text: $description,
                axis: .vertical
            )
            .lineLimit(3...6)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.default)
            .textInputAutocapitalization(.sentences)
            .autocorrectionDisabled()

            HStack(spacing: 10) {
                Button {
                    let newProject = MyProject1(
                        name: cleanName,
                        description: cleanDescription,
                        isFavorite: false
                    )
                    onSave(newProject)
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
                .disabled(!isProjectNameValid)
                .opacity(isProjectNameValid ? 1 : 0.5)

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
        .padding()

        Spacer()

    }
}

struct MyProject1: Identifiable {
    let id: UUID = UUID()
    var name: String
    var description: String
    var isFavorite: Bool
}

struct Ejercicio6ViewDetalle: View {

    @Binding var project: MyProject1

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                TextField("Name of the project", text: $project.name)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled()

                TextField(
                    "Description of the project",
                    text: $project.description
                )
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()

                Toggle(isOn: $project.isFavorite) {
                    Text("Mark as favorite")
                }
                .toggleStyle(.switch)
            }
            .padding([.horizontal, .vertical])

            Spacer()

        }
        .padding()
    }
}

#Preview {
    Ejercicio6View()
}
