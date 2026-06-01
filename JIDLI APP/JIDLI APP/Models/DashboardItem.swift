//
//  DashboardItem.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  datamodel voor de weergave in de UI
//

import Foundation

struct DashboardItem: Identifiable {
    let id: String
    let title: String
    // UI states
    let explored: Int      // aantal gelezen pagina's
    let total: Int         //vaste waarde voor het totaal aantal paginas
    let unlocked: Bool     //bepaalt of een kaart klikbaar is
}
