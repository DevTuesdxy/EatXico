import SwiftUI

struct InfoUserView: View {
    
    @StateObject private var viewModel = ProfileViewModel()

    let backgroundColor = Color(red: 245/255, green: 250/255, blue: 246/255)
    let primaryTextColor = Color(red: 56/255, green: 142/255, blue: 84/255)
    enum Route: Hashable { case camera }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Image("jalapeño")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 150)

                    VStack {
                        Text("Cuéntanos sobre ti")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(primaryTextColor)
                        
                        Text("Para personalizar tu experiencia")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    InfoInputCard(iconName: "person.circle", title: "Nombre", placeholder: "Tu nombre", text: $viewModel.userProfile.nombre)
                    
                    InfoInputCard(iconName: "calendar", title: "Edad", placeholder: "Tu edad", text: $viewModel.userProfile.edad, keyboardType: .numberPad)

                    InfoInputCard(iconName: "exclamationmark.triangle", title: "Alergias alimentarias", placeholder: "Ej: Nueces, mariscos...", text: $viewModel.userProfile.alergias)

                    Spacer()
                    
                    NavigationLink(value: Route.camera) {
                        Text("Guardar y Continuar")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.green)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.saveProfile()
                    })
                    .padding(.top, 10)
                }
                .padding()
            }
        }
        .navigationTitle("Tu Perfil")
        .navigationBarHidden(true)
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .camera:
                CameraView()
                Text("Vista de la Cámara")
            }
        }
    }
}


struct InfoInputCard: View {
    let iconName: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: iconName).font(.title3).foregroundStyle(.gray)
                Text(title).font(.headline).foregroundStyle(Color.black.opacity(0.8))
            }
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(12)
                .background(Color(.systemGray6).opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 4)
    }
}

#Preview {
    InfoUserView()
}



