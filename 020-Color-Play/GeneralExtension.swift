//
//  GeneralExtension.swift
//  018-My-Framework
//
//  Created by Audrey Li on 4/24/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    func screenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

public extension UIViewController {
    @IBAction public func unwindToViewController (sender: UIStoryboardSegue){}
}




 extension Array {
    
    func reverseColumns(columns: Int) -> Array {
        let rows = self.count / columns
        var tempArr:[Array] = [[]]
        for r in 0..<rows {
            let subArr: Array = Array(self[(r * columns)..<(columns * r + columns)])
            tempArr.append(subArr)
        }
        
        return tempArr.reverse().flatten()
    }

    /**
    Flattens a nested Array self to an array of OutType objects.
    
    :returns: Flattened array
    */
    func flatten <OutType> () -> [OutType] {
        var result = [OutType]()
        let reflection = reflect(self)
        
        for i in 0..<reflection.count {
            result += Ex.bridgeObjCObject(reflection[i].1.value) as [OutType]
        }
        
        return result
    }
    
    
    /**
    Costructs an array removing the duplicate values in self
    if Array.Element implements the Equatable protocol.
    
    :returns: Array of unique values
    */
    func unique <T: Equatable> () -> [T] {
        var result = [T]()
        
        for item in self {
            if !result.contains(item as T) {
                result.append(item as T)
            }
        }
        
        return result
    }
    
     func random() -> Element {
        let randomIndex = Int.random(self.count)
        return self[randomIndex]
    }
    
    func contains <T: Equatable> (items: T...) -> Bool {
        return items.all { self.indexOf($0) >= 0 }
    }
    
     func all (test: (Element) -> Bool) -> Bool {
        for item in self {
            if !test(item) {
                return false
            }
        }
        
        return true
    }
    func indexOf <U: Equatable> (item: U) -> Int? {
        if item is Element {
            return Swift.find(unsafeBitCast(self, [U].self), item)
        }
        
        return nil
    }
    
    
    func containsElement<T : Equatable>(obj: T) -> Bool {
        let filtered = self.filter {$0 as? T == obj}
        return filtered.count > 0
    }
    
    // re-arrange index from 123456 to 142356  or 123456789 to 147258369
    func shiftOrder(columns: Int) -> Array {
        
        if self.count % columns == 0 {
            var rows = self.count / columns
            var arr = Array()
            
            for var c = 0 ; c < columns ; c++ {
                for var r = 0; r < rows ; r++ {
                    arr.append(self[c + r * columns])
                }
            }
            return arr
            
        }else {
            return self
        }
        
    }
    
    // delete all the items in self that are equal to element
   mutating func remove <U: Equatable> (element: U) {
        let anotherSelf = self
        
        removeAll(keepCapacity: true)
        
        anotherSelf.each {
            (index: Int, current: Element) in
            if current as U != element {
                self.append(current)
            }
        }
    }
    
    //  Iterates on each element of the array with its index.
    func each (call: (Int, Element) -> ()) {
        
        for (index, item) in enumerate(self) {
            call(index, item)
        }
        
    }
    // Randomly rearranges the elements of self using the Fisher-Yates shuffle
    mutating func shuffle () {
        
        for var i = self.count - 1; i >= 1; i-- {
            let j = Int.random(i)
            swap(&self[i], &self[j])
        }
        
    }
   func shuffled () -> Array {
        var shuffled = self
        
        shuffled.shuffle()
        
        return shuffled
    }
}


public extension NSDate {
    public func getDateString() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        //let timeZone = NSTimeZone(name: "UTC")
        
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        return dateFormatter.stringFromDate(self)
    }
}

public extension CGFloat {
    
   public func fromUnitToPoint(unit: Unit) -> CGFloat{
        return self * unit.rawValue
    }
    public func fromPointToUnit(unit: Unit) -> CGFloat{
        return self / unit.rawValue
    }
}

public extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}




 extension Dictionary {
    
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        var array = Array(self.keys)
        sort(&array, isOrderedBefore)
        return array
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        var array = Array(self)
        sort(&array) {
            let (lk, lv) = $0
            let (rk, rv) = $1
            return isOrderedBefore(lv, rv)
        }
        return array.map {
            let (k, v) = $0
            return k
        }
    }
    /**
    Checks if a key exists in the dictionary.
    
    :param: key Key to check
    :returns: true if the key exists
    */
    func has (key: Key) -> Bool {
        return indexForKey(key) != nil
    }
    
    /**
    Creates an Array with values generated by running
    each [key: value] of self through the mapFunction.
    :param: mapFunction
    :returns: Mapped array
    */
    func toArray <V> (mapFunction map: (Key, Value) -> V) -> [V] {
        
        var mapped = [V]()
        
        each {
            mapped.append(map($0, $1))
        }
        
        return mapped
        
    }
    
    func each(each: (Key, Value) -> ()) {
        
        for (key, value) in self {
            each(key, value)
        }
        
    }
    
    /**
    Constructs a dictionary containing every [key: value] pair from self
    for which testFunction evaluates to true.
    
    :param: testFunction Function called to test each key, value
    :returns: Filtered dictionary
    */
    func filter (testFunction test: (Key, Value) -> Bool) -> Dictionary {
        
        var result = Dictionary()
        
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        
        return result
        
    }
    
//    func intersection <K, V where K: Equatable, V: Equatable> (dictionaries: [K: V]...) -> [K: V] {
//        
//        //  Casts self from [Key: Value] to [K: V]
//        let filtered = mapFilter { (item, value) -> (K, V)? in
//            if (item is K) && (value is V) {
//                return (item as K, value as V)
//            }
//            
//            return nil
//        }
//    }
//    
    /**
    Creates a Dictionary with keys and values generated by running
    each [key: value] of self through the mapFunction discarding nil return values.
    
    :param: mapFunction
    :returns: Mapped dictionary
    */
    func mapFilter <K, V> (map: (Key, Value) -> (K, V)?) -> [K: V] {
        
        var mapped = [K: V]()
        
        each {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        
        return mapped
        
    }
    
    
    
    //    func pick (keys: [Key]) -> Dictionary {
    //        return filter { (key: Key, _) -> Bool in
    //            return keys.contains(key)
    //        }
    //    }
    
    /**
    Returns a copy of self, filtered to only have values for the whitelisted keys.
    
    :param: keys Whitelisted keys
    :returns: Filtered dictionary
    */
    //    func pick (keys: Key...) -> Dictionary {
    //        return pick(unsafeBitCast(keys, [Key].self))
    //    }
    //
    //    /**
    //    Returns a copy of self, filtered to only have values for the whitelisted keys.
    //
    //    :param: keys Keys to get
    //    :returns: Dictionary with the given keys
    //    */
    //    func at (keys: Key...) -> Dictionary {
    //        return pick(keys)
    //    }
    
    /**
    Removes a (key, value) pair from self and returns it as tuple.
    If the dictionary is empty returns nil.
    
    :returns: (key, value) tuple
    */
    mutating func shift () -> (Key, Value)? {
        if let key = keys.first {
            return (key, removeValueForKey(key)!)
        }
        
        return nil
    }
    
    func difference <V: Equatable> (dictionaries: [Key: V]...) -> [Key: V] {
        
        var result = [Key: V]()
        
        each {
            if let item = $1 as? V {
                result[$0] = item
            }
        }
        
        //  Difference
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValueForKey(key)
                }
            }
        }
        
        return result
        
    }

}

/**
Difference operator
*/
public func - <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.difference(second)
}

/**
Intersection operator
*/
//public func & <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
//    return first.intersection(second)
//}

///**
//Union operator
//*/
//public func | <K: Hashable, V> (first: [K: V], second: [K: V]) -> [K: V] {
//    return first.union(second)
//}
