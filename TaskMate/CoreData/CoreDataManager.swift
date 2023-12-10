//
//  CoreDataManager.swift
//  TaskMate
//
//  Created by xcode on 12/7/23.
//

import UIKit
import CoreData

struct CoreDataManager {    
    static private var context: NSManagedObjectContext?
    
    static func setup() -> Void {
        CoreDataManager.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        
        // setup task lists
        do {
            let task_lists: [TaskListCoreData] = try CoreDataManager.context!.fetch(TaskListCoreData.fetchRequest())
            
            for list in task_lists {
                let color: UIColor = UIColor(red: CGFloat(list.color_r), green: CGFloat(list.color_g), blue: CGFloat(list.color_b), alpha: 1.0)
                TaskList.add_list(list.name!, list.uuid, color)
            }
            
            
            let tasks: [TaskCoreData] = try CoreDataManager.context!.fetch(TaskCoreData.fetchRequest())
            for task in tasks {
                Task.add_task(task.name!, task.uuid!, task.home_list!, task.due_date!)
                if task.is_in_today {
                    TaskList.toggle_task_in_today(task.uuid!)
                }
                
                Task.tasks[task.uuid!]!.is_deleted = task.is_deleted
                if task.is_deleted {
                    TaskList.lists_map[TaskList.deleted_uuid]!.tasks.append(task.uuid!)
                }else{
                    TaskList.lists_map[task.home_list!]!.tasks.append(task.uuid!)
                }
                
                Task.tasks[task.uuid!]!.is_completed = task.is_completed
                Task.tasks[task.uuid!]!.due_date = task.due_date!
            }
            
        } catch {
            print("error getting task lists / tasks from CoreData (initial setup)")
        }
    }
    
    //./////////////////////////////////////////////////
    // Tasks
    
    static func create_task(_ task: inout Task) -> Void {
        let created_task = TaskCoreData(context: CoreDataManager.context!)
        created_task.name = task.name
//        created_task.is_in_today = task.is_in_today
        created_task.uuid = task.uuid
        created_task.home_list = task.home_list
//        created_task.is_deleted = task.is_deleted
//        created_task.is_completed = task.is_completed
        created_task.due_date = task.due_date
        
        do {
            try CoreDataManager.context!.save()
        } catch {
            print("error creating task lists from CoreData")
        }
    }
    
    static func update_task(_ task: inout Task) -> Void {
        do {
            let tasks: [TaskCoreData] = try CoreDataManager.context!.fetch(TaskCoreData.fetchRequest())
            
            for core_task in tasks {
                if core_task.uuid == task.uuid {
                    core_task.name = task.name
                    core_task.is_in_today = task.is_in_today
//                    core_task.uuid = task.uuid
                    core_task.home_list = task.home_list
                    core_task.is_deleted = task.is_deleted
                    core_task.is_completed = task.is_completed
                    core_task.due_date = task.due_date
                    
                    break
                }
            }
            
            try CoreDataManager.context!.save()
            
        } catch {
            print("error updating task from CoreData")
        }
    }
    
    
    static func delete_task(_ uuid: UUID) -> Void {
        do {
            let tasks: [TaskCoreData] = try CoreDataManager.context!.fetch(TaskCoreData.fetchRequest())
            
            for task in tasks {
                if task.uuid == uuid {
                    CoreDataManager.delete_task(task)
                    break
                }
            }
            
        } catch {
            print("error getting task from CoreData")
        }
    }
    
    static private func delete_task(_ item: TaskCoreData){
        CoreDataManager.context!.delete(item)
        
        do {
            try CoreDataManager.context!.save()
        } catch {
            print("error deleting task from CoreData")
        }
    }
    
    
    
    
    
    
    //./////////////////////////////////////////////////
    // Task lists
    
    
    static func create_task_list(_ name: String, _ uuid: UUID, _ color: UIColor) -> Void {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let task_list = TaskListCoreData(context: CoreDataManager.context!)
        task_list.uuid = uuid
        task_list.name = name
        task_list.color_r = Float(red)
        task_list.color_g = Float(green)
        task_list.color_b = Float(blue)
        
        
        do {
            try CoreDataManager.context!.save()
        } catch {
            print("error creating task lists from CoreData")
        }
    }
    
    
    static func update_task_list(_ name: String, _ uuid: UUID, _ color: UIColor) -> Void {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        do {
            let task_lists: [TaskListCoreData] = try CoreDataManager.context!.fetch(TaskListCoreData.fetchRequest())
            
            for list in task_lists {
                if list.uuid == uuid {
                    list.name = name
                    list.color_r = Float(red)
                    list.color_g = Float(green)
                    list.color_b = Float(blue)
                    break
                }
            }
            
            try CoreDataManager.context!.save()
            
        } catch {
            print("error updating task list from CoreData")
        }
    }
    
    
    static func delete_task_list(_ uuid: UUID) -> Void {
        do {
            let task_lists: [TaskListCoreData] = try CoreDataManager.context!.fetch(TaskListCoreData.fetchRequest())
            
            for list in task_lists {
                if list.uuid == uuid {
                    CoreDataManager.delete_task_list(list)
                    break
                }
            }
            
        } catch {
            print("error getting task lists from CoreData")
        }
    }
    
    static private func delete_task_list(_ item: TaskListCoreData){
        CoreDataManager.context!.delete(item)
        
        do {
            try CoreDataManager.context!.save()
        } catch {
            print("error deleting task lists from CoreData")
        }
    }
    
    
    
}
