//
//  NumberFormatterCache.swift
//  Jams
//
//  Created by Jaja Yting on 10/12/21.
//

import Foundation

final class NumberFormatterCache {
    
    public static let sharedInstance = NumberFormatterCache()
    
    public let numberFormatter: NumberFormatter
    
    private init() {
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.minimumFractionDigits = 2
        self.numberFormatter.maximumFractionDigits = 2
    }
}
