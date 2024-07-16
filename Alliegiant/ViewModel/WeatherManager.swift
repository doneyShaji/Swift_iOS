import Foundation

struct WeatherManager: WeatherManagerProtocol {
    func fetchData(for category: String, completion: @escaping ([(String, String, String, Double, String)]) -> Void) {
        let weatherURL = "https://dummyjson.com/products/category/\(category)"
        performRequest(weatherURL: weatherURL, completion: completion)
    }

    internal func performRequest(weatherURL: String, completion: @escaping ([(String, String, String, Double, String)]) -> Void) {
        if let url = URL(string: weatherURL) {
            let session = URLSession(configuration: .default)
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
            task.resume()
        }
    }

    internal func parseJSON(weatherData: Data) -> [(String, String, String, Double, String)]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
            let titlesAndThumbnails = decodedData.products.map { ($0.title, $0.thumbnail, $0.description, $0.price, $0.brand) }
            return titlesAndThumbnails
        } catch {
            print(error)
            return nil
        }
    }
}
