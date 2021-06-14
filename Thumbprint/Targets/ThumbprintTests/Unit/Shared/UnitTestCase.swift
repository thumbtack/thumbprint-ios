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

    /// Override tearDownWithError as it gets called later by XCTestCase.
    open override func tearDownWithError() throws {
        let localBehavior = behavior
        behavior = nil
        localBehavior?.tearDown(
            testCase: self,
            ensureCleanProperties: true
        )

        try super.tearDownWithError()
    }
}
