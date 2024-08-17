import SwiftUI
import SwiftData

struct PaperDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var paper: ArXivPaper
    @State private var newCommentText = ""
    @State private var showUsernameAlert = false
    @State private var hasUpvoted = false
    @State private var hasDownvoted = false
    let username: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(paper.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(paper.authors.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Published: \(formattedDate(paper.publishedDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(paper.summary)
                    .font(.body)
                
                HStack {
                    Button(action: upvote) {
                        Label("Upvote (\(paper.upvotes))", systemImage: "arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .disabled(username == nil || hasUpvoted)
                    
                    Button(action: downvote) {
                        Label("Downvote (\(paper.downvotes))", systemImage: "arrow.down")
                    }
                    .buttonStyle(.bordered)
                    .disabled(username == nil || hasDownvoted)
                }
                
                Button(action: {
                    UIApplication.shared.open(paper.pdfUrl)
                }) {
                    Label("Open PDF", systemImage: "doc.text.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comments")
                        .font(.headline)
                    
                    ForEach(paper.comments, id: \.id) { comment in
                        CommentView(comment: comment)
                            .frame(maxWidth: .infinity) // Ensure comments take full width
                    }
                    
                    if username != nil {
                        HStack {
                            TextField("Add a comment", text: $newCommentText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button("Post") {
                                addComment()
                            }
                            .disabled(newCommentText.isEmpty)
                        }
                    } else {
                        Text("Please set a username to leave comments")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Paper Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Username Required", isPresented: $showUsernameAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please set a username before adding a comment.")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func upvote() {
        guard let username = username, !hasUpvoted else { return }
        paper.upvotes += 1
        hasUpvoted = true
        try? modelContext.save()
    }
    
    private func downvote() {
        guard let username = username, !hasDownvoted else { return }
        paper.downvotes += 1
        hasDownvoted = true
        try? modelContext.save()
    }
    
    private func addComment() {
        guard let username = username else {
            showUsernameAlert = true
            return
        }
        let newComment = Comment(text: newCommentText, userId: UUID().uuidString, username: username)
        paper.comments.append(newComment)
        try? modelContext.save()
        newCommentText = ""
    }
}

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(comment.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(comment.text)
                .font(.body) // Relative larger font size for text
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: .infinity) // Ensure comment view takes full width
    }
}