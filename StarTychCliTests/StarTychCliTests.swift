//
// Copyright (c) 2020, Jonathan Lynch
//
// This source code is licensed under the BSD 3-Clause License license found in the
// LICENSE file in the root directory of this source tree.
//

import AppKit
import StarTychCore
import XCTest

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
        starTych?.images[0].croppedFrame = CGRect(x: 100, y: 100, width: 200, height: 100)
        XCTAssertEqual(starTych?.images[0].croppedImage.width, 200)
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
    
    func testCropAndRotation() {
        starTych!.images[0].set(croppedFrame: CGRect(x: 100, y: 100, width: 200, height: 100), rotation: 90)
        XCTAssertEqual(starTych?.images[0].croppedImage.width, 200)
        XCTAssertEqual(starTych?.images[0].croppedImage.height, 100)
    }
    
    func testRotation() {
        starTych!.images[0].rotation = 90
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.height)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.width)
        
        starTych!.images[0].rotation = -90
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.height)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.width)
        
        starTych!.images[0].rotation = 180
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height)
        
        starTych!.images[0].rotation = 360
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height)
    }
    
    func testRotationNonNinety() {
        starTych!.images[0].rotation = 91
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.height)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.width)
        
        starTych!.images[0].rotation = -91
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.height)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.width)
        
        starTych!.images[0].rotation = 89
        XCTAssertEqual(starTych!.images[0].croppedImage.width, starTych!.images[0].originalImage.width)
        XCTAssertEqual(starTych!.images[0].croppedImage.height, starTych!.images[0].originalImage.height)
        
        starTych!.images[0].rotation = 355
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
    
    func testPerformanceMakeImageLowInterpolation() {
        XCTAssertNotNil(starTych?.makeImage())
        measure {
            for size in sizes {
                for i in 1...50 {
                    let borderWeight = Float(i) / 200.0
                    starTych?.outerBorderWeight = borderWeight
                    starTych?.innerBorderWeight = borderWeight
                    let image = starTych?.makeImage(in: size, interpolationQuality: .low)
                    XCTAssertNotNil(image)
                    XCTAssertLessThanOrEqual(CGFloat(image!.width), size.width)
                    XCTAssertLessThanOrEqual(CGFloat(image!.height), size.height)
                }
            }
        }
    }
    
    func testPerformanceMakeImageNoInterpolation() {
        XCTAssertNotNil(starTych?.makeImage())
        measure {
            for size in sizes {
                for i in 1...50 {
                    let borderWeight = Float(i) / 200.0
                    starTych?.outerBorderWeight = borderWeight
                    starTych?.innerBorderWeight = borderWeight
                    let image = starTych?.makeImage(in: size, interpolationQuality: .none)
                    XCTAssertNotNil(image)
                    XCTAssertLessThanOrEqual(CGFloat(image!.width), size.width)
                    XCTAssertLessThanOrEqual(CGFloat(image!.height), size.height)
                }
            }
        }
    }
}
