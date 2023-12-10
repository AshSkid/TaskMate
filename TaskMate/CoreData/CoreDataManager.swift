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
                TaskList.add_list(list.name!, color)
            }
            
        } catch {
            
        }
    }
    
    
    static func create_task_list(_ name: String, _ color: UIColor) -> Void {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let task_list = TaskListCoreData(context: CoreDataManager.context!)
        task_list.name = name
        task_list.color_r = Float(red)
        task_list.color_g = Float(green)
        task_list.color_b = Float(blue)
        
        
        do {
            try CoreDataManager.context!.save()
        } catch {
            
        }
    }
    
    
    
    static private func delete_task_list(_ item: TaskListCoreData){
        CoreDataManager.context!.delete(item)
        
        do {
            try CoreDataManager.context!.save()
            
        } catch {
            
        }
    }
    
    
    
}
