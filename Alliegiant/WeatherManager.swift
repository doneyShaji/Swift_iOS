import Foundation

struct WeatherManager {
    var titles: [String] = []
    
    mutating func fetchData(completion: @escaping ([String]) -> Void) {
        let weatherURL = "https://dummyjson.com/products"
        performRequest(weatherURL: weatherURL, completion: completion)
    }
    
    private func performRequest(weatherURL: String, completion: @escaping ([String]) -> Void) {
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
                    if let titles = self.parseJSON(weatherData: safeData) {
                        completion(titles)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    private func parseJSON(weatherData: Data) -> [String]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
            let titles = decodedData.products.map { $0.title }
            return titles
        } catch {
            print(error)
            return nil
        }
    }
}

//
//
//
//import Foundation
//
//struct WeatherManager {
//    var titles: [String] = []
//    func fetchData(){
//        let weatherURL = "https://dummyjson.com/products"
//        print (weatherURL)
//        performRequest(weatherURL: weatherURL)
//    }
//    
//    func performRequest(weatherURL: String) {
//        // 1. Create a URL
//        if let url = URL(string: weatherURL) {
//            
//            // 2. Create a URLSession
//            let session = URLSession(configuration: .default)
//            
//            // 3. Give the session a task
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                
//                if let safeData = data {
////                    let dataString = String(data: safeData, encoding: .utf8)
////                    print(dataString!)
//                    self.parseJSON(weatherData: safeData)
//                }
//            }
//            
//            // 4. Start the task
//            task.resume()
//        }
//    }
//    
//    func parseJSON(weatherData: Data) {
//        
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(ProductResponse.self, from: weatherData)
//            for product in decodedData.products {
////
//                print(titles)
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
