//
//  XCTestCase+MemoryLeakTracking.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dealocated. Potential memory leak.", file: file, line: line)
        }
    }
}
