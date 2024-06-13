//
//  ImageServices.swift
//  Alliegiant
//
//  Created by P10 on 13/06/24.
//
import UIKit

class ImageLoader {
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            completion(nil)
            return
        }
        
        // Create a URL session data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or unable to create image from data.")
                completion(nil)
                return
            }
            
            // Pass the image back on the main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume() // resume the task
    }
}
