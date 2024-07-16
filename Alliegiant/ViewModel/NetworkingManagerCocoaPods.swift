//
//  NetworkingManagerCocoaPods.swift
//  Alliegiant
//
//  Created by P10 on 24/06/24.
//

import Foundation
import Alamofire


class NetworkingManagerCocoaPods{
    
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    func execute(_ url: URL, completion: @escaping WebServiceResponse){
        AF.request(url).validate().responseJSON { response in
            switch response.result {
                        case .success(let value):
                            if let jsonArray = value as? [[String: Any]] {
                                completion(jsonArray, nil)
                            } else if let jsonDict = value as? [String: Any] {
                                completion([jsonDict], nil)
                            } else {
                                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                            }
                        case .failure(let error):
                            completion(nil, error)
                        }
        }
    }
}
