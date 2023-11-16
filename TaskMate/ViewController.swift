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
