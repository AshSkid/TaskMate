//
//  CreateListViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit


class CreateListViewController: UIViewController {
    static var just_created: Bool = false
    
    var name_text_field: UITextField = {
        var text_field: UITextField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 30));
        text_field.backgroundColor = .systemGray3
        text_field.placeholder = "Task List Name"
        
        return text_field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemBackground
        super.navigationItem.title = "Create List"
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        self.view.addSubview(self.name_text_field)
        
        let create_button = UIButton()
        create_button.setTitle("Create", for: .normal)
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 200, width: 200, height: 45)
        create_button.addTarget(self, action: #selector(self.create_list), for: .touchUpInside)
    }
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func create_list(){
        let list_name: String = self.name_text_field.text!
        
        if list_name.count == 0 {
            let alert = UIAlertController(title: "Task List has no title!", message: "In order to create a Task List, you must provide a title.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            CreateListViewController.just_created = true
            TaskList.add_list(list_name, .cyan)
            self.dismiss_self()
        }
        
        
    }
}
