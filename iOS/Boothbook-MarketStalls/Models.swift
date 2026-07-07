import Foundation

struct Booking: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var date: String = ""
    var fee: Double = 0.0
    var notes: String = ""
    var dateAdded: Date = Date()
}
