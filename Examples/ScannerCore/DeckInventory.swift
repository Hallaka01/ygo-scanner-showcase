import Foundation

struct InventoryCopy: Sendable {
    let id: UUID
    let passcode: Int
    let assignedDeckID: UUID?
}

struct DeckCopyAvailability: Sendable {
    let required: Int
    let owned: Int
    let assigned: Int
    let free: Int
    let reservedElsewhere: Int
    var available: Int { assigned + free }
    var missing: Int { max(0, required - available) }
}

struct DeckInventory: Sendable {
    private var owned: [Int: Int] = [:]
    private var free: [Int: Int] = [:]
    private var reserved: [UUID: [Int: Int]] = [:]
    init(_ copies: [InventoryCopy]) {
        for copy in copies {
            owned[copy.passcode, default: 0] += 1
            if let deck = copy.assignedDeckID { reserved[deck, default: [:]][copy.passcode, default: 0] += 1 }
            else { free[copy.passcode, default: 0] += 1 }
        }
    }
    func available(for deckID: UUID) -> [Int: Int] {
        free.merging(reserved[deckID, default: [:]], uniquingKeysWith: +)
    }
    func availability(passcode: Int, deckID: UUID, required: Int) -> DeckCopyAvailability {
        let total = owned[passcode, default: 0], allocated = reserved[deckID]?[passcode] ?? 0
        let unassigned = free[passcode, default: 0]
        return DeckCopyAvailability(required: required, owned: total, assigned: allocated, free: unassigned,
            reservedElsewhere: max(0, total - allocated - unassigned))
    }
}
