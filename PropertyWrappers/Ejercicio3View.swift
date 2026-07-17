//
//  Ejercicio3View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 14/07/2026.
//

import SwiftUI

struct Ejercicio3View: View {
    @State private var searchWord = ""
    
    private let names = ["Patricia", "Pedro", "Pablo", "Paula", "Pepe", "Penelope", "Parsifloro", "Persefone", "Paloma", "Pilar"]
    
    private var normalizedSearchWord: String {
        searchWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var filteredNames: [String] {
        if normalizedSearchWord.isEmpty {
            return names
        } else {
            return names.filter { $0.localizedCaseInsensitiveContains(normalizedSearchWord)}
        }
    }
    
    private var hasResults: Bool {
        !normalizedSearchWord.isEmpty && !filteredNames.isEmpty
    }
    
    private var hasNoResults: Bool {
        filteredNames.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                if hasResults {
                    Text("Hay resultados")
                        .padding()
                        .background(.green.opacity(0.9))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                } else if hasNoResults {
                    Text("No hay resultados")
                        .padding()
                        .background(.red.opacity(0.9))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                }
            }
            
            HStack {
                TextField(text: $searchWord) {
                    Text("Busca la palabra")
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                
                if !searchWord.isEmpty {
                    Button {
                        searchWord = ""
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.gray)
                    }

                } else {
                    Image(systemName: "magnifyingglass.circle")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            }
            .padding([.horizontal, .vertical])
            
            VStack {
                if !hasNoResults {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(filteredNames, id: \.self) { name in
                                Text(name)
                                    .padding()
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .vertical, .top])
            .padding(.bottom, 20)
            
            Spacer()
            
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6).opacity(0.6))
        )
        .ignoresSafeArea(.all, edges: [.bottom, .leading, .trailing])
    }
}

#Preview {
    Ejercicio3View()
}
