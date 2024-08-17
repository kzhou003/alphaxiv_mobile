import Foundation
import SwiftData

class ArXivService {
    static let shared = ArXivService()
    private init() {}
    
    func fetchLatestPapers(since date: Date, completion: @escaping ([ArXivPaper]) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let filteredPapers = Self.mockPapers.filter { $0.publishedDate >= date }
            completion(filteredPapers)
        }
    }
    
    static let mockPapers: [ArXivPaper] = [
        ArXivPaper(id: "2104.12345", title: "Quantum Computing: A New Era", authors: ["Alice Johnson", "Bob Smith"], summary: "This paper explores the latest advancements in quantum computing and its potential impact on various fields.", publishedDate: Date(), pdfUrl: URL(string: "https://arxiv.org/pdf/2104.12345.pdf")!),
        ArXivPaper(id: "2104.67890", title: "Machine Learning in Astrophysics", authors: ["Charlie Brown", "Diana Prince"], summary: "We present novel machine learning techniques for analyzing astronomical data and discovering new celestial objects.", publishedDate: Date().addingTimeInterval(-86400), pdfUrl: URL(string: "https://arxiv.org/pdf/2104.67890.pdf")!),
        ArXivPaper(id: "2104.11111", title: "Advancements in Natural Language Processing", authors: ["Eve Taylor"], summary: "This paper discusses recent breakthroughs in NLP, including improved language models and translation systems.", publishedDate: Date().addingTimeInterval(-172800), pdfUrl: URL(string: "https://arxiv.org/pdf/2104.11111.pdf")!),
        ArXivPaper(id: "2105.22222", title: "Blockchain Technology in Supply Chain Management", authors: ["Frank Lee", "Grace Wang"], summary: "An exploration of how blockchain technology can revolutionize supply chain management and increase transparency.", publishedDate: Date().addingTimeInterval(-259200), pdfUrl: URL(string: "https://arxiv.org/pdf/2105.22222.pdf")!),
        ArXivPaper(id: "2105.33333", title: "Artificial Intelligence in Healthcare Diagnostics", authors: ["Hannah Kim", "Isaac Patel"], summary: "This study examines the application of AI in improving the accuracy and speed of medical diagnoses.", publishedDate: Date().addingTimeInterval(-345600), pdfUrl: URL(string: "https://arxiv.org/pdf/2105.33333.pdf")!),
        ArXivPaper(id: "2106.44444", title: "Renewable Energy Integration: Challenges and Solutions", authors: ["Julia Chen", "Kyle Martinez"], summary: "An analysis of the challenges faced in integrating renewable energy sources into existing power grids and proposed solutions.", publishedDate: Date().addingTimeInterval(-432000), pdfUrl: URL(string: "https://arxiv.org/pdf/2106.44444.pdf")!),
        ArXivPaper(id: "2106.55555", title: "Cybersecurity in the Age of IoT", authors: ["Liam Wilson", "Mia Thompson"], summary: "This paper discusses the evolving landscape of cybersecurity with the proliferation of Internet of Things (IoT) devices.", publishedDate: Date().addingTimeInterval(-518400), pdfUrl: URL(string: "https://arxiv.org/pdf/2106.55555.pdf")!),
        ArXivPaper(id: "2107.66666", title: "Genetic Engineering: Ethical Implications and Future Prospects", authors: ["Noah Garcia", "Olivia Brown"], summary: "An exploration of the ethical considerations surrounding genetic engineering and its potential future applications.", publishedDate: Date().addingTimeInterval(-604800), pdfUrl: URL(string: "https://arxiv.org/pdf/2107.66666.pdf")!),
        ArXivPaper(id: "2107.77777", title: "Quantum Cryptography: Securing the Future of Communication", authors: ["Peter Zhang", "Quinn Adams"], summary: "This paper examines the principles of quantum cryptography and its potential to revolutionize secure communication.", publishedDate: Date().addingTimeInterval(-691200), pdfUrl: URL(string: "https://arxiv.org/pdf/2107.77777.pdf")!),
        ArXivPaper(id: "2108.88888", title: "Deep Learning in Computer Vision: A Comprehensive Review", authors: ["Rachel Singh", "Samuel Lee"], summary: "A thorough review of the latest advancements in deep learning techniques applied to computer vision tasks.", publishedDate: Date().addingTimeInterval(-777600), pdfUrl: URL(string: "https://arxiv.org/pdf/2108.88888.pdf")!)
    ]
}