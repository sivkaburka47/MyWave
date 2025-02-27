//
//  String+Extensions.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 27.02.2025.
//

import Foundation

extension String {
    static var empty: String {
        return SC.empty
    }
    
    static var space: String {
        return SC.space
    }
    
    static var dash: String {
        return SC.dash
    }
}

typealias SC = StringConstants
enum StringConstants {
    
    static let empty = ""
    static let space = " "
    static let dash = "-"
}
