import Foundation

struct ScanCandidate: Equatable {
    let passcode: Int
    let setCode: String?
}

enum ScanRecognition {
    private static let passcodeRegex = try? NSRegularExpression(pattern: #"\b[0-9]{8}\b"#)
    private static let setCodeRegex = try? NSRegularExpression(pattern: #"\b[A-Z0-9]{2,5}-[A-Z0-9]{3,6}\b"#)

    static func candidate(in text: String) -> ScanCandidate? {
        // Multiple cards in one frame are ambiguous: ask the user to show one card.
        let passcodes = Set(matches(passcodeRegex, in: text).compactMap(Int.init).filter { $0 > 0 })
        guard passcodes.count == 1, let passcode = passcodes.first else { return nil }
        let codes = Set(matches(setCodeRegex, in: text.uppercased()))
        return ScanCandidate(passcode: passcode, setCode: codes.count == 1 ? codes.first : nil)
    }

    static func hasMultiplePasscodes(in text: String) -> Bool {
        Set(matches(passcodeRegex, in: text).compactMap(Int.init).filter { $0 > 0 }).count > 1
    }

    static func manualPasscode(_ text: String) -> Int? {
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard value.count == 8, value.utf8.allSatisfy({ (48...57).contains($0) }), let code = Int(value), code > 0 else { return nil }
        return code
    }

    private static func matches(_ expression: NSRegularExpression?, in text: String) -> [String] {
        guard let regex = expression else { return [] }
        let string = text as NSString
        return regex.matches(in: text, range: NSRange(location: 0, length: string.length)).map { string.substring(with: $0.range) }
    }
}

/// A card stays latched while visible. A brief OCR dropout does not count as a new copy.
struct ScanGate {
    private(set) var acceptedPasscode: Int?
    private var absentSince: Date?
    private var rearmed = false
    mutating func observePresence(_ candidate: ScanCandidate?, at now: Date = Date()) {
        guard candidate != nil else {
            if absentSince == nil { absentSince = now }
            return
        }
        if let absentSince, now.timeIntervalSince(absentSince) >= 0.8 { rearmed = true }
        absentSince = nil
    }
    mutating func accept(_ candidate: ScanCandidate?, at now: Date = Date()) -> ScanCandidate? {
        observePresence(candidate, at: now)
        guard let candidate, candidate.passcode != acceptedPasscode || rearmed else { return nil }
        acceptedPasscode = candidate.passcode; rearmed = false
        return candidate
    }
}

/// Each observation is a distinct camera frame; a timer can never confirm a single OCR hit.
struct ScanObservation {
    private var passcode: Int?
    private var firstSeen = Date.distantPast
    private var lastSeen = Date.distantPast
    private var frames = 0
    private var setVotes: [String: Int] = [:]
    mutating func observe(_ candidate: ScanCandidate?, at now: Date = Date()) -> ScanCandidate? {
        guard let candidate else { self = ScanObservation(); return nil }
        if candidate.passcode != passcode || now.timeIntervalSince(lastSeen) > 1.2 {
            self = ScanObservation()
            passcode = candidate.passcode; firstSeen = now
        }
        // Duplicate callbacks for one frame must not count as additional evidence.
        guard now > lastSeen else { return nil }
        lastSeen = now; frames += 1
        if let code = candidate.setCode { setVotes[code, default: 0] += 1 }
        guard frames >= 3, now.timeIntervalSince(firstSeen) >= 0.35 else { return nil }
        let confirmedSet = setVotes.count == 1 ? setVotes.first.flatMap { $0.value >= 2 ? $0.key : nil } : nil
        return ScanCandidate(passcode: candidate.passcode, setCode: confirmedSet)
    }
}
