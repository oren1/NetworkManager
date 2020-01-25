//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by oren shalev on 21/01/2020.
//  Copyright © 2020 oren shalev. All rights reserved.
//

import Foundation

public class NetworkManager {
    public static  var options = NetworkOptions()
    static internal var sessionHandlers : [String: UrlSessionHandler] = [:]
    
    
    static public func getRequest(urlString: String,params: [String: String]? = [:] ,
                                success: @escaping (String) -> (),
                                failure: @escaping (Error) -> (),
                                numberOfredirects: @escaping (Int) -> ())  {
           
        
        
        guard let params = params else { return }
    
         var components = URLComponents(string: urlString)!
         var queryItems : [URLQueryItem] = []
         
         // loop trough the params and add it to the path component
         for (key,value) in params {
             queryItems.append(URLQueryItem(name: key, value: value))
         }
         
         components.queryItems = queryItems
         components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: " ", with: "%2B")
         

        
        let config = URLSessionConfiguration.default
    
        let urlSessionHandler = UrlSessionHandler(success: success, failure: failure, numberOfredirects: numberOfredirects)
        
        self.sessionHandlers[urlString] = urlSessionHandler
    
        let session = URLSession(configuration: config, delegate: urlSessionHandler, delegateQueue: nil)
       
        let task = session.dataTask(with: components.url!) { (data, response, error) in
            if let error = error {
                failure(error)
                numberOfredirects(0)

            } else {
                if let _ = response as? HTTPURLResponse, let data = data{
                    let str = String(decoding: data, as: UTF8.self)
                            success(str)
                            numberOfredirects(0)
                
                }

            }
        }
        task.resume()

     
     }
    
    

    
}






