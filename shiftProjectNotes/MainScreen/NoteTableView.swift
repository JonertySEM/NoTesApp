//
//  ViewController.swift
//  shiftProjectNotes
//
//  Created by Семён Алимпиев on 26.12.2022.
//
import UIKit
import CoreData


var NoteList = [Note]()



class NoteTableView: UITableViewController {
    
    var firstLoadData = true
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        
        for note in NoteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    override func viewDidLoad() {
        if(firstLoadData){
            firstLoadData = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    NoteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! TableViewCell
    
        
        let thisNote: Note!
        thisNote = nonDeletedNotes()[indexPath.row]

        cell.textTitle?.text = thisNote.title
        cell.textContent?.text = thisNote.desc
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? AddNewNoteController
            
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}




