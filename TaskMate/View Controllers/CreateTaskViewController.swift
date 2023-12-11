//
//  CreateTaskViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit



class CreateTaskViewController: UIViewController {
    enum Mode {
        case create
        case edit
    }
    var mode: Mode!
    var task_uuid: UUID? // only used if mode is .edit
        
    
    var task_list_uuid: UUID!
    var name_text_field: UITextField = {
        var text_field: UITextField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 30));
        text_field.backgroundColor = .systemGray3
        text_field.placeholder = "Task Name"
        
//        sampleTextField.placeholder = "Enter text here"
//        sampleTextField.font = UIFont.systemFont(ofSize: 15)
//        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
//        sampleTextField.keyboardType = UIKeyboardType.default
//        sampleTextField.returnKeyType = UIReturnKeyType.done
//        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
//        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        sampleTextField.delegate = self
        
        
        return text_field
    }()
    
    
    var date_picker: UIDatePicker = {
        var picker = UIDatePicker(frame: CGRect(x: 100, y: 200, width: 200, height: 30))
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        
        return picker
    }()
    
    
    
    
    func setup(_ list_uuid: UUID){
        self.task_list_uuid = list_uuid
        self.mode = .create
    }
    
    func setup(_ list_uuid: UUID, _ task_to_edit: UUID){
        self.task_list_uuid = list_uuid
        self.mode = .edit
        self.task_uuid = task_to_edit
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemBackground
        if self.mode == .create {
            super.navigationItem.title = "Create Task"
        }else{
            super.navigationItem.title = "Edit Task"
        }
        
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        self.view.addSubview(self.name_text_field)
        
        self.view.addSubview(self.date_picker)
        
        let create_button = UIButton()
        if self.mode == .create {
            create_button.setTitle("Create", for: .normal)
        }else{
            create_button.setTitle("Update", for: .normal)
            self.name_text_field.text = Task.tasks[self.task_uuid!]!.name
            self.date_picker.date = Task.tasks[self.task_uuid!]!.due_date
        }
        
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 400, width: 200, height: 45)
        create_button.addTarget(self, action: #selector(self.complete), for: .touchUpInside)
    }
    
    
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func complete(){
        let task_name: String = self.name_text_field.text!
        
        if task_name.count == 0 {
            let alert = UIAlertController(title: "Task has no title!", message: "In order to create a Task, you must provide a title.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            
        }else{
            let date: Date = self.date_picker.date
            
            if self.mode == .create {
                _ = Task.create_task(task_name, task_list_uuid, date)
                
            }else{
                Task.tasks[self.task_uuid!]!.name = task_name
                Task.tasks[self.task_uuid!]!.due_date = date
                
                CoreDataManager.update_task(&Task.tasks[self.task_uuid!]!)
            }
            
            
                    
            self.dismiss_self()
        }
    }
    
}








