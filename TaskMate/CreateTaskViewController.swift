//
//  CreateTaskViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit



class CreateTaskViewController: UIViewController {
    var task_list_index: Int!
    
    func setup(_ list_index: Int){
        self.task_list_index = list_index
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemBackground
        super.navigationItem.title = "Create Task"
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        let create_button = UIButton()
        create_button.setTitle("Create", for: .normal)
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 100, width: 200, height: 45)
        create_button.addTarget(self, action: #selector(self.create_task), for: .touchUpInside)
    }
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func create_task(){
        var task_list = TaskList.lists[self.task_list_index!]
        
        task_list.tasks.append(TaskList.Task("Task \(task_list.tasks.count)"))
        
        self.dismiss_self()
    }
}



