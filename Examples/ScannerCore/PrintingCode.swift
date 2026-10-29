import Foundation

struct PrintingCode: Hashable {
    let prefix: String
    let suffix: String
    var value: String { prefix + "-" + suffix }
    init?(_ raw: String) {
        let cleaned = raw.uppercased().filter { !$0.isWhitespace }.replacingOccurrences(of: "–", with: "-").replacingOccurrences(of: "—", with: "-")
        let parts = cleaned.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 2, (2...5).contains(parts[0].count), (3...6).contains(parts[1].count),
              parts.allSatisfy({ $0.utf8.allSatisfy { (48...57).contains($0) || (65...90).contains($0) } }),
              parts[0].utf8.contains(where: { (65...90).contains($0) }),
              parts[1].utf8.contains(where: { (48...57).contains($0) }) else { return nil }
        prefix = String(parts[0]); suffix = String(parts[1])
    }
    static func characters(_ text: String, limit: Int) -> String {
        String(decoding: text.uppercased().utf8.filter { (48...57).contains($0) || (65...90).contains($0) }.prefix(limit), as: UTF8.self)
    }
    /// Only modern, explicit language suffixes are eligible; older regional numbering is not guessed.
    var englishReference: String? {
        guard prefix.count == 4, suffix.count == 5, ["DE", "FR", "IT", "ES", "PT"].contains(String(suffix.prefix(2))) else { return nil }
        return prefix + "-EN" + suffix.dropFirst(2)
    }
    var language: String? {
        let candidate = String(suffix.prefix(2))
        return ["DE", "EN", "FR", "IT", "ES", "PT", "JP", "KR"].contains(candidate) ? candidate : nil
    }
}
