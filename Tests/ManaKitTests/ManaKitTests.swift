import XCTest
import CoreData
@testable import ManaKit

final class ManaKitTests: XCTestCase {
    override func setUp() {
        ManaKit.shared.configure(apiURL: "http://managuideapp.com")
        ManaKit.shared.setupResources()
    }

    
}
