//
//  UIColor+extra.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 21.11.2022.
//

import UIKit

extension UIColor {

    convenience init(hex hexValue: Int64) {
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(hexWithAlpha hexValue: Int64) {
        let red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(hexValue & 0x000000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    struct Common {
        static var greenBackground: UIColor { UIColor.HEX.hE8F4EA }
        static var greenAlphaBackground: UIColor { UIColor.HEX.hE8F4EADD }
        static var greenMain: UIColor { UIColor.HEX.h479F88 }
        static var blueMain: UIColor { UIColor.HEX.hA7C7E7 }
        static var blueButton: UIColor { UIColor.HEX.h537BC3 }
    }
    
    struct StartScreen {
        static var background: UIColor { UIColor.HEX.hE2EDE7 }
    }

    struct MainScreen {
        static var background: UIColor { UIColor.white }
        static var cellBackground: UIColor { UIColor.HEX.h4B6285 }
        static var cellDarkBackground: UIColor { UIColor.HEX.h2C3F66 }
        static var shimmerColorFirst = UIColor(white: 0.85, alpha: 1.0)
        static var shimmerColorSecond = UIColor(white: 0.95, alpha: 1.0)
    }

    struct MapScreen {
        static var closeButton: UIColor { UIColor.HEX.hf97C7C }
        static var bottomPanelBorder: UIColor { UIColor.HEX.hF1F1F1 }
    }

    struct TabBar {
        static var tabBarItem: UIColor { UIColor.HEX.h677F79 }
    }
    
    struct MiniApps {
        static var notes: UIColor { UIColor.HEX.hF5E9DF }
        static var genealogy: UIColor { UIColor.HEX.h95DCD0 }
        static var shelter: UIColor { UIColor.HEX.hDBC9A8 }
        static var education: UIColor { UIColor.HEX.hE2AEA2 }
    }
}

extension UIColor {
    fileprivate struct HEX {
        static let hFF3B30 = UIColor(hex: 0xAFD5F0)
        static let h4B6285 = UIColor(hex: 0x4B6285)
        static let h2C3F66 = UIColor(hex: 0x2C3F66)
        static let hf97C7C = UIColor(hex: 0xF97C7C)
        static let hF1F1F1 = UIColor(hex: 0xF1F1F1)
        static let h479F88 = UIColor(hex: 0x479F88)
        static let h677F79 = UIColor(hex: 0x677F79)
        static let hE8F4EA = UIColor(hex: 0xE8F4EA)
        static let hE2EDE7 = UIColor(hex: 0xE2EDE7)
        static let hA7C7E7 = UIColor(hex: 0xA7C7E7)
        static let hF5E9DF = UIColor(hex: 0xF5E9DF)
        static let hE2AEA2 = UIColor(hex: 0xE2AEA2)
        static let h95DCD0 = UIColor(hex: 0x95DCD0)
        static let hDBC9A8 = UIColor(hex: 0xDBC9A8)
        static let h537BC3 = UIColor(hex: 0x537BC3)

        static let hE8F4EADD = UIColor(hexWithAlpha: 0xE8F4EADD)
    }
}
