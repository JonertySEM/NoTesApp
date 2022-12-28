//
//  addNewNoteController.swift
//  shiftProjectNotes
//
//  Created by Семён Алимпиев on 26.12.2022.
//

import UIKit
import CoreData

class AddNewNoteController: UIViewController {

    @IBOutlet weak var textTitleNote: UITextField!
    @IBOutlet weak var textNote: UITextView!
    
    var selectedNote: Note? = nil
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedNote != nil){
            textTitleNote.text = selectedNote?.title
            textNote.text = selectedNote?.desc
        }
    }
    
    
    @IBAction func addNewNote(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = NoteList.count as NSNumber
            newNote.title = textTitleNote.text
            newNote.desc = textNote.text
            do
            {
                try context.save()
                NoteList.append(newNote)
                navigationController?.popViewController(animated: true)
                print(NoteList)
            }
            catch
            {
                print("context save error")
            }
        }
        else //edit
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == selectedNote)
                    {
                        note.title = textTitleNote.text
                        note.desc = textNote.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Failed edit")
            }
        }
        
       
    }
    
    
    @IBAction func closeNote(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func deleteButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let note = result as! Note
                if(note == selectedNote)
                {
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
