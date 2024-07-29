import Foundation

struct WeatherManager {
    func fetchData(for category: String, completion: @escaping ([Product]) -> Void) {
        let weatherURL = "https://dummyjson.com/products/category/\(category)"
        performRequest(weatherURL: weatherURL, completion: completion)
    }
    
    internal func performRequest(weatherURL: String, completion: @escaping ([Product]) -> Void) {
        if let url = URL(string: weatherURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let products = self.parseJSON(weatherData: safeData) {
                        completion(products)
                    }
                }
            }
            task.resume()
        }
    }
    
    internal func parseJSON(weatherData: Data) -> [Product]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
            return decodedData.products
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchReviews(for productId: Int, completion: @escaping ([Review]) -> Void) {
        let reviewsURL = "https://dummyjson.com/products/\(productId)"
        performReviewRequest(reviewsURL: reviewsURL) { product in
            let reviews = product.reviews
            completion(reviews)
        }
    }
    
    internal func performReviewRequest(reviewsURL: String, completion: @escaping (Product) -> Void) {
        if let url = URL(string: reviewsURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let product = self.parseReviewJSON(reviewData: safeData) {
                        completion(product)
                    }
                }
            }
            task.resume()
        }
    }
    
    internal func parseReviewJSON(reviewData: Data) -> Product? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Product.self, from: reviewData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
