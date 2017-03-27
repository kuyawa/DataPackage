//
//  DataTable.swift
//  DataPackage
//
//  Created by Mac Mini on 3/26/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

// Ref: github/evgenyneu/SigmaSwiftStatistics
// TODO: Count, Sum, Avg, Mean, Median, Mode, Variance, StdDev, Skewness, Kurtosis
// TODO: Count for not null, count for value = X

public class DataTable {
    public var data = Dataset()
    
    public init(data: Dataset) {
        self.data = data
    }
    
    public func find(col: Int, value: Any) -> (Bool, Int) {
        let notFound = (false, -1)
        guard col > -1 && col < data.count else { return notFound }

        for (index, row) in data.enumerated() {
            // Check string, int, double
            if String(describing: row[col]) == String(describing: value) {
                return (true, index)
            }
        }

        return notFound
    }
    
    public func sum(col: Int, from: Int = 0, to: Int = 0) -> Double {
        guard col > -1 && col < data.count else { return 0.0 }
        
        // Limit and offset
        var start = from
        var limit = to
        
        if start < 0 { start = 0 }
        if limit < 0 { limit = data.count - limit }  // Negative to, starts from end
        if limit == 0 || limit >= data.count { limit = data.count-1 }
        
        var sum = 0.0
        
        for (index, row) in data.enumerated() {
            if start ... limit ~= index {
                sum += (row[col] as? Double) ?? 0.0
            }
        }
        
        return sum
    }

    public func avg(col: Int, from: Int = 0, to: Int = 0) -> Double {
        guard col > -1 && col < data.count else { return 0.0 }
        
        // Limit and offset
        var start = from
        var limit = to
        
        if start < 0 { start = 0 }
        if limit < 0 { limit = data.count - limit }  // Negative to, starts from end
        if limit == 0 || limit >= data.count { limit = data.count-1 }
        
        var sum = 0.0
        let cnt = Double(data.count)
        
        for (index, row) in data.enumerated() {
            if start ... limit ~= index {
                sum += (row[col] as? Double) ?? 0.0
            }
        }
        
        let avg = sum / cnt
        
        return avg
    }
}
