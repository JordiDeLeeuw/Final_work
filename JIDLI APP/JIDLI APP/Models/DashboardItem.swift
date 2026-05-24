//
//  DashboardItem.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
import Foundation

struct DashboardItem: Identifiable {
    let id: String
    let title: String
    let explored: Int      // Aantal gelezen pagina's (klaar voor de UI)
    let total: Int         // Totaal aantal pagina's (altijd 18)
    let unlocked: Bool
}
