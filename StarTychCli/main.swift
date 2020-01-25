//
//  main.swift
//  StarTychCli
//
//  Created by Jonathan Lynch on 1/25/20.
//  Copyright © 2020 Intuitive Soup. All rights reserved.
//

import Foundation
import ImageFileManager
import StarTych

if CommandLine.arguments.count < 4 {
    print("\(CommandLine.arguments[0]) output color image-path [second-image-path ...]")
    exit(0)
}

let tych = StarTych(borderWeight: 0.04)

// TODO: Ignoring border color arg for now

for i in 3 ..< CommandLine.arguments.count {
    let inputUrl = URL(fileURLWithPath: CommandLine.arguments[i])
    if let image = ImageFileManager.createCGImage(from: inputUrl) {
        tych.addImage(image)
    } else {
        print("Could not load image at \(inputUrl)")
    }
}

// TODO: Make full tych
guard let finalImage = tych.makeStarTych() else {
    print("Could make *tych")
    exit(1)
}

let outputUrl = URL(fileURLWithPath: CommandLine.arguments[1])
ImageFileManager.write(image: finalImage, to: outputUrl)
