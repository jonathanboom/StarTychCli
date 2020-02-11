//
//  main.swift
//  StarTychCli
//
//  Created by Jonathan Lynch on 1/25/20.
//  Copyright © 2020 Intuitive Soup. All rights reserved.
//

import Foundation
import ImageFileManager
import StarTychCore

func hexCodeToColor(_ hexCode: String) -> CGColor? {
    if hexCode.count != 6 {
        return nil
    }
    
    let scanner = Scanner(string: hexCode)
    var hexNumber: UInt64 = 0
    if scanner.scanHexInt64(&hexNumber) {
        let components = [
            CGFloat((hexNumber & 0xff0000) >> 16) / 255, // Red
            CGFloat((hexNumber & 0x00ff00) >> 8) / 255, // Green
            CGFloat(hexNumber & 0x0000ff) / 255, // Blue
            1.0 // Alpha
        ]
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: components)
    }
    
    return nil
}

if CommandLine.arguments.count < 4 {
    print("\(CommandLine.arguments[0]) output color image-path [second-image-path ...]")
    exit(0)
}

let tych = StarTych(borderWeight: 0.04)

for i in 3 ..< CommandLine.arguments.count {
    let inputUrl = URL(fileURLWithPath: CommandLine.arguments[i])
    if let image = ImageFileManager.createCGImage(from: inputUrl) {
        let croppedImage = CroppableImage(image: image)
        croppedImage.croppedFrame = CGRect(x: -100, y: -100, width: 600000, height: 600000)
        tych.images.append(croppedImage)
    } else {
        print("Could not load image at \(inputUrl)")
    }
}

let colorArg = CommandLine.arguments[2]
if let color = hexCodeToColor(colorArg) {
    tych.borderColor = color
} else {
    print("Invalid hex code for border color, trying average color")
    if let averageColor = tych.averageColor {
        tych.borderColor = averageColor
    } else {
        print("Couldn't compute average color, just using whatever")
    }
}

guard let finalImage = tych.makeImage(in: CGSize(width: 1242, height: 2688)) else {
    print("Could not make *tych")
    exit(1)
}

let outputUrl = URL(fileURLWithPath: CommandLine.arguments[1])
ImageFileManager.write(image: finalImage, to: outputUrl)
