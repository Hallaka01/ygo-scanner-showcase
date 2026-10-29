import XCTest
@testable import ScannerCore

final class ScannerCoreTests: XCTestCase {
    func testMultipleCardsNeverProduceAnAutomaticHit() {
        let text = "99001001\nDEMO-EN001\n99001002"
        XCTAssertNil(ScanRecognition.candidate(in: text))
        XCTAssertTrue(ScanRecognition.hasMultiplePasscodes(in: text))
    }

    func testRepeatedOCRTextStillRepresentsOneCard() {
        let candidate = ScanRecognition.candidate(in: "99001001 DEMO-EN001\n99001001")
        XCTAssertEqual(candidate, ScanCandidate(passcode: 99001001, setCode: "DEMO-EN001"))
    }

    func testConflictingPrintCodesKeepCardIdentityButRequirePrintReview() {
        let candidate = ScanRecognition.candidate(in: "99001001 DEMO-EN001 DEMO-EN002")
        XCTAssertEqual(candidate?.passcode, 99001001)
        XCTAssertNil(candidate?.setCode)
    }

    func testManualPasscodeRejectsEmbeddedAndNonASCIIDigits() {
        XCTAssertEqual(ScanRecognition.manualPasscode(" 99001001\n"), 99001001)
        XCTAssertNil(ScanRecognition.manualPasscode("A99001001"))
        XCTAssertNil(ScanRecognition.manualPasscode("９９００１００１"))
        XCTAssertNil(ScanRecognition.manualPasscode("00000000"))
    }

    func testConfirmationRequiresDistinctFramesAndElapsedTime() {
        var observation = ScanObservation()
        let hit = ScanCandidate(passcode: 99001001, setCode: "DEMO-EN001")
        let start = Date(timeIntervalSince1970: 100)
        XCTAssertNil(observation.observe(hit, at: start))
        XCTAssertNil(observation.observe(hit, at: start))
        XCTAssertNil(observation.observe(hit, at: start.addingTimeInterval(0.2)))
        XCTAssertEqual(observation.observe(hit, at: start.addingTimeInterval(0.4)), hit)
    }

    func testChangedCardRestartsConfirmation() {
        var observation = ScanObservation()
        let first = ScanCandidate(passcode: 99001001, setCode: nil)
        let second = ScanCandidate(passcode: 99001002, setCode: nil)
        let start = Date(timeIntervalSince1970: 100)
        XCTAssertNil(observation.observe(first, at: start))
        XCTAssertNil(observation.observe(first, at: start.addingTimeInterval(0.2)))
        XCTAssertNil(observation.observe(second, at: start.addingTimeInterval(0.4)))
        XCTAssertNil(observation.observe(second, at: start.addingTimeInterval(0.6)))
        XCTAssertEqual(observation.observe(second, at: start.addingTimeInterval(0.8)), second)
    }

    func testShortOCRDropoutDoesNotAddAnotherPhysicalCopy() {
        var gate = ScanGate()
        let hit = ScanCandidate(passcode: 99001001, setCode: nil)
        let start = Date(timeIntervalSince1970: 100)
        XCTAssertEqual(gate.accept(hit, at: start), hit)
        XCTAssertNil(gate.accept(nil, at: start.addingTimeInterval(0.1)))
        XCTAssertNil(gate.accept(hit, at: start.addingTimeInterval(0.3)))
        XCTAssertNil(gate.accept(nil, at: start.addingTimeInterval(1)))
        XCTAssertEqual(gate.accept(hit, at: start.addingTimeInterval(2)), hit)
    }

    func testPrintingCodeNormalizesWithoutGuessingUnknownRegions() {
        let code = PrintingCode(" demo – de001 ")
        XCTAssertEqual(code?.value, "DEMO-DE001")
        XCTAssertEqual(code?.englishReference, "DEMO-EN001")
        XCTAssertEqual(code?.language, "DE")
        XCTAssertNil(PrintingCode("DEMO-E001")?.englishReference)
        XCTAssertNil(PrintingCode("DEMO!DE001"))
    }

    func testStockReservedForAnotherDeckIsNotAvailableTwice() {
        let first = UUID(), second = UUID()
        let stock = DeckInventory([
            InventoryCopy(id: UUID(), passcode: 99001001, assignedDeckID: first),
            InventoryCopy(id: UUID(), passcode: 99001001, assignedDeckID: second),
            InventoryCopy(id: UUID(), passcode: 99001001, assignedDeckID: nil)
        ])
        let result = stock.availability(passcode: 99001001, deckID: first, required: 3)
        XCTAssertEqual(result.owned, 3)
        XCTAssertEqual(result.assigned, 1)
        XCTAssertEqual(result.free, 1)
        XCTAssertEqual(result.reservedElsewhere, 1)
        XCTAssertEqual(result.missing, 1)
        XCTAssertEqual(stock.available(for: first)[99001001], 2)
    }

    func testMissingAndUnrelatedCardsKeepIndependentBudgets() {
        let deck = UUID()
        let stock = DeckInventory([
            InventoryCopy(id: UUID(), passcode: 99001002, assignedDeckID: nil)
        ])
        XCTAssertEqual(stock.availability(passcode: 99001001, deckID: deck, required: 2).missing, 2)
        XCTAssertEqual(stock.available(for: deck)[99001002], 1)
    }
}
