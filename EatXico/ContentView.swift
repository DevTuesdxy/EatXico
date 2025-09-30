//
//  ContentView.swift
//  EatXico
//
//  Created by Alan Cervantes on 30/09/25.
//

import SwiftUI

struct ContentView: View {
    let colorVerde = Color(red: 56/255, green: 142/255, blue: 84/255)
    let colorIdioma = Color(red: 56/255, green: 142/255, blue: 60/255)
    let colorContorno = Color(red: 230/255, green: 238/255, blue: 30/255)
    let colorDesc = Color(red: 97/255, green: 97/255, blue: 97/255)
    
    @State private var selectedLanguage: String? = nil

    var body: some View {
        ZStack {
            // Clean white base with a subtle fresh blue/green gradient overlay
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

                // Logo de la app
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 110, height: 110)
                            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.tint)
                            .foregroundStyle(colorVerde)
                    }
                    Text("EatXico")
                        .font(.title3)
                        .foregroundStyle(colorVerde)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)
                
                    Text("Descubre la gastronomia Mexicana")
                        .font(.system(size: 16))
                        .foregroundStyle(colorDesc)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }

                // Language buttons
                VStack(spacing: 14) {
                    // Español
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

                    // English
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
                
                // Start button at the bottom
                Button(action: {
                    // TODO: Handle start flow with selectedLanguage
                    // e.g., save selection and navigate forward
                }) {
                    Text(selectedLanguage == nil ? "Selecciona un idioma" : "Comenzar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
                .background(
                    Capsule()
                        .fill(colorVerde)
                )
                .foregroundStyle(.white)
                .opacity(selectedLanguage == nil ? 0.5 : 1)
                .shadow(color: Color.green.opacity(0.3), radius: 12, x: 0, y: 6)
                .disabled(selectedLanguage == nil)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}

