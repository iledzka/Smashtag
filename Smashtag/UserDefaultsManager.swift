//
//  UserDefaultsManager.swift
//  Smashtag
//
//  Created by Iza Ledzka on 14/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class UserDefaultsManager {
    private static let defaults = UserDefaults.standard
    
    private static var array = [String]()
    
    static func addSearch(_ string: String){
        if array.count >= 100 {
            array.removeFirst()
        }
        array.append(string)
        defaults.set(array, forKey: "searches")
    }
    
    static var searches: [String]{
        get {
            return (defaults.array(forKey: "searches") as! [String]).unique()
        }
    }
}

//helper function to filter for duplicates while keeping the order
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
