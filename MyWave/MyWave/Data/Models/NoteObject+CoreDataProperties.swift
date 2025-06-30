//
//  NoteObject+CoreDataProperties.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 20.05.2025.
//
//

import Foundation
import CoreData

@objc(NoteObject)
public class NoteObject: NSManagedObject {}

extension NoteObject {
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var emotionType: String
    @NSManaged public var icon: String
    @NSManaged public var dateAdded: Date
    @NSManaged public var activities: [String]
    @NSManaged public var companions: [String]
    @NSManaged public var locations: [String]

}

extension NoteObject : Identifiable {}
