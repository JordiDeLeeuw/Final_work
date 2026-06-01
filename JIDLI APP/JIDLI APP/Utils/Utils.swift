//
//  Utils.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 31/05/2026.
//
//

import Foundation

// voorkomt crashes (index out of range) als er een pagina of item gezocht wordt dat niet bestaat
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
