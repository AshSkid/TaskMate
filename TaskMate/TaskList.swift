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
    var uuid: UUID
    var home_list: UUID // list this task lives in
    var is_deleted: Bool = false
    var is_completed: Bool = false
    var due_date: Date
    
    init(_ title: String, _ id: UUID, _ originating_list: UUID, _ due: Date){
        self.name = title
        self.uuid = id
        self.home_list = originating_list
        self.due_date = due
    }
    
    
    //./////////////////////////////////////////////////
    // Task management
    
    
    
    static var tasks: [UUID : Task] = [:]
    
    
    static func add_task(_ title: String, _ uuid: UUID, _ originating_list: UUID, _ due: Date) -> Void {
        Task.tasks[uuid] = Task(title, uuid, originating_list, due)
        TaskList.lists_map[TaskList.all_uuid]!.tasks.append(uuid)
        
    }
    
    static func create_task(_ title: String, _ originating_list: UUID, _ due: Date) -> UUID {
        let uuid = UUID()
    
        Task.add_task(title, uuid, originating_list, due)
        TaskList.lists_map[originating_list]!.tasks.append(uuid)
        
        CoreDataManager.create_task(&Task.tasks[uuid]!)
        
        return uuid
    }

    
    
    
    static func delete_task(_ uuid: UUID, permanently: Bool = false) -> Void {
        let originating_list_uuid: UUID = Task.tasks[uuid]!.home_list
        TaskList.lists_map[originating_list_uuid]!.remove_task(uuid)
        
        // remove from All
        TaskList.lists_map[TaskList.all_uuid]!.remove_task(uuid)
        
        // if necesary, remove from Today
        if Task.tasks[uuid]!.is_in_today {
            TaskList.lists_map[TaskList.today_uuid]!.remove_task(uuid)
            Task.tasks[uuid]!.is_in_today = false
        }
        
        Task.tasks[uuid]!.is_deleted = true
        
        if permanently == false {
            // add to Deleted
            TaskList.lists_map[TaskList.deleted_uuid]!.tasks.append(uuid)
            CoreDataManager.update_task(&Task.tasks[uuid]!)
            
        } else {
            Task.tasks.removeValue(forKey: uuid)
            CoreDataManager.delete_task(uuid)
        }
    }
    
    static func restore_task(_ uuid: UUID) -> Void {
        let originating_list_uuid: UUID = Task.tasks[uuid]!.home_list
        TaskList.lists_map[originating_list_uuid]!.tasks.append(uuid)
        
        // add to all
        TaskList.lists_map[TaskList.all_uuid]!.tasks.append(uuid)
        
        Task.tasks[uuid]!.is_deleted = false
        
        // remove to Deleted
        TaskList.lists_map[TaskList.deleted_uuid]!.remove_task(uuid)
        
        CoreDataManager.update_task(&Task.tasks[uuid]!)
    }
    
}




struct TaskList{
    static var lists_map: [UUID : TaskList] = [:]
    static var lists_arr: [UUID] = []
    
    static let today_index: Int = 0
    static let all_index: Int = 1
    static let misc_index: Int = 2
    static let deleted_index: Int = 3
    
    static let today_uuid: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    static let all_uuid: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    static let misc_uuid: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    static let deleted_uuid: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    
    
    
    var title: String
    var color: UIColor
    var tasks: [UUID] = []
    var can_add_tasks: Bool
    var uuid: UUID?
    
    
    init(_ list_title: String, _ list_color: UIColor, _ id: UUID, _ adding_tasks_allowed: Bool){
        self.title = list_title
        self.color = list_color
        self.uuid = id
        self.can_add_tasks = adding_tasks_allowed
    }
    
    
    
    
    
    static func toggle_task_in_today(_ task_uuid: UUID) -> Void {
        let task_currently_in_today: Bool = Task.tasks[task_uuid]!.is_in_today
        
        Task.tasks[task_uuid]!.is_in_today = !task_currently_in_today
        
        if task_currently_in_today {
            // remove from today list
            TaskList.lists_map[TaskList.today_uuid]!.remove_task(task_uuid)
            
        } else {
            // add to today list
            TaskList.lists_map[TaskList.today_uuid]!.tasks.append(task_uuid)
        }
        
        CoreDataManager.update_task(&Task.tasks[task_uuid]!)
    }
    
    func toggle_task_in_today(_ task_index: Int) -> Void {
        let task_uuid: UUID = self.tasks[task_index]
        TaskList.toggle_task_in_today(task_uuid)
    }
    
    
    mutating func remove_task(_ uuid: UUID) -> Void {
        for i in 0..<self.tasks.count {
            if self.tasks[i] == uuid {
                self.tasks.remove(at: i)
                break
            }
        }
    }
    
    
    static func setup_lists(){
//        TaskList.lists.removeAll()
        
        TaskList.lists_map[today_uuid] = (TaskList.init("Today", StyleManager.Theme.today(), today_uuid, false))
        TaskList.lists_map[all_uuid] = (TaskList.init("All", StyleManager.Theme.all(), all_uuid, false))
        TaskList.lists_map[misc_uuid] = (TaskList.init("Misc Tasks", StyleManager.Theme.text_2(), misc_uuid, true))
        TaskList.lists_map[deleted_uuid] = (TaskList.init("Deleted", StyleManager.Theme.red(), deleted_uuid, false))
        
        TaskList.lists_arr.append(today_uuid)
        TaskList.lists_arr.append(all_uuid)
        TaskList.lists_arr.append(misc_uuid)
        TaskList.lists_arr.append(deleted_uuid)
    }
    
    
    static func add_list(_ title: String, _ uuid: UUID, _ color: UIColor){
        TaskList.lists_map[uuid] = TaskList.init(title, color, uuid, true)
        TaskList.lists_arr.append(uuid)
    }
    
    static func create_new_list(_ title: String, _ color: UIColor){
        let new_uuid = UUID()
        TaskList.add_list(title, new_uuid, color)
        CoreDataManager.create_task_list(title, new_uuid, color)
    }
    
    
    static func delete_list(_ uuid: UUID) -> Void {
        for task in TaskList.lists_map[uuid]!.tasks {
            Task.delete_task(task, permanently: true)
        }
        
        TaskList.lists_map.removeValue(forKey: uuid)
        for i in 0..<TaskList.lists_arr.count {
            if TaskList.lists_arr[i] == uuid {
                TaskList.lists_arr.remove(at: i)
                break
            }
        }
        
        CoreDataManager.delete_task_list(uuid)
    }
    
}

