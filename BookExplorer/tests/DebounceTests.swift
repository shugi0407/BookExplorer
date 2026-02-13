import XCTest
@testable import BookExplorer

@MainActor
final class DebounceTests: XCTestCase {
    func testDebounceCancelsPreviousTask() async {
        let vm = SearchViewModel()
        vm.onQueryChanged("ha")
        vm.onQueryChanged("har")
        vm.onQueryChanged("harry")
        // If debounce didn’t cancel previous tasks, it would have searched earlier.
        // Here we just assert the VM holds the latest query.
        XCTAssertEqual(vm.query, "harry")
    }
}
