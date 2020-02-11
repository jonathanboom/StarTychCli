//
//  StarTychCliTests.swift
//  StarTychCliTests
//
//  Created by Jonathan Lynch on 2/10/20.
//  Copyright © 2020 Intuitive Soup. All rights reserved.
//

import AppKit
import XCTest
import StarTychCore

class StarTychCliTests: XCTestCase {
    
    var starTych: StarTych?
    
    let sizes = [
        CGSize(width: 750, height: 1334),
        CGSize(width: 1242, height: 2688),
        CGSize(width: 2732, height: 2048),
        CGSize(width: 1920, height: 1080),
        CGSize(width: 200, height: 200)
    ]

    // This method is called before the invocation of each test method in the class
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        let gimli = bundle.image(forResource: "gimli")?
            .cgImage(forProposedRect: nil, context: nil, hints: nil)
        let duke = bundle.image(forResource: "duke")?
            .cgImage(forProposedRect: nil, context: nil, hints: nil)
        let trees = bundle.image(forResource: "trees")?
            .cgImage(forProposedRect: nil, context: nil, hints: nil)
        let pinkClouds = bundle.image(forResource: "pink-clouds")?
            .cgImage(forProposedRect: nil, context: nil, hints: nil)
        
        starTych = StarTych(borderWeight: 0.06)
        starTych?.addImage(gimli!)
        starTych?.addImage(duke!)
        starTych?.addImage(trees!)
        starTych?.addImage(pinkClouds!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        while starTych?.hasAnyImage ?? false {
            starTych?.removeImage(index: 0)
        }
        starTych = nil
    }

    func testPerformanceMakeImage() {
        XCTAssertNotNil(starTych?.makeImage())
        measure {
            for size in sizes {
                for i in 1...50 {
                    let borderWeight = Float(i) / 200.0
                    starTych?.outerBorderWeight = borderWeight
                    starTych?.innerBorderWeight = borderWeight
                    XCTAssertNotNil(starTych?.makeImage(in: size))
                }
            }
        }
    }
}
