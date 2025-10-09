//  ContentView.swift
//  EatXico
//
//  Created by Alan Cervantes on 30/09/25.
//

import SwiftUI

struct InfoUserView: View {
    enum Route: Hashable { case camera }
    @State private var nombre = ""
    @State private var edad = ""
    @State private var alergias = ""
    
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

                VStack(spacing: 20) {
                    ZStack {
                        Image("jalapeño")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 132)
                            .offset(x: 4, y: 0)
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(colorVerde.opacity(0.6), lineWidth: 1)
                    )
                    
                    VStack{
                        Text("Cuéntanos sobre ti")
                        Text("Para personalizar tu experiencia")
                    }
                    
                    VStack{
                        VStack(spacing: 20){
                            HStack{
                                Image(systemName: "person.fill")
                                Text("Nombre")
                            }
                            TextField("Tu nombre", text: $nombre)
                                .padding()
                                .border(Color.gray, width: 1)
                                .padding()
                            
                            HStack{
                                Image(systemName: "person.fill")
                                Text("Edad")
                            }
                            TextField("Tu edad", text: $edad)
                                .keyboardType(.numberPad)
                                .padding()
                                .border(Color.gray, width: 1)
                                .padding()
                            HStack{
                                Image(systemName: "person.fill")
                                Text("Alergias Alimentarias")
                            }
                            TextField("Ej: nuez, camarón, leche", text: $alergias)
                                .padding()
                                .border(Color.gray, width: 1)
                                .padding()

                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .frame(maxWidth: 300)
                    }
                }
                    
                NavigationLink(value: Route.camera){
                    
                }
                .disabled(selectedLanguage == nil)
            }
        }
            .navigationDestination(for: Route.self) { route in
                switch route {
                    case .camera:
                        CameraView()
                }
            }
    }
}


#Preview {
    InfoUserView()
}
