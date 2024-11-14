import UIKit

extension UIColor {
    public convenience init(hex: String) {
        let hexTrimmed = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var result: UInt64 = 0
        Scanner(string: hexTrimmed).scanHexInt64(&result)
        let alphaChannel, redChannel, greenChannel, blueChannel: UInt64
        switch hexTrimmed.count {
        case 3: // RGB (12-bit)
            (alphaChannel, redChannel, greenChannel, blueChannel) = (255, (result >> 8) * 17, (result >> 4 & 0xF) * 17, (result & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alphaChannel, redChannel, greenChannel, blueChannel) = (255, result >> 16, result >> 8 & 0xFF, result & 0xFF)
        case 8: // ARGB (32-bit)
            (alphaChannel, redChannel, greenChannel, blueChannel) = (result >> 24, result >> 16 & 0xFF, result >> 8 & 0xFF, result & 0xFF)
        default:
            (alphaChannel, redChannel, greenChannel, blueChannel) = (1, 1, 1, 0)
        }
        
        self.init(red: Double(redChannel) / 255,
                  green: Double(greenChannel) / 255,
                  blue: Double(blueChannel) / 255,
                  alpha: Double(alphaChannel) / 255)
    }
}
