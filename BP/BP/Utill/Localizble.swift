//
//  Localizble.swift
//  BP
//
//  Created by Ehab Hakami on 29/05/1443 AH.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizble", bundle: .main, value: self, comment: self)
    }
}
