//
//  Options.swift
//  NetworkManager
//
//  Created by oren shalev on 21/01/2020.
//  Copyright © 2020 oren shalev. All rights reserved.
//

import Foundation

public class NetworkOptions {
    public var maxAmountOfRedirects : Int
    
    init() {
        maxAmountOfRedirects = 2
    }
    
    
    init(maxAmountOfRedirects: Int) {
        self.maxAmountOfRedirects = maxAmountOfRedirects

    }
}
