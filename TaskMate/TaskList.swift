//
//  TaskList.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit




struct TaskList{
    static var lists: [TaskList] = []
    
    
    struct Task{
        var name: String
        
        init(_ title: String){
            self.name = title
        }
    }
    
    var title: String
    var color: UIColor
    var builtin: Bool
    var tasks: [Task] = []
    
        
    init(_ list_title: String, _ list_color: UIColor, _ is_builtin: Bool){
        self.title = list_title
        self.color = list_color
        self.builtin = is_builtin
    }
    
    static func setup_lists(){
        TaskList.lists.removeAll()
        TaskList.lists.append(TaskList.init("Today", .yellow, true))
        TaskList.lists.append(TaskList.init("Misc Tasks", .gray, true))
        TaskList.lists.append(TaskList.init("All", .green, true))
        TaskList.lists.append(TaskList.init("Deleted", .red, true))
    }
    
    static func add_list(_ title: String, _ color: UIColor){
        TaskList.lists.append(TaskList.init(title, color, false))
    }
}

