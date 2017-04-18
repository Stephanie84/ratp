//
//  NetworkManager.swift
//  wherMaTrain
//
//  Created by etudiant01 on 07/04/2017.
//  Copyright © 2017 vivien. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias ServiceResponse = ((JSON?, Error?) -> Void)
class NetworkManager {
    
    
    static let sharedInstance = NetworkManager()
    fileprivate init() {}
    
    
    func getSchedulesForStation(station: String, linenumber: String, direction: String, completion: @escaping ServiceResponse)        {
        
        let headers = [
            "Accept": "application/json"
        ]
        let escapedStation = station.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let escapedStations = escapedStation.folding(options: .diacriticInsensitive, locale: .current)
        let finalEndPoint = Params.baseEndPoint+Params.schedules+"/"+Params.metros+"/"+linenumber+"/"+escapedStations+"/"+direction
        print("EndPoint : \(finalEndPoint)")
        Alamofire.request(finalEndPoint, method: .get, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("DATA \(json)")
                    completion(json, nil)
                }
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}


