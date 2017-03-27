//
//  CsvParser.swift
//  DataPackage
//
//  Created by Mac Mini on 3/25/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

// Convenience class, assumes defaults
//
// let data = CSV.load("data/gdp.csv")
// let ok   = CSV.save(data, path: "data/gdp2.csv")
//
public class CSV {
    public static var parser = CsvParser()
    
    public static func load(_ path: String) -> Dataset {
        return CSV.parser.load(path: path)
    }
    
    public static func load(url: URL) -> Dataset {
        return CSV.parser.load(path: url.path)
    }

    @discardableResult
    public static func save(_ data: Dataset, path: String) -> Bool {
        return CSV.parser.save(data, path: path)
    }
    

}


// Parser class, options can be changed
//
// Use:
//    let parser = CsvParser()
//    parser.cellSeparator = "|"
//    let data = parser.load(file: "data/gdp.csv")
//
public class CsvParser {
    var lineEnd       : Character = "\n"
    var cellSeparator : Character = ","
    var textEncloser  : Character = "\""
    var escapeChar    : Character = "\\"
    var replaceChar   : [Character: Character] = ["\\":"\\", "\"":"\"", "n":"\n", "t":"\t", ",":","]
    
    public func load(path: String) -> [[Any]] {
        let text = (try? String.init(contentsOfFile: path)) ?? ""
        let data = self.parse(text: text)
        return data
    }
    
    public func parse(text: String) -> [[Any]] {
        guard !text.isEmpty else { return [[""]] }
        
        var rows   = [[Any]]()
        var row    = [Any]()
        var isText = false
        var index  = text.startIndex
        var char: Character? = text[index] // First char
        var value: String = ""
        
        @discardableResult
        func nextChar() -> Bool {
            text.characters.formIndex(after: &index)
            char = (index < text.endIndex ? text[index] : nil)
            return char != nil
        }
        
        func addValue() {
            // Guess type for now but better use schema if available
            let string = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if let integer = Int(string) { row.append(integer) }
            else if let double = Double(string) { row.append(double) }
            else { row.append(string) }
        }
        
        while index < text.endIndex {
            if char == escapeChar {
                guard nextChar() else { break }
                let escaped = replaceChar[char!] ?? char!
                value.append(escaped)
            } else if char == textEncloser {
                isText = !isText  // First time open, second time close
            } else if char == cellSeparator && !isText {
                addValue()
                value = ""
            } else if char == lineEnd && !isText {
                addValue()
                rows.append(row)
                row = [Any]()
                value = ""
            } else {
                value.append(char!)
            }
            
            nextChar()
        }
        
        return rows
    }
    
    @discardableResult
    public func save(_ data: Dataset, path: String) -> Bool {
        let first = data[0]             // first row
        let last  = first.count - 1     // last cell, used for separators
        if last < 1 { print("CSV.empty"); return false }

        var ok = true
        var text = ""

        for row in data {
            for (index, cell) in row.enumerated() {
                let value = "\(cell)".replacingOccurrences(of: ",", with: "\\,")
                text += value
                if index < last {
                    text.append(cellSeparator)
                }
            }
            text.append(lineEnd)
        }
        
        do {
            try text.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            print("CSV.save.error: ", error)
            ok = false
        }
        return ok
    }
}


// End
