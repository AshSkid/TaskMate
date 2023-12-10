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
    
    var add_task_button: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.safe_area = super.view.layoutMarginsGuide
        self.setup_table_view()
    }
    
    func setup(_ task_index: Int){
        let task_list_uuid: UUID = TaskList.lists_arr[task_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        self.task_list_index = task_index
        
        super.navigationItem.title = task_list.title
        super.view.backgroundColor = StyleManager.Theme.fill()
        
        // set title bar color
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: task_list.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: task_list.color]
        
        super.navigationItem.standardAppearance = appearance
        super.navigationItem.scrollEdgeAppearance = appearance
        
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.go_back_home))
        super.navigationItem.leftBarButtonItem!.image = UIImage(systemName: "arrow.backward")
        super.navigationItem.leftBarButtonItem!.tintColor = StyleManager.Theme.text_2()
        
        if task_list.can_add_tasks {
            if task_list.uuid != TaskList.misc_uuid {
                super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.open_task_list_settings))
                super.navigationItem.rightBarButtonItem!.image = UIImage(systemName: "line.horizontal.3")
                super.navigationItem.rightBarButtonItem!.tintColor = task_list.color
            }
            
            self.add_task_button = UIButton()
            self.view.addSubview(self.add_task_button!)
            self.add_task_button!.setTitle("+ Add Task...", for: .normal)
            self.add_task_button!.setTitleColor(task_list.color, for: .normal)
            self.add_task_button!.backgroundColor = StyleManager.Theme.fill()
            self.add_task_button!.frame = CGRect(x: 0, y: StyleManager.screen_height() - StyleManager.row_height(), width: StyleManager.screen_width(), height: StyleManager.row_height())
            self.add_task_button!.addTarget(self, action: #selector(self.create_task), for: .touchUpInside)
        }
        
    }
    
    
    @objc private func go_back_home(){
//        super.dismiss(animated: true, completion: nil)
        super.navigationController?.popViewController(animated: true)
    }
    
    
    func setup_table_view(){
        super.view.addSubview(self.table_view)

        self.table_view.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.table_view.backgroundColor = StyleManager.Theme.background()
        
        self.table_view.translatesAutoresizingMaskIntoConstraints = false

        self.table_view.topAnchor.constraint(equalTo: self.safe_area.topAnchor).isActive = true
        self.table_view.leftAnchor.constraint(equalTo: super.view.leftAnchor).isActive = true
        self.table_view.bottomAnchor.constraint(equalTo: super.view.bottomAnchor).isActive = true
        self.table_view.rightAnchor.constraint(equalTo: super.view.rightAnchor).isActive = true

        self.table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.table_view.dataSource = self
        self.table_view.delegate = self
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.table_view.reloadData()
        
        // update in case was changed in settings
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        
        super.navigationItem.title = task_list.title
        if task_list.can_add_tasks {
            self.add_task_button!.setTitleColor(task_list.color, for: .normal)
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: task_list.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: task_list.color]
        
        super.navigationItem.standardAppearance = appearance
        super.navigationItem.scrollEdgeAppearance = appearance
        
        if task_list.can_add_tasks && task_list_uuid != TaskList.misc_uuid{
            super.navigationItem.rightBarButtonItem!.tintColor = task_list.color
        }
    }
    
    // handle rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.table_view.reloadData()
    }
    
    
    @objc func create_task(){
        let rootVC = CreateTaskViewController()
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        rootVC.setup(task_list_uuid)
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
    
    
    
    @objc func open_task_list_settings() -> Void {
        let rootVC = CreateListViewController()
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        rootVC.setup(task_list_uuid)
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
}



extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        return task_list.tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StyleManager.row_height() + 2*StyleManager.row_padding_height()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        let task_uuid: UUID = task_list.tasks[indexPath.row]
        
        cell.backgroundColor = StyleManager.Theme.background()
        
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
        button.frame = CGRect(x: StyleManager.row_padding_width(), y: 10, width: 20, height: 20)
        button.addTarget(self, action: #selector(self.toggle_task_completd(sender:)), for: .touchUpInside)
        button.tag = indexPath.row


        let label = UILabel()
        label.text = Task.tasks[task_uuid]!.name
        background.addSubview(label)
        label.frame = CGRect(x: 2*StyleManager.row_padding_width() + 20, y: 0, width: StyleManager.screen_width(), height: StyleManager.row_height())
        label.textColor = task_list.color
        label.textAlignment = .justified
        
        if Task.tasks[task_uuid]!.is_in_today {
            let sun_image = UIImageView(frame: CGRect(x: label.frame.origin.x - 5, y: 10, width: 20, height: 20))
            background.addSubview(sun_image)
            sun_image.image = UIImage(systemName: "sun.max")
            sun_image.tintColor = StyleManager.Theme.text_2()
            
            label.frame.origin.x += 20
        }

        
        let task_date: Date = Task.tasks[task_uuid]!.due_date
        
        let date_formatter = DateFormatter()
        date_formatter.setLocalizedDateFormatFromTemplate("MMM, d")
        let formatted_date: String = date_formatter.string(from: task_date)

        let date = UILabel()
        background.addSubview(date)
        date.frame = CGRect(x: StyleManager.row_padding_width(), y: 0, width: StyleManager.screen_width() - 4*StyleManager.row_padding_width(), height: StyleManager.row_height())
        
        
        if Calendar.current.isDateInToday(task_date) {
            date.text = "Today"
            date.textColor = StyleManager.Theme.text_2()
            
        }else if Calendar.current.isDateInYesterday(task_date) {
            date.text = "Yesterday"
            date.textColor = StyleManager.Theme.red()
            
        }else if Calendar.current.isDateInTomorrow(task_date) {
            date.text = "Tomorrow"
            date.textColor = StyleManager.Theme.text_2()
            
        } else if task_date < Date() {
            date.text = formatted_date
            date.textColor = StyleManager.Theme.red()
        }else{
            date.text = formatted_date
            date.textColor = StyleManager.Theme.text_2()
        }

        date.textAlignment = .right
    
        return cell
    }
    
    @objc func toggle_task_completd(sender: UIButton){
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        
        let uuid: UUID = task_list.tasks[sender.tag]
        
        Task.tasks[uuid]!.is_completed = !(Task.tasks[uuid]!.is_completed)
        
        self.table_view.reloadData()
    }
    
    
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.task_list_index == TaskList.deleted_index {
            let permanently_delete = UIContextualAction(style: .normal, title: "Delete"){ (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Permanently Delete Task?", message: "Are you sure you want to permanently delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) -> Void in
                    let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
                    let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
                    let uuid: UUID = task_list.tasks[indexPath.row]
                    
                    TaskList.lists_map[TaskList.deleted_uuid]!.remove_task(uuid)
                    Task.tasks.removeValue(forKey: uuid)
                    
                    CoreDataManager.delete_task(uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            permanently_delete.image = UIImage(systemName: "trash")
            permanently_delete.backgroundColor = StyleManager.Theme.red()
            
            let swipe = UISwipeActionsConfiguration(actions: [permanently_delete])
            return swipe
            
        }else{
            let delete = UIContextualAction(style: .normal, title: "Delete"){ (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Delete Task?", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) -> Void in
                    let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
                    let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
                    let uuid: UUID = task_list.tasks[indexPath.row]
                    Task.delete_task(uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            delete.image = UIImage(systemName: "trash")
            delete.backgroundColor = StyleManager.Theme.red()
            
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
                    let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
                    let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
                    let uuid: UUID = task_list.tasks[indexPath.row]
                    Task.restore_task(uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            restore.image = UIImage(systemName: "arrow.backward.circle")
            restore.backgroundColor = StyleManager.Theme.restore()
            
            let swipe = UISwipeActionsConfiguration(actions: [restore])
            return swipe
            
            
        }else{
            let add_to_today = UIContextualAction(style: .normal, title: "Add To Today"){ (action, view, completionHandler) in
                let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
                TaskList.lists_map[task_list_uuid]!.toggle_task_in_today(indexPath.row)
                
                completionHandler(true)
                
//                if self.task_list_index == TaskList.today_index {
                    self.table_view.reloadData()
//                }
            }
            
            let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
            let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
            let task_uuid: UUID = task_list.tasks[indexPath.row]
            if Task.tasks[task_uuid]!.is_in_today {
                add_to_today.image = UIImage(systemName: "sunset")
                
            }else{
                add_to_today.image = UIImage(systemName: "sunrise.fill")
            }
            
            add_to_today.backgroundColor = StyleManager.Theme.today()
            
            let swipe = UISwipeActionsConfiguration(actions: [add_to_today])
            return swipe
        }
    
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task_list_uuid: UUID = TaskList.lists_arr[self.task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        let task_uuid: UUID = task_list.tasks[indexPath.row]
        
        let rootVC = CreateTaskViewController()
        rootVC.setup(task_list_uuid, task_uuid)
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
    
    
}

