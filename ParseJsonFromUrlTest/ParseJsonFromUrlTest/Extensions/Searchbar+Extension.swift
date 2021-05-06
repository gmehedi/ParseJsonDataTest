//
//  Searchbar+Extension.swift
//  ParseJsonFromUrlTest
//
//  Created by Mehedi on 5/6/21.
//

import UIKit

extension UISearchBar {
    var textField : UITextField{
        return self.value(forKey: "_searchField") as! UITextField
    }
}

