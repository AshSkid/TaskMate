//
//  CreateListViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit


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
