//
//  ViewController.swift
//  test
//
//  Created by xcode on 10/4/23.
//

import UIKit


class ViewController: UIViewController {
    let table_view = UITableView()
    var safe_area: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemTeal
        super.navigationItem.title = "Home"
        
        self.safe_area = super.view.layoutMarginsGuide
        self.setup_table_view()
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(open_settings))
        super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(create_task_list))
        
        TaskList.setup_lists()
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
    
    
    func open_task_list(_ task_list_index: Int){
        let task_view = TaskListViewController()
        task_view.setup(task_list_index)
        super.navigationController?.pushViewController(task_view, animated: true)
    }


    override func viewDidAppear(_ animated: Bool) {
        self.table_view.reloadData()
        
        if CreateListViewController.just_created {
            CreateListViewController.just_created = false
            self.open_task_list(TaskList.lists.count - 1)
        }
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.lists.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "notes_list.at(indexPath.row)"
        
        if indexPath.row == 4 {
            cell.textLabel?.text = "----------------------------------"
            return cell
        }
        
        let task_index: Int = {
            if indexPath.row < 4 {
                return indexPath.row
            }else{
                return indexPath.row - 1
            }
        }()
        
        let task_list = TaskList.lists[task_index]
        
        
        let button = UIButton()
        button.setTitle(task_list.title, for: .normal)
        cell.addSubview(button)
        button.backgroundColor = .systemGray3
        button.setTitleColor(task_list.color, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button.addTarget(self, action: #selector(self.clicked_task_list(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 10
        }
        
        return 40
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
