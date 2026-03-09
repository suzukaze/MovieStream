//
//  MovieStreamTests.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2026/03/09.
//
/*
import XCTest
@testable import MovieStream

final class MovieStreamTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}*/

import XCTest
@testable import MovieStream

final class StringUtilsTests: XCTestCase {
    
    func testSplitFilename_NormalCase() {
        let result = StringUtils.splitFilename("example.mp4")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "example")
        XCTAssertEqual(result?.ext, "mp4")
    }
    
    func testSplitFilename_NoExtension() {
        let result = StringUtils.splitFilename("example")
        
        XCTAssertNil(result)
    }
    
    func testSplitFilename_EmptyExtension() {
        let result = StringUtils.splitFilename("example.")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "example")
        XCTAssertEqual(result?.ext, "")
    }

    func testSplitFilename_MultipleDots() {
        let result = StringUtils.splitFilename("a.b.c")
        // maxSplits: 1なので、"a"と"b.c"に分かれる
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "a")
        XCTAssertEqual(result?.ext, "b.c")
    }

    func testTimeString() {
        // 1時間未満
        XCTAssertEqual(StringUtils.timeString(from: 0), "00:00")
        XCTAssertEqual(StringUtils.timeString(from: 5), "00:05")
        XCTAssertEqual(StringUtils.timeString(from: 65), "01:05")
        XCTAssertEqual(StringUtils.timeString(from: 3599), "59:59")

        // 1時間ちょうど
        XCTAssertEqual(StringUtils.timeString(from: 3600), "1:00:00")
        XCTAssertEqual(StringUtils.timeString(from: 3661), "1:01:01")
        XCTAssertEqual(StringUtils.timeString(from: 3725), "1:02:05")

        // 2時間以上
        XCTAssertEqual(StringUtils.timeString(from: 7325), "2:02:05")
        XCTAssertEqual(StringUtils.timeString(from: 86399), "23:59:59")
    }
}
