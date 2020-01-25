//
//  UrlSessionHandler.swift
//  NetworkManager
//
//  Created by oren shalev on 24/01/2020.
//  Copyright © 2020 oren shalev. All rights reserved.
//

import Foundation

class UrlSessionHandler : NSObject, URLSessionTaskDelegate {
   
    var redirectsAmount : Int = 0
    var success : (String) -> ()
    var failure: (Error) -> ()
    var numberOfredirects: (Int) -> ()
    
    init(success:  @escaping (String) -> (), failure: @escaping (Error) -> (), numberOfredirects: @escaping (Int) -> ()) {
        self.success = success
        self.failure = failure
        self.numberOfredirects = numberOfredirects
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        redirectsAmount += 1

        if passedAmountOfAllowedRedirects() {
            
            self.removeUrlSessionHandlerForUrl(urlString: request.url!.absoluteString)
            return
        }
        
        let task = session.dataTask(with: request.url!) { [unowned self] (data, response, error) in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print("redirect data: \(str)")

            }

            if let error = error {
                print("netwirk request error: \(error)")
                self.failure(error)
            } else {
                if let response = response as? HTTPURLResponse, let data = data{
                    print("statusCode: \(response.statusCode)")
                    let str = String(decoding: data, as: UTF8.self)
                    self.numberOfredirects(self.redirectsAmount)

                    self.success(str)
                }

            }
            
            self.removeUrlSessionHandlerForUrl(urlString: request.url!.absoluteString)
        }
        task.resume()
        
    }
    
    func passedAmountOfAllowedRedirects() -> Bool {
        
        let maxAmountOfRedirects = NetworkManager.options.maxAmountOfRedirects

        if redirectsAmount > maxAmountOfRedirects {
            let error = NSError(domain: "com.test.app", code: 1122, userInfo: ["error text":"redirects more than allowed"])
            failure(error)
            numberOfredirects(redirectsAmount)
            
            return true
        }
            
        else { return false }
    }
    
    func removeUrlSessionHandlerForUrl(urlString: String)  {
        NetworkManager.sessionHandlers[urlString] = nil
    }
    
}
