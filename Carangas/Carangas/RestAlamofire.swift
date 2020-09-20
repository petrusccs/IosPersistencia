//
//  RestAlamofire.swift
//  Carangas
//
//  Created by Petrus Souza on 16/09/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire

class RESTAlamofire {

    // URL principal do servidor que obtem os dados dos carros cadastrados la
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
    
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration)
    
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 15.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard URL(string: basePath) != nil else {
            onError(.url)
            return
        }
        
        AF.request(basePath).response { response in
            
            do{
                if response.data == nil {
                    onError(.noData)
                    return
                }
                
                if let error = response.error{
                    if error.isSessionTaskError || error.isInvalidURLError{
                        onError(.url)
                        return
                    }
                    if error._code == NSURLErrorTimedOut{
                        onError(.noResponse)
                    }else if error._code != 200{
                        onError(.responseStatusCode(code: error._code))
                    }
                }
                
                let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                onComplete(cars)
                
            }catch is DecodingError{
                onError(.invalidJSON)
            }catch{
                onError(.taskError(error: error))
            }
        }
    }
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
            
    class func update(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        
        // o endpoint do servidor para update é: URL/id
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        
        var httpMethod: HTTPMethod = .get
        
        switch operation {
        case .delete:
            httpMethod = .delete
        case .save:
            httpMethod = .post
        case .update:
            httpMethod = .put
        }
        
        guard (try? JSONEncoder().encode(car)) != nil else {
            onError(.invalidJSON)
            return
        }
        
        AF.request(url, method: httpMethod, parameters: car, encoder: JSONParameterEncoder.default).response { response in
            
        do{
            if let error = response.error{
                if error.isSessionTaskError || error.isInvalidURLError{
                    onError(.taskError(error: response.error!))
                    return
                }
                if error._code == NSURLErrorTimedOut{
                    onError(.noResponse)
                }else if error._code != 200{
                    onError(.responseStatusCode(code: response.response!.statusCode))
                }
            }

            onComplete(true)
            
        }catch{
             onError(.taskError(error: response.error!))
        }
        
    }
  }
    
    
    // o metodo pode retornar um array de nil se tiver algum erro
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard URL(string: urlFipe) != nil else {
            onError(.url)
            return
        }
        
        AF.request(urlFipe).response { response in
            
            do{
                if response.data == nil {
                    onError(.noResponse)
                    return
                }
                
                if let error = response.error{
                    if error.isSessionTaskError || error.isInvalidURLError{
                        onError(.taskError(error: response.error!))
                        return
                    }
                    if error._code == NSURLErrorTimedOut{
                        onError(.noResponse)
                    }else if error._code != 200{
                        onError(.responseStatusCode(code: response.response!.statusCode))
                    }
                }
                
                let brands = try JSONDecoder().decode([Brand].self, from: response.data!)
                onComplete(brands)
                
            }catch is DecodingError{
                onError(.invalidJSON)
            }catch{
                onError(.taskError(error: response.error!))
            }
        }
    }
        
}
