import UIKit

class ActivityIndicator {
    
    static let shared = ActivityIndicator() // Singleton instance
    
    private var activityIndicator: UIActivityIndicatorView?
    private var backgroundView: UIView?
    
    private init() {
        // Private initializer to ensure singleton pattern
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .gray
        activityIndicator?.hidesWhenStopped = true
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.8) // Semi-transparent white background
    }
    
    func showActivityIndicator(on view: UIView) {
        DispatchQueue.main.async {
            guard let activityIndicator = self.activityIndicator, let backgroundView = self.backgroundView else { return }
            backgroundView.center = view.center
            activityIndicator.center = backgroundView.center
            
            view.addSubview(backgroundView)
            backgroundView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.backgroundView?.removeFromSuperview()
        }
    }
}
