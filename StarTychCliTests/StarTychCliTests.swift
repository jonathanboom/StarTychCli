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
            starTych?.images = []
        }
        starTych = nil
    }
    
    func testCropNormal() {
        starTych?.images[0].croppedFrame = CGRect(x: 100, y: 100, width: 100, height: 100)
        XCTAssertEqual(starTych?.images[0].croppedImage.width, 100)
        XCTAssertEqual(starTych?.images[0].croppedImage.height, 100)
    }
    
    func testCropOverlap() {
        starTych!.images[0].croppedFrame = CGRect(x: 200, y: 100, width: 100000, height: 100000)
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width - 200)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height - 100)
    }
    
    func testCropTooBig() {
        starTych!.images[0].croppedFrame = CGRect(x: -100, y: -100, width: 100000, height: 100000)
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height)
    }
    
    func testCropNil() {
        starTych!.images[0].croppedFrame = CGRect(x: 100, y: 100, width: 100, height: 100)
        starTych!.images[0].croppedFrame = nil
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height)
    }

    func testPerformanceMakeImage() {
        XCTAssertNotNil(starTych?.makeImage())
        measure {
            for size in sizes {
                for i in 1...50 {
                    let borderWeight = Float(i) / 200.0
                    starTych?.outerBorderWeight = borderWeight
                    starTych?.innerBorderWeight = borderWeight
                    let image = starTych?.makeImage(in: size)
                    XCTAssertNotNil(image)
                    XCTAssertLessThanOrEqual(CGFloat(image!.width), size.width)
                    XCTAssertLessThanOrEqual(CGFloat(image!.height), size.height)
                }
            }
        }
    }
}
