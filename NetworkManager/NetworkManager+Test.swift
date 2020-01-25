//
//  NetworkManager+Test.swift
//  NetworkManager
//
//  Created by oren shalev on 24/01/2020.
//  Copyright © 2020 oren shalev. All rights reserved.
//

import Foundation

extension NetworkManager {
    
    public static  func testRedirectForURL(urlString: String,
    responseClosure: @escaping (String) -> (),
    errClosure: @escaping (Error) -> (),
    numberOfredirectsClosure: @escaping (Int) -> ())  {
      
        
        getRequest(urlString: urlString,
                   success: responseClosure,
                   failure: errClosure,
                   numberOfredirects: numberOfredirectsClosure)
            
    }
    
}
