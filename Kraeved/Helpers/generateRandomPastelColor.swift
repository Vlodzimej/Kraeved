import UIKit

func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
    let randomColorGenerator = { () -> CGFloat in
        CGFloat(UInt32.random(in: 0...16355) % 256) / 256
    }

    var red: CGFloat = randomColorGenerator()
    var green: CGFloat = randomColorGenerator()
    var blue: CGFloat = randomColorGenerator()

    if let mixColor = mixColor {
        var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0
        mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)

        red = (red + mixRed) / 2
        green = (green + mixGreen) / 2
        blue = (blue + mixBlue) / 2
    }

    return UIColor(red: red, green: green, blue: blue, alpha: 1)
}
