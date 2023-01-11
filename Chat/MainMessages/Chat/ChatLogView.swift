//
//  ContentView.swift
//  Chat
//
//  Created by Benji Loya on 10/01/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore


struct ChatLogView: View {
    
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "photo")
                .font(.system(size: 24))
                .foregroundColor(Color(.gray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                    .offset(x: 10)
                   
            }
            .frame(height: 40)
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)),Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),]),
                startPoint: .trailing,
                endPoint: .leading))
            .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer(minLength: 5)
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),]),
                        startPoint: .trailing,
                        endPoint: .leading))
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 5, y: 5)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                    }
                    .padding(10)
                    .background(Color("MessageColor"))
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 5, y: 5)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
//        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Message...")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 15)
                .padding(.top, -4)
            
            Spacer()
        }
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.blue, lineWidth: 1)
            
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
