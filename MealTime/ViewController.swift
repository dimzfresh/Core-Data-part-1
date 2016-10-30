//
//  ViewController.swift
//  MealTime
//
//  Created by Dimz on 15.10.16.
//  Copyright © 2016 Dmitriy Zyablikov. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var array: Array<Date> = []
    var managedObjectContext: NSManagedObjectContext!
    var currentPerson: Person!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let myEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)
        let personName = "Dima"
        
        let fetchRequest: NSFetchRequest<Person>
        fetchRequest = NSFetchRequest(entityName: "Person")
       
        //let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "name == %@", personName)
        
        do {
        
            //let results = try managedObjectContext.fetch(fetchRequest) as! [Person]
            let results = try managedObjectContext.fetch(fetchRequest)
            
            if !results.isEmpty {
                currentPerson = results.first
            } else {
                currentPerson = Person(entity: myEntity!, insertInto: managedObjectContext)
                currentPerson.name = personName
                try managedObjectContext.save()
            }
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPerson.meals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let meal = currentPerson.meals![(indexPath as NSIndexPath).row] as! Meal
        
        cell!.textLabel!.text = dateFormatter.string(from: meal.date! as Date)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let itemToDelete = currentPerson.meals![(indexPath as NSIndexPath).row] as! Meal
            managedObjectContext.delete(itemToDelete)
            
            do {
                try managedObjectContext.save()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
       
        let mealEntity = NSEntityDescription.entity(forEntityName: "Meal", in: managedObjectContext)
        let meal = Meal(entity: mealEntity!, insertInto: managedObjectContext)
        
        meal.date = Date()
        
        let meals = currentPerson.meals!.mutableCopy() as! NSMutableOrderedSet
        meals.add(meal)
        currentPerson.meals = meals.copy() as? NSOrderedSet
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("error occured: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

