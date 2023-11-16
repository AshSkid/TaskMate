//
//  ViewController.swift
//  test
//
//  Created by xcode on 10/4/23.
//

import UIKit


struct TaskList{
    var title: String
    var color: UIColor
    var builtin: Bool
    
    static var lists: [TaskList] = []
    
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


//.//////////////////////////////////////////////////////////////////////////////////
// View Controller


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
    }


    override func viewDidAppear(_ animated: Bool) {
        self.table_view.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "notes_list.at(indexPath.row)"
        
        let task = TaskList.lists[indexPath.row]
        
        
        let button = UIButton()
        button.setTitle(task.title, for: .normal)
        cell.addSubview(button)
        button.backgroundColor = .systemGray3
        button.setTitleColor(task.color, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        button.addTarget(self, action: #selector(self.clicked_task_list(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        
        
        return cell
    }
    
    
    
    @objc private func clicked_task_list(sender: UIButton){
        let task_view = TaskListViewController()
        task_view.setup(sender.tag)
        super.navigationController?.pushViewController(task_view, animated: true)
    }
}


//.//////////////////////////////////////////////////////////////////////////////////
// Task List

class TaskListViewController: UIViewController {
    let table_view = UITableView()
    var safe_area: UILayoutGuide!
    var task_list_index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.safe_area = super.view.layoutMarginsGuide
        self.setup_table_view()
        
    }
    
    func setup(_ task_index: Int){
        let task = TaskList.lists[task_index]
        self.task_list_index = task_index
        
        super.navigationItem.title = task.title
        super.view.backgroundColor = task.color
        
        
        if task.builtin == false {
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
        print("create task")
    }
        
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Task \(indexPath.row)"
        
        return cell
    }
}




//.//////////////////////////////////////////////////////////////////////////////////
// Settings

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemGreen
        super.navigationItem.title = "Settings"
        
        super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismiss_self))
    }
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
}


//.//////////////////////////////////////////////////////////////////////////////////
// Create List

class CreateListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemBackground
        super.navigationItem.title = "Create List"
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        let create_button = UIButton()
        create_button.setTitle("Create", for: .normal)
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 100, width: 200, height: 45)
        create_button.addTarget(self, action: #selector(self.create_list), for: .touchUpInside)
    }
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func create_list(){
        TaskList.add_list("List Name", .cyan)
        self.dismiss_self()
    }
}


