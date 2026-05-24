//
//  DataLoader.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
import Foundation

func loadStoryData() -> [String: [StoryPage]] {
    guard let url = Bundle.main.url(forResource: "story_data", withExtension: "json") else {
        print("Fout: story_data.json niet gevonden in de app bundle.")
        return [:]
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        // dit laadt de json
        return try decoder.decode([String: [StoryPage]].self, from: data)
    } catch {
        print("Fout bij het parsen van JSON-data: \(error)")
        return [:]
    }
}
