import Foundation
import SwiftData

@Model
final class ArXivPaper {
    @Attribute(.unique) let id: String
    var title: String
    var authors: [String]
    var summary: String
    var publishedDate: Date
    var pdfUrl: URL
    var upvotes: Int
    var downvotes: Int
    @Relationship(deleteRule: .cascade) var comments: [Comment]
    
    init(id: String, title: String, authors: [String], summary: String, publishedDate: Date, pdfUrl: URL) {
        self.id = id
        self.title = title
        self.authors = authors
        self.summary = summary
        self.publishedDate = publishedDate
        self.pdfUrl = pdfUrl
        self.upvotes = 0
        self.downvotes = 0
        self.comments = []
    }
}

@Model
final class Comment: Identifiable {
    @Attribute(.unique) let id: String
    var text: String
    var timestamp: Date
    var userId: String
    var username: String
    
    init(id: String = UUID().uuidString, text: String, userId: String, username: String) {
        self.id = id
        self.text = text
        self.timestamp = Date()
        self.userId = userId
        self.username = username
    }
}