//
//  Ejericico1View.swift
//  PropertyWrappers
//
//  Created by Patricia M Espert on 13/07/2026.
//

import SwiftUI

struct Ejericico1View: View {

    @State private var name = ""
    @State private var email = ""
    @State private var acceptTerms = false
    @State private var subscribeNewsletter = false
    @State private var showSuccessMessage = false
    
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }

    var isFormValid: Bool {
       !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
       acceptTerms &&
       isValidEmail
    }


    var body: some View {
        VStack(spacing: 20) {
            TextField("Nombre", text: $name)
                .keyboardType(.default)
                .textContentType(.name)
                .border(.black)
            TextField("Correo", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .border(.black)
            Toggle(isOn: $acceptTerms) {
                Text("Acepto los términos y condiciones")
            }
            .toggleStyle(.switch)

            Toggle(isOn: $subscribeNewsletter) {
                Text("Suscribirme al boletín")
            }
            .toggleStyle(.switch)

//            Button("Aceptar") {
//                showSuccessMessage = true
//                
//                name = ""
//                email = ""
//                acceptTerms = false
//                subscribeNewsletter = false
//                
//                Task {
//                    try? await Task.sleep(for: .seconds(2))
//                    showSuccessMessage = false
//                }
//            }
//            .disabled(!isFormValid)
        }
        .padding(.horizontal)
        .overlay(alignment: .top) {
            if showSuccessMessage {
                Text("Los datos se han enviado correctamente")
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
        .animation(.easeInOut(duration: 0.5), value: showSuccessMessage)
    }
}

#Preview {
    Ejericico1View()
}
