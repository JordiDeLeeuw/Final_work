//
//  JidliItem.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  model voor de firebase data
//

import Foundation

struct JidliItem: Identifiable, Codable {
    let id: String         // naam van de idol
    let status: String     // "unlocked" of "locked"
    let explored: Double   // percentage voortgang uit de database
    // bereken zodat de view dit niet moet doen
    var exploredPages: Int {
        let totalPages = 18.0
        return Int((explored / 100.0 * totalPages).rounded())
    }
    // checkt of de kaart speelbaar is
    var isUnlocked: Bool {
        status != "locked"
    }
}
