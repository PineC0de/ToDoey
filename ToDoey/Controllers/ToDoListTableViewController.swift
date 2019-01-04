//
//  ViewController.swift
//  ToDoey
//
//  Created by Travis Goins on 12/3/18.
//  Copyright © 2018 Travis Goins. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
          loadItems()
        }
    }
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        realm.delete(todoItems!)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      loadItems()
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
        
    }

    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                  item.done = !item.done
//                    realm.delete(item)
                }
           }catch{
                print("Error saving Checkmark status, \(error)")
            }
        }
        
//       print(itemArray[indexPath.row])
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
        tableView.deselectRow(at: indexPath, animated: true)
//
//        saveItems()
        tableView.reloadData()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//        what will happen once the user clicks the add item button on our UIAlert
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                           let newItem = Item()
                           newItem.title = textField.text!
                           newItem.dateCreated = Date()
                           currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving Items,\(error)")
                    }
            }
                self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            
        }
        
       // func append(_ newElement:Array<UITextField>.Element)
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
    }
    
    // MARK: - Model Manipulation Methods
    
    

    func loadItems() {

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()

    }

    
}


//MARK: - Search Bar Methods
extension ToDoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
//        let request : NSFetchRequest = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }


}


