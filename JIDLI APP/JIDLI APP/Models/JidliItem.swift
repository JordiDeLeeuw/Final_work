//
//  JidliItem.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
import Foundation

struct JidliItem: Identifiable, Codable {
    let id: String         // Dit is de naam van de idol (bv. "depimi", "jiroh")
    let status: String     // "unlocked" of "locked"
    let explored: Double   // Percentage voortgang uit Firestore (bv. 0.0 tot 100.0)
    
    // Handige industry-level logica: de View hoeft dit nu niet zelf te berekenen!
    var exploredPages: Int {
        let totalPages = 18.0
        return Int((explored / 100.0 * totalPages).rounded())
    }
    
    var isUnlocked: Bool {
        status != "locked"
    }
}
