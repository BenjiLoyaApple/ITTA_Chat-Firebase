//
//  ContentView.swift
//  Chat
//
//  Created by Benji Loya on 10/01/23.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
