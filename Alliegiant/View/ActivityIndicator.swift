import UIKit

class ActivityIndicator {
    
    static let shared = ActivityIndicator() // Singleton instance
    
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {
        // Private initializer to ensure singleton pattern
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .gray
        activityIndicator?.hidesWhenStopped = true
    }
    
    func showActivityIndicator(on view: UIView) {
        DispatchQueue.main.async {
            guard let activityIndicator = self.activityIndicator else { return }
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
}
