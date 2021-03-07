import Foundation

extension Calendar {
    func midnight(on date: Date) -> Date {
        let components = dateComponents([.year, .month, .day], from: date)
        return self.date(from: components)!
    }
}
