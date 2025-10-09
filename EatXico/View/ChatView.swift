//
//  ChatView.swift
//  EatXico
//
//  Created by Alan Cervantes on 02/10/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(vm.msgs) { m in
                            bubble(for: m)
                                .id(m.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .onChange(of: vm.msgs) { _, newValue in
                    if let last = newValue.last {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 10) {
                TextField("Escribe…", text: $vm.input, axis: .vertical)
                    .foregroundStyle(.black)
                    .background(.gray.opacity(0.15))
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                    .onSubmit { Task { await vm.send() } }
                
                Button {
                    Task { await vm.send() }
                } label: {
                    if vm.thinking {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.up.message.fill")
                        .foregroundColor(.green)                    }
                }
                .disabled(vm.thinking)
            }
            .padding(.all, 12)
            .background(.white)
        }
        .alert("Error", isPresented: .constant(vm.error != nil)) {
            Button("OK") { vm.error = nil }
        } message: {
            Text(vm.error ?? "")
        }
        .background(.gray.opacity(0.1))
    }
        
    
    // Globos con estilo y “cursor” de tipeo cuando el asistente está respondiendo
    @ViewBuilder
    private func bubble(for msg: ChatViewModel.Msg) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(msg.text.isEmpty && msg.role == .assistant ? " " : msg.text)
                .overlay(alignment: .trailing) {
                    if msg.role == .assistant, vm.thinking {
                        BlinkingCursor()
                            .padding(.leading, 4)
                    }
                }
                .padding(10)
                .background(bubbleColor(for: msg.role))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity,
                       alignment: msg.role == .user ? .trailing : .leading)
        }
    }
    
    private func bubbleColor(for role: ChatViewModel.Msg.Role) -> Color {
        switch role {
        case .user: return .green.opacity(0.9)
        case .assistant: return .gray.opacity(0.12)
        case .system: return .green.opacity(0.10)
        }
    }
}

struct BlinkingCursor: View {
    @State private var on = true
    var body: some View {
        Text("▍")
            .opacity(on ? 1.0 : 0.2)
            .font(.body.monospacedDigit())
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: on)
            .onAppear { on = true }
    }
}

#Preview {
    ChatView()
}
