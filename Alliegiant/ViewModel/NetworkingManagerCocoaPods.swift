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
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error{
                completion(nil, error)
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil)
            } else if let jsonDict = response.result.value as? [String: Any]{
                completion([jsonDict], nil)
            }
        }
    }
}
