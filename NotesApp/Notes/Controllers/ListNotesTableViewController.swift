//
//  ListNotesTableViewController.swift
//  Notes
//
//  Created by Антон Белый on 08.03.2021.
//

import UIKit

class ListNotesTableViewController: UITableViewController {

    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
        
        //Change Navigation Bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Rounded", size: 30) ?? UIFont.systemFont(ofSize: 20)]
    }
        
    // MARK: - Cell

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! ListNotesTableViewCell
        let note = notes[indexPath.row]
        cell.noteTitle.text = note.title
        
        // Format Date to String
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        let formatedDate = formatter.string(from: note.modificationTime!)
        cell.noteTime.text = formatedDate
        
        return cell
    }
    // Delete notes
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayNote":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            let destination = segue.destination as! DisplayNoteViewController
            destination.note = note
        case "addNote":
            print("Добавление новой заметки")
        default:
            print("Ничего не выбрано")
        }
        
    }
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        notes = CoreDataHelper.retrieveNotes()
    }
}

