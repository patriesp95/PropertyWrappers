//
//  Ejercicio2View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 13/07/2026.
//

import SwiftUI

struct Ejercicio2View: View {
    @State private var notificationsAreAllowed =  false
    @State private var newsAllowed =  false
    @State private var promotionsAllowed =  false
    @State private var remidersAllowed =  false
    
    var activeNotifications: Int {
        var count = 0
        if notificationsAreAllowed {
            if newsAllowed {
                count += 1
            }
            if promotionsAllowed {
                count += 1
            }
            if remidersAllowed {
                count += 1
            }
        }
        return count
    }
    
    var body: some View {
        VStack(spacing: 20){
            if activeNotifications >= 1 {
                Text("Tienes activadas \(activeNotifications) notificaciones")
                    .padding()
                    .background(.blue.opacity(0.9))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 20)
            } else {
                Text("No tienes notificaciones")
                    .padding()
                    .background(.blue.opacity(0.9))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 20)
            }
                        
            Toggle(isOn: $notificationsAreAllowed) {
                Text("Permitir notificaciones")
            }
            .toggleStyle(.switch)
            
            Toggle(isOn: $newsAllowed) {
                Text("Novedades")
            }
            .toggleStyle(.switch)
            .disabled(!notificationsAreAllowed)
            
            Toggle(isOn: $promotionsAllowed) {
                Text("Promociones")
            }
            .toggleStyle(.switch)
            .disabled(!notificationsAreAllowed)
            
            Toggle(isOn: $remidersAllowed) {
                Text("Recordatorios")
            }
            .toggleStyle(.switch)
            .disabled(!notificationsAreAllowed)
            
            Spacer()
        }
        .padding([.horizontal, .vertical])
        .onChange(of: notificationsAreAllowed) { oldValue, newValue in
            if !newValue {
                newsAllowed = false
                promotionsAllowed = false
                remidersAllowed = false
            }
        }
    }
}

#Preview {
    Ejercicio2View()
}
