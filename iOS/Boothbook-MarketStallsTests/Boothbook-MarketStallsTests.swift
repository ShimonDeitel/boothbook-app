import XCTest
@testable import Boothbook-MarketStalls

@MainActor
final class Boothbook-MarketStallsTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testSeedDataHasNoItemsAfterClear() {
        XCTAssertEqual(store.items.count, 0)
    }

    func testAddItemIncreasesCount() {
        let item = Booking(title: "Test Item")
        _ = store.add(item, isPro: false)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddRespectsFreeLimit() {
        for i in 0..<Store.freeLimit {
            _ = store.add(Booking(title: "Item \(i)"), isPro: false)
        }
        let added = store.add(Booking(title: "Overflow"), isPro: false)
        XCTAssertFalse(added)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProBypassesFreeLimit() {
        for i in 0..<Store.freeLimit {
            _ = store.add(Booking(title: "Item \(i)"), isPro: true)
        }
        let added = store.add(Booking(title: "Extra"), isPro: true)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, Store.freeLimit + 1)
    }

    func testDeleteByIdRemovesItem() {
        let item = Booking(title: "Delete Me")
        _ = store.add(item, isPro: false)
        store.delete(id: item.id)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testUpdateChangesTitle() {
        var item = Booking(title: "Original")
        _ = store.add(item, isPro: false)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "Updated")
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore(isPro: false))
    }

    func testPersistenceRoundTrip() {
        let item = Booking(title: "Persisted")
        _ = store.add(item, isPro: false)
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.title == "Persisted" }))
    }
}
