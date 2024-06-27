import Foundation

struct WeatherManager {
    var titlesAndThumbnails: [(title: String, thumbnail: String, description: String)] = []
    
    func fetchData(completion: @escaping ([(String, String, String)]) -> Void) {
        let categories = ["womens-shoes", "womens-bags","womens-dresses","mens-shirts","mens-shoes"]
        var combinedResults: [(String, String, String)] = []
        let dispatchGroup = DispatchGroup()
        
        for category in categories {
            dispatchGroup.enter()
            let weatherURL = "https://dummyjson.com/products/category/\(category)"
            performRequest(weatherURL: weatherURL) { result in
                if let result = result {
                    combinedResults.append(contentsOf: result)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(combinedResults)
        }
    }
    
    private func performRequest(weatherURL: String, completion: @escaping ([(String, String, String)]?) -> Void) {
        if let url = URL(string: weatherURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    completion(nil)
                    return
                }
                
                if let safeData = data {
                    if let titlesAndThumbnails = self.parseJSON(weatherData: safeData) {
                        completion(titlesAndThumbnails)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    private func parseJSON(weatherData: Data) -> [(String, String, String)]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
            let titlesAndThumbnails = decodedData.products.map { ($0.title, $0.thumbnail, $0.description) }
            return titlesAndThumbnails
        } catch {
            print(error)
            return nil
        }
    }
}
