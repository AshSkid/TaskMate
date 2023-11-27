//
//  TaskList.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit




struct Task{
    var name: String
    var is_in_today: Bool = false
    var uuid: String
    
    init(_ title: String, _ id: String){
        self.name = title
        self.uuid = id
    }
    
    
    //./////////////////////////////////////////////////
    // Task management
    
    static var tasks: [String : Task] = [:]
    
    static func create_task(_ title: String) -> String {
        let uuid = UUID().uuidString
        
        tasks[uuid] = Task(title, uuid)
        
        return uuid
    }
}




struct TaskList{
    static var lists: [TaskList] = []
    

    var title: String
    var color: UIColor
    var can_add_tasks: Bool
    var tasks: [String] = []
    
        
    init(_ list_title: String, _ list_color: UIColor, _ has_add_task_button: Bool){
        self.title = list_title
        self.color = list_color
        self.can_add_tasks = has_add_task_button
    }
    
    
    func toggle_task_in_today(_ task_index: Int) -> Void {
        let task_uuid: String = self.tasks[task_index]
        
        let task_currently_in_today: Bool = Task.tasks[task_uuid]!.is_in_today
        
        Task.tasks[task_uuid]!.is_in_today = !task_currently_in_today
        
        if task_currently_in_today {
            // remove from today list
            for i in 0..<self.tasks.count {
                if TaskList.lists[0].tasks[i] == task_uuid {
                    TaskList.lists[0].tasks.remove(at: i)
                    break
                }
            }
            
        } else {
            // add to today list
            TaskList.lists[0].tasks.append(task_uuid)
            
        }
    }
    
    
    
    static func setup_lists(){
        TaskList.lists.removeAll()
        TaskList.lists.append(TaskList.init("Today", .orange, false))
        TaskList.lists.append(TaskList.init("Misc Tasks", .gray, true))
        TaskList.lists.append(TaskList.init("All", .green, false))
        TaskList.lists.append(TaskList.init("Deleted", .red, false))
    }
    
    static func add_list(_ title: String, _ color: UIColor){
        TaskList.lists.append(TaskList.init(title, color, true))
    }
}

