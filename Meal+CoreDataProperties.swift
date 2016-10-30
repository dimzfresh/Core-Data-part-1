//
//  Meal+CoreDataProperties.swift
//  MealTime
//
//  Created by Dimz on 15.10.16.
//  Copyright © 2016 Dmitriy Zyablikov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Meal {

    @NSManaged var date: Date?
    @NSManaged var person: Person?

}
