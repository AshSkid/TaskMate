//
//  TaskListCoreData+CoreDataProperties.swift
//  TaskMate
//
//  Created by xcode on 12/9/23.
//
//

import Foundation
import CoreData


extension TaskListCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskListCoreData> {
        return NSFetchRequest<TaskListCoreData>(entityName: "TaskListCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var color_r: Float
    @NSManaged public var color_g: Float
    @NSManaged public var color_b: Float

}
