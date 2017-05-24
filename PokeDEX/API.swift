//
//  API.swift
//  PokeDEX
//
//  Created by Kordian Ledzion on 24.05.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Alamofire

enum Endpoint {
    case getAllPokemons
    
    var url: String {
        switch self {
        case .getAllPokemons:
            return "pokemon/?limit=10"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAllPokemons:
            return .get
        }
    }
}

final class API {
    static let baseURL = URL(string: "http://pokeapi.co/api/v2/")
    
    class func request(_ endpoint: Endpoint, completion: @escaping (((Bool), [String: Any]?) -> Void)) {
        guard let url = URL(string: endpoint.url, relativeTo: API.baseURL) else { fatalError() }
        
        switch endpoint {
        case .getAllPokemons:
            let request = try! URLRequest(url: url, method: endpoint.method)
            Alamofire.request(url, method: endpoint.method, parameters: nil).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let valueDictionary = value as? [String: Any] else { return }
                    print("Fetch Complete")
                    completion(true, valueDictionary)
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
        }
    }
}
