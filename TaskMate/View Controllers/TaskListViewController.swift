//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit


class TaskListViewController: UIViewController {
    let table_view = UITableView()
    var safe_area: UILayoutGuide!
    var task_list_index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.safe_area = super.view.layoutMarginsGuide
        self.setup_table_view()
    }
    
    func setup(_ task_index: Int){
        let task_list = TaskList.lists[task_index]
        self.task_list_index = task_index
        
        super.navigationItem.title = task_list.title
        super.view.backgroundColor = task_list.color
        
        
        if task_list.can_add_tasks {
            let button = UIButton()
            button.setTitle("Create", for: .normal)
            self.view.addSubview(button)
            button.backgroundColor = .systemGray3
            button.setTitleColor(.white, for: .normal)
            button.frame = CGRect(x: 100, y: 400, width: 200, height: 45)
            button.addTarget(self, action: #selector(self.create_task), for: .touchUpInside)
        }
        
    }
    
    
    func setup_table_view(){
        super.view.addSubview(self.table_view)

        self.table_view.translatesAutoresizingMaskIntoConstraints = false

        self.table_view.topAnchor.constraint(equalTo: self.safe_area.topAnchor).isActive = true
        self.table_view.leftAnchor.constraint(equalTo: super.view.leftAnchor).isActive = true
        self.table_view.bottomAnchor.constraint(equalTo: super.view.bottomAnchor).isActive = true
        self.table_view.rightAnchor.constraint(equalTo: super.view.rightAnchor).isActive = true

        self.table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.table_view.dataSource = self
        self.table_view.delegate = self
        
        self.table_view.separatorStyle = UITableViewCell.SeparatorStyle.none
    }


    override func viewDidAppear(_ animated: Bool) {
        self.table_view.reloadData()
    }
    
    
    @objc func create_task(){
        let rootVC = CreateTaskViewController()
        rootVC.setup(self.task_list_index)
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
        
}


extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let task_list = TaskList.lists[self.task_list_index!]
        return task_list.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task_list = TaskList.lists[self.task_list_index!]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task_uuid: String = task_list.tasks[indexPath.row]
        cell.textLabel?.text = Task.tasks[task_uuid]!.name
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.task_list_index == TaskList.deleted_index {
            let permanently_delete = UIContextualAction(style: .normal, title: "Delete"){ (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Permanently Delete Task?", message: "Are you sure you want to permanently delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) -> Void in
                    let uuid: String = TaskList.lists[self.task_list_index].tasks[indexPath.row]
                    
                    TaskList.lists[TaskList.deleted_index].remove_task(uuid)
                    Task.tasks.removeValue(forKey: uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            permanently_delete.image = UIImage(systemName: "trash")
            permanently_delete.backgroundColor = .red
            
            let swipe = UISwipeActionsConfiguration(actions: [permanently_delete])
            return swipe
            
        }else{
            let delete = UIContextualAction(style: .normal, title: "Delete"){ (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Delete Task?", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) -> Void in
                    let uuid: String = TaskList.lists[self.task_list_index].tasks[indexPath.row]
                    Task.delete_task(uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            delete.image = UIImage(systemName: "trash")
            delete.backgroundColor = .red
            
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
        }
    }

    
    
     
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.task_list_index == TaskList.deleted_index {
            let restore = UIContextualAction(style: .normal, title: "Restore"){ (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Restore Task?", message: "Are you sure you want to restore this task?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Restore", style: UIAlertAction.Style.default, handler: { (_) -> Void in
                    let uuid: String = TaskList.lists[self.task_list_index].tasks[indexPath.row]
                    Task.restore_task(uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            restore.image = UIImage(systemName: "arrow.backward.circle")
            restore.backgroundColor = .blue
            
            let swipe = UISwipeActionsConfiguration(actions: [restore])
            return swipe
            
            
        }else{
            let add_to_today = UIContextualAction(style: .normal, title: "Add To Today"){ (action, view, completionHandler) in

                TaskList.lists[self.task_list_index].toggle_task_in_today(indexPath.row)
                
                completionHandler(true)
                
                if self.task_list_index == TaskList.today_index {
                    self.table_view.reloadData()
                }
            }
            
            
            let task_uuid: String = TaskList.lists[self.task_list_index].tasks[indexPath.row]
            if Task.tasks[task_uuid]!.is_in_today {
                add_to_today.image = UIImage(systemName: "sunset")
                
            }else{
                add_to_today.image = UIImage(systemName: "sunrise.fill")
            }
            
            
            add_to_today.backgroundColor = .orange
            
            
            
            
            let swipe = UISwipeActionsConfiguration(actions: [add_to_today])
            return swipe
        }
    
    }
    
}

