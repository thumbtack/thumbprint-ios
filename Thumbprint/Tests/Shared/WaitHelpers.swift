import XCTest

public enum TTTestWaitResult {
    case wait, success
}

public enum TTWaitTimeoutCondition {
    case fail, skip
}

public func tt_waitFor(interval: TimeInterval) {
    CFRunLoopRunInMode(CFRunLoopMode.defaultMode, interval, false)
}

public func tt_waitForAnimations() {
    tt_waitFor(interval: 0.3)
}

public func tt_waitUntil(_ closure: () -> Bool, timeoutCondition: TTWaitTimeoutCondition = .fail, file: StaticString = #filePath, line: UInt = #line) {
    tt_waitOrSkip(timeoutCondition: timeoutCondition, file: file, line: line, block: { closure() ? .success : .wait })
}

public func tt_waitFor(timeout: TimeInterval = 10, message: String = "Timeout waiting for condition", file: StaticString = #filePath, line: UInt = #line, block: () -> TTTestWaitResult) {
    tt_waitOrSkip(timeoutCondition: .fail, timeout: timeout, message: message, file: file, line: line, block: block)
}

public func tt_waitOrSkip(timeoutCondition: TTWaitTimeoutCondition,
                          timeout: TimeInterval = 10,
                          message: String = "Timeout waiting for condition",
                          file: StaticString = #filePath,
                          line: UInt = #line,
                          block: () -> TTTestWaitResult,
                          successBlock: (() -> Void)? = nil) {
    let timeoutMs = UInt(timeout * 1000)
    let startedAt = getAbsoluteTimeMs()
    var result: TTTestWaitResult = .wait

    while (getAbsoluteTimeMs() - startedAt) < timeoutMs {
        result = block()

        if result == .success {
            successBlock?()
            break
        }

        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, false)

        result = block()

        if result == .success {
            successBlock?()
            break
        }
    }

    if timeoutCondition == .fail, result == .wait {
        XCTFail("\(message)", file: file, line: line)
    }
}

private func getAbsoluteTimeMs() -> UInt {
    var info = mach_timebase_info(numer: 0, denom: 0)
    mach_timebase_info(&info)
    let numer = UInt64(info.numer)
    let denom = UInt64(info.denom)
    let nanoseconds = (mach_absolute_time() * numer) / denom
    return UInt(nanoseconds / NSEC_PER_MSEC)
}
