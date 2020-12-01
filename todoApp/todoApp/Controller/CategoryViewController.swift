//
//  CategoryViewController.swift
//  todoApp
//
//  Created by Marmago on 30/11/2020.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //MARK: - Add Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Local UITextField available for the full scope of the funciton
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
           
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadCategories(){
        let request: NSFetchRequest = Category.fetchRequest()
        do{
        categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
        
    }
    //MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.categoryCellIdentifier)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = category.name
        
        
        return cell
    }
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.rootToItems, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}
