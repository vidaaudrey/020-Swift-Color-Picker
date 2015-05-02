//
//  StringExtension.swift
//  011-Country-Information-with-UITableView
//
//  Created by Audrey Li on 4/4/15.
//  Copyright (c) 2015 UIColle. All rights reserved.
//


import Foundation

public extension String {
    
   var length: Int { return countElements(self) }
 //   var length: Int {return self.utf16Count }
    var capitalized: String { return capitalizedString }
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    
//    func explode (separator: Character) -> [String] {
//        return split(self, { (element: Character) -> Bool in
//            return element == separator
//        })
//    }

    subscript (range: Range<Int>) -> String? {
        if range.startIndex < 0 || range.endIndex > self.length {
            return nil
        }
        
        let range = Range(start: advance(startIndex, range.startIndex), end: advance(startIndex, range.endIndex))
        
        return self[range]
    }
    
    func toFloat() -> Float? {
        
        let scanner = NSScanner(string: self)
        var float: Float = 0
        
        if scanner.scanFloat(&float) {
            return float
        }
        
        return nil
        
    }
    
    public func toDouble() -> Double? {
        
        let scanner = NSScanner(string: self)
        var double: Double = 0
        
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
        
    }
    
    func toUInt() -> UInt? {
        if let val = self.trimmed().toInt() {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    func toBool() -> Bool? {
        let text = self.trimmed().lowercaseString
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }
        
        return nil
    }

    func toDateTime(format : String? = "yyyy-MM-dd hh-mm-ss") -> NSDate? {
        return toDate(format: format)
    }
    
    func toDate(format : String? = "yyyy-MM-dd") -> NSDate? {
        let text = self.trimmed().lowercaseString
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.dateFromString(text)
    }
    
    /**
    Inserts a substring at the given index in self.
    
    :param: index Where the new string is inserted
    :param: string String to insert
    :returns: String formed from self inserting string at index
    */
    func insert (var index: Int, _ string: String) -> String {
        //  Edge cases, prepend and append
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        
        return self[0..<index]! + string + self[index..<length]!
    }
    
    
    /**
    Strips whitespaces from the beginning of self.
    
    :returns: Stripped string
    */
    func ltrimmed () -> String {
        return ltrimmed(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
    Strips the specified characters from the beginning of self.
    
    :returns: Stripped string
    */
    func ltrimmed (set: NSCharacterSet) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet) {
            return self[range.startIndex..<endIndex]
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from the end of self.
    
    :returns: Stripped string
    */
    func rtrimmed () -> String {
        return rtrimmed(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
    Strips the specified characters from the end of self.
    
    :returns: Stripped string
    */
    func rtrimmed (set: NSCharacterSet) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
            return self[startIndex..<range.endIndex]
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from both the beginning and the end of self.
    
    :returns: Stripped string
    */
    func trimmed () -> String {
        return ltrimmed().rtrimmed()
    }

    
    
}


