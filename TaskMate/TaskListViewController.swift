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
        
        
        if task_list.builtin == false {
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

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let task_list = TaskList.lists[self.task_list_index!]
        return task_list.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task_list = TaskList.lists[self.task_list_index!]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = task_list.tasks[indexPath.row].name
        
        return cell
    }
}

