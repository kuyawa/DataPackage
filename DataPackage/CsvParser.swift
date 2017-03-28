//
//  CsvParser.swift
//  DataPackage
//
//  Created by Mac Mini on 3/25/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

// Convenience class, assumes defaults
public class CSV {
    public static var parser = CsvParser()
    
    // let data = CSV.load("data/gdp.csv")
    public static func load(_ path: String) -> Dataset {
        return parser.load(path: path)
    }
    
    // let data = CSV.load(url: URL(string: "data/gdp.csv"))
    public static func load(url: URL) -> Dataset {
        return parser.load(path: url.path)
    }

    // let ok = CSV.save(data, path: "data/gdp.csv")
    @discardableResult
    public static func save(_ data: Dataset, path: String) -> Bool {
        return parser.save(data, path: path)
    }

    // let reader = CSV.reader(path: "data/gdp.csv")
    // for line in reader {
    //     print(line)
    // }
    public static func reader(path: String) -> CsvParser {
        parser.open(path: path)
        return parser
    }
}


// Parser class, default options can be changed
//
// Use:
//    let parser = CsvParser()
//    parser.cellSeparator = "|"
//    let data = parser.load(file: "data/gdp.csv")
//
public class CsvParser: Sequence {
    var lineEnd       : Character = "\n"
    var cellSeparator : Character = ","
    var textEncloser  : Character = "\""
    var escapeChar    : Character = "\\"
    var replaceChar   : [Character: Character] = ["\\":"\\", "\"":"\"", "n":"\n", "t":"\t", ",":","]
    
    public init() {}
    
    //---- Iterator
    //
    // let parser = CsvParser()
    // parser.open(path: "myfile.csv")
    // for line in parser {
    //     print(line)
    // }
    //
    var file: UnsafeMutablePointer<FILE>!

    // Used to open a file and read line by line with an iterator
    @discardableResult
    public func open(path: String) -> Bool {
        file = fopen(path, "r")
        if file == nil { return false }
        return true
    }
    
    public func close() {
        fclose(file)
    }
    
    deinit {
        close()
    }
    
    // Read line from file, used in iterator
    public var nextLine: [Any]? {
        var line: UnsafeMutablePointer<CChar>? = nil
        var linecap: Int = 0
        defer { free(line) }
        let text: String? = getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
        if text == nil { return nil }
        let data = parseLine(text!)
        return data
    }

    // Parse line of text into fields
    public func parseLine(_ text: String) -> [Any] {
        //guard let text = text else { return nil }
        let row = parse(text: text)
        if let line = row.first { return line }
        return []
    }
  
    // Sequence protocol: iterator
    public func  makeIterator() -> AnyIterator<[Any]> {
        return AnyIterator<[Any]> {
            return self.nextLine
        }
    }

    //---- Parser
    //
    // Reads the whole file at once
    // Useful for small files of less than one GB
    //
    // let parser = CsvParser()
    // let data = parser.load("/Documents/data/gdp.csv")

    // Used for loading the whole file in memory at once
    public func load(path: String) -> [[Any]] {
        let text = (try? String.init(contentsOfFile: path)) ?? ""
        let data = self.parse(text: text)
        return data
    }
    
    public func parse(text: String) -> Dataset {
        guard !text.isEmpty else { return [[""]] }
        
        var rows   = Dataset()
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
