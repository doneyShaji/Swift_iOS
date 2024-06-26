import Foundation

struct WeatherManager {
    func fetchData(for category: String, completion: @escaping ([(String, String, String)]) -> Void) {
        let weatherURL = "https://dummyjson.com/products/category/\(category)"
        performRequest(weatherURL: weatherURL, completion: completion)
    }

    private func performRequest(weatherURL: String, completion: @escaping ([(String, String, String)]) -> Void) {
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
