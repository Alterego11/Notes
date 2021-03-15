//
//  CoreDataHelper.swift
//  Notes
//
//  Created by Антон Белый on 14.03.2021.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        return context
    }
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        return note
    }
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save\(error.localizedDescription)")
        }
    }
    static func delete(note: Note) {
            context.delete(note)
            saveNote()
        }
    static func retrieveNotes() -> [Note] {
            do {
                let fetchReques = NSFetchRequest<Note>(entityName: "Note")
                let results = try context.fetch(fetchReques)
                return results
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                return []
        }
    }
}
