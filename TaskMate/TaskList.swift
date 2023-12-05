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
    var home_list: Int // list this task lives in
    var is_deleted: Bool = false
    var is_completed: Bool = false
    var due_date: Date
    
    init(_ title: String, _ id: String, _ originating_list: Int, _ due: Date){
        self.name = title
        self.uuid = id
        self.home_list = originating_list
        self.due_date = due
    }
    
    
    //./////////////////////////////////////////////////
    // Task management
    
    static var tasks: [String : Task] = [:]
    
    static func create_task(_ title: String, _ originating_list: Int, _ due: Date) -> String {
        let uuid = UUID().uuidString
        
        tasks[uuid] = Task(title, uuid, originating_list, due)
        
        TaskList.lists[TaskList.all_index].tasks.append(uuid)
        
        return uuid
    }
    
    static func delete_task(_ uuid: String) -> Void {
        let originating_list_index: Int = Task.tasks[uuid]!.home_list
        TaskList.lists[originating_list_index].remove_task(uuid)
        
        // remove from All
        TaskList.lists[TaskList.all_index].remove_task(uuid)
        
        // if necesary, remove from Today
        if Task.tasks[uuid]!.is_in_today {
            TaskList.lists[TaskList.today_index].remove_task(uuid)
            Task.tasks[uuid]!.is_in_today = false
        }
        
        Task.tasks[uuid]!.is_deleted = true
        
        // add to Deleted
        TaskList.lists[TaskList.deleted_index].tasks.append(uuid)
    }
    
    static func restore_task(_ uuid: String) -> Void {
        let originating_list_index: Int = Task.tasks[uuid]!.home_list
        TaskList.lists[originating_list_index].tasks.append(uuid)
        
        // add to all
        TaskList.lists[TaskList.all_index].tasks.append(uuid)
        
        Task.tasks[uuid]!.is_deleted = true
        
        // remove to Deleted
        TaskList.lists[TaskList.deleted_index].remove_task(uuid)
    }
    
}




struct TaskList{
    static var lists: [TaskList] = []
    
    static let today_index = 0
    static let misc_index = 1
    static let all_index = 2
    static let deleted_index = 3
    
    
    
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
            TaskList.lists[TaskList.today_index].remove_task(task_uuid)
            
        } else {
            // add to today list
            TaskList.lists[TaskList.today_index].tasks.append(task_uuid)
        }
    }
    
    
    mutating func remove_task(_ uuid: String) -> Void {
        for i in 0..<self.tasks.count {
            if self.tasks[i] == uuid {
                self.tasks.remove(at: i)
                break
            }
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

