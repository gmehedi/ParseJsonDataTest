//
//  String+Extension.swift
//  ParseJsonFromUrlTest
//
//  Created by Mehedi on 5/6/21.
//

import UIKit

extension String {
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
