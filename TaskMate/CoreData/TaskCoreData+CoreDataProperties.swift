//
//  TaskCoreData+CoreDataProperties.swift
//  TaskMate
//
//  Created by xcode on 12/9/23.
//
//

import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var is_in_today: Bool
    @NSManaged public var uuid: UUID?
    @NSManaged public var home_list: UUID?
    @NSManaged public var is_deleted: Bool
    @NSManaged public var is_completed: Bool
    @NSManaged public var due_date: Date?

}
