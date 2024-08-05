//
//  MainTabBarController.swift
//  Alliegiant
//
//  Created by P10 on 01/08/24.
//

import UIKit

class MainTabBarController: UITabBarController {

        override func viewDidLoad() {
            super.viewDidLoad()

            // Customize the tab bar appearance
            tabBar.barTintColor = UIColor.lightGray // Light grey background
            tabBar.tintColor = UIColor.black // Selected item color
            tabBar.unselectedItemTintColor = UIColor.darkGray // Unselected item color

            // Customize individual tab bar items
            if let items = tabBar.items {
                for item in items {
                    // Set the item's image and selected image with yellow tint
                    if let image = item.image {
                        item.image = image.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.darkGray)
                        item.selectedImage = image.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.black)
                    }
                }
            }
        }
    }

    // Helper extension to create colors from hex values
    extension UIColor {
        convenience init(hex: String) {
            var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if hexFormatted.hasPrefix("#") {
                hexFormatted.remove(at: hexFormatted.startIndex)
            }

            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            let alpha = CGFloat(1.0)

            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
