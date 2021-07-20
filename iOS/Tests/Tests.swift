//
//  Tests.swift
//  Tests
//
//  Created by Richard Henry on 21/04/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import XCTest

class Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScoreBasic() throws {
        
        XCTAssertTrue(Score(dis: 0, acc: 0).current == 0)

        XCTAssertTrue(Score(dis: 0, acc: 3).current == 3)
        XCTAssertTrue(Score(dis: 3, acc: 0).current == 3)
        XCTAssertTrue(Score(dis: 1, acc: 2).current == 3)

        XCTAssertFalse(Score(dis: 0, acc: 3).current == 0)
        XCTAssertFalse(Score(dis: 3, acc: 0).current == 0)
        XCTAssertFalse(Score(dis: 1, acc: 2).current == 0)
    }

    func testScoreUpdate() throws {
        
        let score = Score(dis: 0, acc: 100).tick()
        
        XCTAssertTrue(score.current == 100)
        XCTAssertTrue(score.dis == 50)
        XCTAssertTrue(score.acc == 50)
    }

    func testScoreUpdateMulti() throws {
        
        let score = Score(dis: 0, acc: 100).tick()
        
        XCTAssertTrue(score.tick().current == 100)
        XCTAssertTrue(score.tick().dis == 75)
        XCTAssertTrue(score.tick().acc == 25)
    }

    func testScoreUpdateZero() throws {
        
        let score = Score(dis: 0, acc: 100).tick().tick().tick().tick().tick().tick()
        
        XCTAssertTrue(score.current == 100)
        XCTAssertTrue(score.dis == 98)
        XCTAssertTrue(score.acc == 2)
        
        XCTAssertTrue(score.tick().current == 100)
        XCTAssertTrue(score.tick().dis == 100)
        XCTAssertTrue(score.tick().acc == 0)
    }
}
