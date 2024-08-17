import SwiftUI
import SwiftData

struct PaperListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var papers: [ArXivPaper]
    @State private var isLoading = false
    @State private var sortOption: SortOption = .timestamp
    @State private var searchText = ""
    @State private var dateRange: DateRange = .lastWeek
    @State private var username: String?
    @State private var showUsernameInput = false
    
    enum SortOption: String, CaseIterable {
        case alphabetic = "Title"
        case upvotes = "Upvotes"
        case downvotes = "Downvotes"
        case comments = "Comments"
        case timestamp = "Date"
    }
    
    enum DateRange: String, CaseIterable {
        case today = "Today"
        case lastThreeDays = "Last 3 Days"
        case lastWeek = "Last 7 Days"
        case lastMonth = "Last Month"
        case lastYear = "Last Year"
        
        var date: Date {
            let calendar = Calendar.current
            let now = Date()
            switch self {
            case .today:
                return calendar.startOfDay(for: now)
            case .lastThreeDays:
                return calendar.date(byAdding: .day, value: -3, to: now)!
            case .lastWeek:
                return calendar.date(byAdding: .day, value: -7, to: now)!
            case .lastMonth:
                return calendar.date(byAdding: .month, value: -1, to: now)!
            case .lastYear:
                return calendar.date(byAdding: .year, value: -1, to: now)!
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading papers...")
                } else if papers.isEmpty {
                    Text("No papers available")
                } else {
                    paperList
                }
            }
            .navigationTitle("AlphaXiv Reader")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showUsernameInput = true }) {
                        Image(systemName: "person.circle")
                        Text(username ?? "Set username")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    controlsView
                }
            }
            .sheet(isPresented: $showUsernameInput) {
                UsernameInputView(username: $username)
            }
            .onAppear {
                if papers.isEmpty {
                    loadPapers()
                }
            }
            .onChange(of: dateRange) { _, _ in
                loadPapers()
            }
        }
    }

    private var paperList: some View {
        List(sortedPapers) { paper in
            NavigationLink(destination: PaperDetailView(paper: paper, username: username)) {
                PaperRowView(paper: paper)
            }
        }
        .searchable(text: $searchText, prompt: "Search papers")
    }

    private var controlsView: some View {
        HStack {
            dateRangeMenu
            sortMenu
            refreshButton
        }
    }

    private var dateRangeMenu: some View {
        Menu {
            ForEach(DateRange.allCases, id: \.self) { range in
                Button {
                    dateRange = range
                } label: {
                    HStack {
                        if dateRange == range {
                            Image(systemName: "checkmark")
                        }
                        Text(range.rawValue)
                    }
                }
            }
        } label: {
            Label(dateRange.rawValue, systemImage: "calendar")
        }
    }

    private var sortMenu: some View {
        Menu {
            Picker("Sort by", selection: $sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    HStack {
                        if sortOption == option {
                            Image(systemName: "checkmark")
                        }
                        Text(option.rawValue)
                    }
                    .tag(option)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }

    private var refreshButton: some View {
        Button(action: refreshPapers) {
            Image(systemName: "arrow.clockwise")
        }
    }

    private var sortedPapers: [ArXivPaper] {
        let filteredPapers = filterPapers()
        return sortPapers(filteredPapers)
    }

    private func filterPapers() -> [ArXivPaper] {
        papers.filter { paper in
            (searchText.isEmpty || paper.title.localizedCaseInsensitiveContains(searchText)) &&
            paper.publishedDate >= dateRange.date
        }
    }

    private func sortPapers(_ papers: [ArXivPaper]) -> [ArXivPaper] {
        papers.sorted { paper1, paper2 in
            switch sortOption {
            case .alphabetic:
                return paper1.title < paper2.title
            case .upvotes:
                return paper1.upvotes > paper2.upvotes
            case .downvotes:
                return paper1.downvotes > paper2.downvotes
            case .comments:
                return paper1.comments.count > paper2.comments.count
            case .timestamp:
                return paper1.publishedDate > paper2.publishedDate
            }
        }
    }
    
    private func loadPapers() {
        isLoading = true
        ArXivService.shared.fetchLatestPapers(since: dateRange.date) { fetchedPapers in
            DispatchQueue.main.async {
                for paper in fetchedPapers {
                    if let existingPaper = papers.first(where: { $0.id == paper.id }) {
                        // Update existing paper while preserving votes and comments
                        existingPaper.title = paper.title
                        existingPaper.authors = paper.authors
                        existingPaper.summary = paper.summary
                        existingPaper.publishedDate = paper.publishedDate
                        existingPaper.pdfUrl = paper.pdfUrl
                    } else {
                        // Insert new paper
                        modelContext.insert(paper)
                    }
                }
                try? modelContext.save()
                self.isLoading = false
            }
        }
    }
    
    private func refreshPapers() {
        loadPapers()
    }
}

struct UsernameInputView: View {
    @Binding var username: String?
    @State private var inputUsername = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $inputUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: inputUsername) { _, newValue in
                        inputUsername = newValue.filter { $0.isNumber || $0.isLetter }
                        if inputUsername.count > 23 {
                            inputUsername = String(inputUsername.prefix(23))
                        }
                    }
                
                Button("Save") {
                    username = inputUsername
                    dismiss()
                }
                .disabled(inputUsername.isEmpty)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Set username")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}

struct PaperRowView: View {
    let paper: ArXivPaper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(paper.title)
                .font(.headline)
                .lineLimit(2)
            Text(paper.authors.joined(separator: ", "))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            HStack {
                Label("\(paper.upvotes)", systemImage: "arrow.up")
                Label("\(paper.downvotes)", systemImage: "arrow.down")
                Label("\(paper.comments.count)", systemImage: "text.bubble")
                Spacer()
                Text(paper.publishedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}