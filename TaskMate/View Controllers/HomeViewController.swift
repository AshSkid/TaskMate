//
//  ViewController.swift
//  test
//
//  Created by xcode on 10/4/23.
//

import UIKit


class HomeViewController: UIViewController {
    let table_view = UITableView()
    var safe_area: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = StyleManager.Theme.fill()
        super.navigationItem.title = "Home"
        
        self.safe_area = super.view.layoutMarginsGuide
        self.setup_table_view()
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(open_settings))
        super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(create_task_list))
        
//        TaskList.setup_lists()
    }
    
    @objc func open_settings(){
        let rootVC = SettingsViewController()
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
    }
    
    @objc func create_task_list(){
        let rootVC = CreateListViewController()
       
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        super.present(navVC, animated: true)
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
    
    
    func open_task_list(_ task_list_index: Int){
        let task_view = TaskListViewController()
        task_view.setup(task_list_index)
        super.navigationController?.pushViewController(task_view, animated: true)
    }


    override func viewDidAppear(_ animated: Bool) {
        self.table_view.reloadData()
        
        if CreateListViewController.just_created {
            CreateListViewController.just_created = false
            self.open_task_list(TaskList.lists_arr.count - 1)
        }
    }
}



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.lists_arr.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = StyleManager.Theme.background()
        
        if indexPath.row == 4 {
            let line = UIView(frame: CGRect(x: 0, y: StyleManager.row_padding_height(), width: StyleManager.screen_width(), height: 1))
            line.backgroundColor = StyleManager.Theme.text_2()
            cell.addSubview(line)
            return cell
        }
        
        let task_list_index: Int = {
            if indexPath.row < 4 {
                return indexPath.row
            }else{
                return indexPath.row - 1
            }
        }()
        
        let task_list_uuid: UUID = TaskList.lists_arr[task_list_index]
        let task_list: TaskList = TaskList.lists_map[task_list_uuid]!
        
        
        let button = UIButton()
        button.setTitle(task_list.title, for: .normal)
        cell.addSubview(button)
        button.backgroundColor = StyleManager.Theme.fill()
        button.setTitleColor(task_list.color, for: .normal)
        button.frame = StyleManager.get_default_row_frame()
        button.layer.cornerRadius = StyleManager.corner_radius()
        button.addTarget(self, action: #selector(self.clicked_task_list(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return StyleManager.row_padding_height() * 2
        }
        
        return StyleManager.row_height() + 2*StyleManager.row_padding_height()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 4 {
            let permanently_delete = UIContextualAction(style: .normal, title: "Delete"){ (action, view, completionHandler) in
                let list_uuid: UUID = TaskList.lists_arr[indexPath.row - 1]
                let alert = UIAlertController(title: "Permanently Delete Task List?", message: "Are you sure you want to permanently delete \(TaskList.lists_map[list_uuid]!.title)?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) -> Void in
                    TaskList.delete_list(list_uuid)
                    
                    self.table_view.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                completionHandler(true)
            }
            
            permanently_delete.image = UIImage(systemName: "trash")
            permanently_delete.backgroundColor = StyleManager.Theme.red()
            
            let swipe = UISwipeActionsConfiguration(actions: [permanently_delete])
            return swipe
        } else {
            return nil
        }
    }
    
    
    
    
    
    
    @objc private func clicked_task_list(sender: UIButton){
        let task_index: Int = {
            if sender.tag < 4 {
                return sender.tag
            }else{
                return sender.tag - 1
            }
        }()
        
        self.open_task_list(task_index)
    }
}
