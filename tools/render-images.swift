#!/usr/bin/env swift
// Draws the site's images from the mark's proportions (docs/brand.md in the app's repository):
//
//   apple-touch-icon.png  180 × 180, the app icon's look: iron, chalk sleeve, the dark-mode plates
//   social-card.png       1200 × 630, shown when a link to the site is shared
//
// Run it from the repository's root after changing the mark or the card, then commit the PNGs:
//
//     swift tools/render-images.swift
//
// Nothing runs when the site is published. favicon.svg is drawn by hand from the same numbers.

import AppKit
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

func colour(_ hex: UInt32) -> CGColor {
    CGColor(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255, alpha: 1)
}

// Green, yellow, blue, red: shoulders, chest, back, legs.
let lightPlates: [UInt32] = [0x1FB25A, 0xF5B700, 0x2C6BF2, 0xF0384B]
let darkPlates: [UInt32] = [0x34D17A, 0xFFC933, 0x4C86FF, 0xFF4D5E]
let chalk: UInt32 = 0xF5F3EE
let ink: UInt32 = 0x121214
let inkSecondary: UInt32 = 0x6B6A70

/// The mark with its tallest plate `h` high and its left end at `origin`, y measured downwards.
/// The same proportions as `ChalkMark` and scripts/render-icon.swift: 1.53 h wide, plates 0.18 h
/// wide with 0.06 h gaps, the sleeve 0.07 h thick.
func drawMark(in context: CGContext, origin: CGPoint, height h: CGFloat, sleeve: UInt32, plates: [UInt32]) {
    func capsule(_ rect: CGRect, radius: CGFloat, _ fill: UInt32) {
        context.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
        context.setFillColor(colour(fill))
        context.fillPath()
    }
    let midY = origin.y + h / 2
    let plateWidth = h * 0.18, gap = h * 0.06, sleeveHeight = h * 0.07
    capsule(CGRect(x: origin.x, y: midY - sleeveHeight / 2, width: h * 1.53, height: sleeveHeight),
            radius: sleeveHeight / 2, sleeve)
    var x = origin.x + h * 0.2
    for (fraction, fill) in zip([0.52, 0.68, 0.84, 1.0] as [CGFloat], plates) {
        let plateHeight = h * fraction
        capsule(CGRect(x: x, y: midY - plateHeight / 2, width: plateWidth, height: plateHeight),
                radius: plateWidth * 0.4, fill)
        x += plateWidth + gap
    }
    capsule(CGRect(x: x, y: midY - h * 0.15, width: h * 0.07, height: h * 0.3), radius: h * 0.035, sleeve)
}

/// A flipped bitmap context, so y runs downwards as in the web's coordinates.
func canvas(width: Int, height: Int, _ draw: (CGContext) -> Void) -> CGImage {
    let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                            space: CGColorSpace(name: CGColorSpace.sRGB)!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.translateBy(x: 0, y: CGFloat(height))
    context.scaleBy(x: 1, y: -1)
    draw(context)
    return context.makeImage()!
}

func write(_ image: CGImage, to path: String) {
    let url = URL(fileURLWithPath: path)
    let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(destination, image, nil)
    precondition(CGImageDestinationFinalize(destination), "Couldn't write \(path)")
    print("Wrote \(path) (\(image.width) × \(image.height))")
}

/// One line of text in the system font, centred on `centreX` with its baseline at `baseline`.
/// Tracking is in ems, as in style.css.
func drawText(_ string: String, in context: CGContext, centreX: CGFloat, baseline: CGFloat, size: CGFloat,
              weight: NSFont.Weight, tracking: CGFloat = 0, fill: UInt32) {
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let text = NSAttributedString(string: string, attributes: [
        .font: font, .kern: tracking * size, .foregroundColor: NSColor(cgColor: colour(fill))!,
    ])
    let line = CTLineCreateWithAttributedString(text)
    // The trailing kern isn't ink, so leave it out when centring.
    let width = CTLineGetTypographicBounds(line, nil, nil, nil) - tracking * size
    context.saveGState()
    // Core Text draws upwards, so undo the flip around the baseline.
    context.textMatrix = .identity
    context.translateBy(x: centreX - width / 2, y: baseline)
    context.scaleBy(x: 1, y: -1)
    context.textPosition = .zero
    CTLineDraw(line, context)
    context.restoreGState()
}

// The touch icon: the app icon's iron gradient and mark at the same size (0.46 of the canvas).
// iOS rounds the corners itself, so the square is drawn to its edges.
let touchIcon = canvas(width: 180, height: 180) { context in
    let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB),
                              colors: [colour(0x1B1B1F), colour(0x0E0E10)] as CFArray, locations: [0, 1])!
    context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0, y: 180), options: [])
    let h: CGFloat = 180 * 0.46
    drawMark(in: context, origin: CGPoint(x: (180 - h * 1.53) / 2, y: (180 - h) / 2), height: h,
             sleeve: 0xE6E3DC, plates: darkPlates)
}
write(touchIcon, to: "apple-touch-icon.png")

// The social card: chalk, the mark, the name and the line from the brand, centred so a square
// crop still shows the mark and the name.
let card = canvas(width: 1200, height: 630) { context in
    context.setFillColor(colour(chalk))
    context.fill(CGRect(x: 0, y: 0, width: 1200, height: 630))
    let markHeight: CGFloat = 150
    drawMark(in: context, origin: CGPoint(x: (1200 - markHeight * 1.53) / 2, y: 92), height: markHeight,
             sleeve: ink, plates: lightPlates)
    drawText("Four Plates", in: context, centreX: 600, baseline: 392, size: 128, weight: .heavy,
             tracking: -0.04, fill: ink)
    drawText("Your training, in colour.", in: context, centreX: 600, baseline: 462, size: 46,
             weight: .regular, tracking: -0.01, fill: inkSecondary)
    drawText("fourplates.app", in: context, centreX: 600, baseline: 560, size: 28, weight: .semibold,
             tracking: -0.01, fill: ink)
}
write(card, to: "social-card.png")
