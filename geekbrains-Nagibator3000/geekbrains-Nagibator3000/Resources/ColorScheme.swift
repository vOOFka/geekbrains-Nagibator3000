import UIKit

enum ColorScheme: CaseIterable {
    case greenPantone, raspberryRose, fuchsiaBlue, white, black, alertRed

    var color: UIColor {
        switch self {
        case .greenPantone:
            return UIColor(red: 78.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        case .raspberryRose:
            return UIColor(red: 175.0/255.0, green: 78.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        case .fuchsiaBlue:
            return UIColor(red: 129.0/255.0, green: 78.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        case .white:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .alertRed:
            return UIColor(red: 178.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 0.0)
        case .black:
            return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }
    }
}
