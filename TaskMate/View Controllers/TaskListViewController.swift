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
        super.viewDidAppear(animated)
        self.table_view.reloadData()
    }
    
    // handle rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StyleManager.row_height()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task_uuid: String = TaskList.lists[self.task_list_index!].tasks[indexPath.row]
        
        
        let background = UIView(frame: StyleManager.get_default_row_frame())
        background.backgroundColor = StyleManager.Theme.fill()
        cell.addSubview(background)
        background.layer.cornerRadius = StyleManager.corner_radius()
        
        
        let button = UIButton()
        if Task.tasks[task_uuid]!.is_completed {
            button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "circle"), for: .normal)
        }



        background.addSubview(button)
//        button.backgroundColor = StyleManager.Theme.fill()
        button.frame = CGRect(x: 2*StyleManager.row_padding_width(), y: 10, width: 20, height: 20)
        button.addTarget(self, action: #selector(self.toggle_task_completd(sender:)), for: .touchUpInside)
        button.tag = indexPath.row


        let label = UILabel()
        label.text = Task.tasks[task_uuid]!.name
        background.addSubview(label)
        label.frame = CGRect(x: 3*StyleManager.row_padding_width() + 20, y: 0, width: StyleManager.screen_width(), height: StyleManager.row_height())
        label.textColor = .white
        label.textAlignment = .justified

        let date_formatter = DateFormatter()
        date_formatter.dateStyle = .short
        date_formatter.timeStyle = .short
        let formatted_date: String = date_formatter.string(from: Task.tasks[task_uuid]!.due_date)

        let date = UILabel()
        date.text = formatted_date
        background.addSubview(date)
        date.frame = CGRect(x: 120, y: 0, width: 200, height: 40)
        if Task.tasks[task_uuid]!.due_date < Date() {
            date.textColor = .red
        }else{
            date.textColor = .white
        }

        date.textAlignment = .justified
    
        return cell
    }
    
    @objc func toggle_task_completd(sender: UIButton){
        let uuid: String = TaskList.lists[self.task_list_index].tasks[sender.tag]
        
        Task.tasks[uuid]!.is_completed = !(Task.tasks[uuid]!.is_completed)
        
        self.table_view.reloadData()
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task_uuid: String = TaskList.lists[self.task_list_index].tasks[indexPath.row]
        
        let rootVC = CreateTaskViewController()
        rootVC.setup(self.task_list_index, task_uuid)
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
    
    
}

