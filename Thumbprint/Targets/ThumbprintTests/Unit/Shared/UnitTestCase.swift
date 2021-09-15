import XCTest

open class UnitTestCase: XCTestCase {
    private var behavior: TestCaseBehavior!

    open override class func setUp() {
        super.setUp()

        TestCaseBehavior.setUp()
    }

    open override func setUp() {
        super.setUp()

        behavior = TestCaseBehavior()
    }

    open override func tearDown() {
        let localBehavior = behavior
        behavior = nil
        localBehavior?.tearDown(
            testCase: self,
            ensureCleanProperties: true
        )

        super.tearDown()
    }
}
