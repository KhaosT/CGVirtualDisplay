//
//  ViewController.swift
//  VirtualDisplayExp
//
//  Created by Khaos Tian on 2/17/21.
//

import Cocoa
import CoreGraphics

class ViewController: NSViewController {

    private var display: CGVirtualDisplay?
    private var stream: CGDisplayStream?

    override func viewDidLoad() {
        super.viewDidLoad()

        let desc = CGVirtualDisplayDescriptor()
        desc.setDispatchQueue(DispatchQueue.main)
        desc.terminationHandler = { a, b in
            NSLog("\(String(describing: a)), \(String(describing: b))")
        }
        desc.name = "Test Display"
        desc.maxPixelsWide = 1920
        desc.maxPixelsHigh = 1080
        desc.sizeInMillimeters = CGSize(width: 1800, height: 1012.5)
        desc.productID = 0x1234
        desc.vendorID = 0x3456
        desc.serialNum = 0x0001

        let display = CGVirtualDisplay(descriptor: desc)

        let settings = CGVirtualDisplaySettings()
        settings.hiDPI = 2
        settings.modes = [
            CGVirtualDisplayMode(width: 1920, height: 1080, refreshRate: 60),
            CGVirtualDisplayMode(width: 1920, height: 1080, refreshRate: 30),
        ]

        self.display = display
        display.apply(settings)

        let stream = CGDisplayStream(
            dispatchQueueDisplay: display.displayID,
            outputWidth: 1920,
            outputHeight: 1080,
            pixelFormat: 1111970369, // BGRA
            properties: nil,
            queue: .main,
            handler: { [weak self] frameStatus, displayTime, frameSurface, updateRef in
                if let surface = frameSurface {
                    self?.view.layer?.contents = surface
                }
            }
        )

        self.stream = stream
        if let error = stream?.start() {
            print(error)
        }
    }
}

