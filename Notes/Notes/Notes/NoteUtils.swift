//
//  NoteUtils.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 14/11/2023.
//

import UIKit

class NoteUtils: NSObject {
    static let userDefaults = UserDefaults.standard
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static func save(note: Note) -> Bool {
        var list = get()
        if let current = get(id: note.id) {
            for (i, v) in list.enumerated() {
                if v.id == current.id {
                    list[i] = note
                }
            }
            return save(notes: list)
        } else {
            list += [note]
            return save(notes: list)
        }
    }
    
    static func save(notes: [Note]) -> Bool {
        if let data = try? encoder.encode(notes) {
            userDefaults.set(data, forKey: "notes_list")
            return true
        }
        return false
    }
    
    static func get(id: String) -> Note? {
        return get().filter { note in
            note.id == id
        }.first
    }
    
    static func get() -> [Note] {
        if let data = userDefaults.object(forKey: "notes_list") as? Data {
            if let list = try? decoder.decode([Note].self, from: data) {
                return list
            }
        }
        let list = [Note]()
        return list
    }
    
    static func remove(note: Note) -> Bool {
        var list = get()
        list.removeAll { item in
            item.id == note.id
        }
        return save(notes: list)
    }
}
