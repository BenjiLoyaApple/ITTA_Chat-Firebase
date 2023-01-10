//
//  ContentView.swift
//  Chat
//
//  Created by Benji Loya on 10/01/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
