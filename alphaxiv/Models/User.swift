import SwiftData
import Foundation

@Model
final class User: Identifiable {
    let id: String
    var username: String

    init(id: String = UUID().uuidString, username: String) {
        self.id = id
        self.username = username
    }
}