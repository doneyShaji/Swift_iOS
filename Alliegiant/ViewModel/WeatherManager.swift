import Foundation

struct WeatherManager {
    var titlesAndThumbnails: [(title: String, thumbnail: String, description: String)] = []
    
    func fetchData(completion: @escaping ([(String, String, String)]) -> Void) {
//        let weatherURL = "https://dummyjson.com/products/category/mobile-accessories"
        let weatherURL = "https://dummyjson.com/products/category/kitchen-accessories"
        performRequest(weatherURL: weatherURL, completion: completion)
    }
    
    private func performRequest(weatherURL: String, completion: @escaping ([(String, String, String)]) -> Void) {
        // 1. Create a URL
        if let url = URL(string: weatherURL) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let titlesAndThumbnails = self.parseJSON(weatherData: safeData) {
                        completion(titlesAndThumbnails)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    private func parseJSON(weatherData: Data) -> [(String, String, String)]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
                       
                       // Create an array to store tuples of title and thumbnail
                       let titlesAndThumbnails = decodedData.products.map { ($0.title, $0.thumbnail, $0.description) }
                       
                       // Print the stored product details
                       for detail in titlesAndThumbnails {
                           print("Title: \(detail.0), Thumbnail: \(detail.1), Thumbnail: \(detail.2)")
                       }
                       
                       return titlesAndThumbnails
        } catch {
            print(error)
            return nil
        }
    }
}
