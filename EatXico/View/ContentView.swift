//
//  ContentView.swift
//  EatXico
//
//  Created by Alan Cervantes on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    enum Route: Hashable { case infoUser }
    
    let colorVerde = Color(red: 56/255, green: 142/255, blue: 84/255)
    let colorIdioma = Color(red: 56/255, green: 142/255, blue: 60/255)
    let colorContorno = Color(red: 230/255, green: 238/255, blue: 30/255)
    let colorDesc = Color(red: 97/255, green: 97/255, blue: 97/255)

    @State private var selectedLanguage: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.15),
                        Color.green.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer(minLength: 0)

                    VStack(spacing: 12) {
                        ZStack {
                            Image("jalapeño")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 132)
                                .offset(x: 4, y: 0) // mueve la imagen dentro del circulo
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(colorVerde.opacity(0.6), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        
                        Text("FoodLens")
                   
                            .font(.title3)
                            .foregroundStyle(colorVerde)
                            .fontWeight(.semibold)
                            .accessibilityAddTraits(.isHeader)
                    
                        Text("Descubre la gastronomia Mexicana")
                            .font(.system(size: 16))
                            .foregroundStyle(colorDesc)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                    }

                    VStack(spacing: 14) {
                        Button(action: { selectedLanguage = "Español" }) {
                            HStack {
                                Text("Español")
                                    .font(.headline)
                                Spacer()
                                if selectedLanguage == "Español" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .contentShape(Capsule())
                            .foregroundStyle(selectedLanguage == "Español" ? colorIdioma : .primary)
                        }
                        .buttonStyle(.plain)
                        .background(
                            Capsule()
                                .fill(selectedLanguage == "Español" ? colorContorno.opacity(0.18) : Color.white.opacity(0.9))
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedLanguage == "Español" ? colorIdioma.opacity(0.5) : Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .foregroundStyle(.primary)
                        .shadow(color: .black.opacity(selectedLanguage == "Español" ? 0.10 : 0.06), radius: selectedLanguage == "Español" ? 12 : 8, x: 0, y: 6)
                        .padding(.horizontal, 6)
                        .accessibilityLabel(Text("Idioma Español"))
                        .accessibilityAddTraits(selectedLanguage == "Español" ? .isSelected : [])

                        Button(action: { selectedLanguage = "English" }) {
                            HStack {
                                Text("English")
                                    .font(.headline)
                                Spacer()
                                if selectedLanguage == "English" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .contentShape(Capsule())
                            .foregroundStyle(selectedLanguage == "English" ? colorIdioma : .primary)
                        }
                        .buttonStyle(.plain)
                        .background(
                            Capsule()
                                .fill(selectedLanguage == "English" ? colorContorno.opacity(0.18) : Color.white.opacity(0.9))
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedLanguage == "English" ? colorIdioma.opacity(0.5) : Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .foregroundStyle(.primary)
                        .shadow(color: .black.opacity(selectedLanguage == "English" ? 0.10 : 0.06), radius: selectedLanguage == "English" ? 12 : 8, x: 0, y: 6)
                        .padding(.horizontal, 6)
                        .accessibilityLabel(Text("Idioma English"))
                        .accessibilityAddTraits(selectedLanguage == "English" ? .isSelected : [])

                        // Français
                        Button(action: { selectedLanguage = "Français" }) {
                            HStack {
                                Text("Français")
                                    .font(.headline)
                                Spacer()
                                if selectedLanguage == "Français" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .contentShape(Capsule())
                            .foregroundStyle(selectedLanguage == "Français" ? colorIdioma : .primary)
                        }
                        .buttonStyle(.plain)
                        .background(
                            Capsule()
                                .fill(selectedLanguage == "Français" ? colorContorno.opacity(0.18) : Color.white.opacity(0.9))
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedLanguage == "Français" ? colorIdioma.opacity(0.5) : Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .foregroundStyle(.primary)
                        .shadow(color: .black.opacity(selectedLanguage == "Français" ? 0.10 : 0.06), radius: selectedLanguage == "Français" ? 12 : 8, x: 0, y: 6)
                        .padding(.horizontal, 6)
                        .accessibilityLabel(Text("Idioma Français"))
                        .accessibilityAddTraits(selectedLanguage == "Français" ? .isSelected : [])
                    }
                    .padding(.horizontal)

                    Spacer()
                    
                    NavigationLink(value: Route.infoUser){
                        Text(selectedLanguage == nil ? "Selecciona un idioma" : "Comenzar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Capsule().fill(colorVerde))
                            .foregroundStyle(.white)
                            .opacity(selectedLanguage == nil ? 0.5 : 1)
                            .shadow(color: Color.green.opacity(0.3), radius: 12, x:0, y:6)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    .disabled(selectedLanguage == nil)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .infoUser:
                    InfoUserView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
