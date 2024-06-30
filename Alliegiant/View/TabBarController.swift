import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the tab bar's tint color (the color of the selected item)
        tabBar.tintColor = .systemPink
        
        // Set the tab bar's unselected item color (optional)
        tabBar.unselectedItemTintColor = .systemPink.withAlphaComponent(0.6)
        
        // Set the background color of the tab bar to the specified pink color
        let pinkColor = UIColor(red: 1.0, green: 0.863, blue: 0.894, alpha: 1.0) // #FFDCE4
        tabBar.barTintColor = pinkColor

        // Remove the default shadow and set a transparent background
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // Create a custom background view with rounded corners
        let backgroundView = UIView(frame: tabBar.bounds)
        backgroundView.backgroundColor = pinkColor // Same pink color
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.masksToBounds = true

        // Ensure the background view fills the tab bar's bounds
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.insertSubview(backgroundView, at: 0)
        
        // Add constraints to make the background view fill the tab bar
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
    }
}
