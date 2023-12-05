//
//  CreateTaskViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit



class CreateTaskViewController: UIViewController {
    var task_list_index: Int!
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
        
        return picker
    }()
    
    
    
    
    func setup(_ list_index: Int){
        self.task_list_index = list_index
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .systemBackground
        super.navigationItem.title = "Create Task"
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        self.view.addSubview(self.name_text_field)
        
        self.view.addSubview(self.date_picker)
        
        let create_button = UIButton()
        create_button.setTitle("Create", for: .normal)
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 400, width: 200, height: 45)
        create_button.addTarget(self, action: #selector(self.create_task), for: .touchUpInside)
    }
    
    
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func create_task(){
        let task_name: String = self.name_text_field.text!
        
        if task_name.count == 0 {
            let alert = UIAlertController(title: "Task has no title!", message: "In order to create a Task, you must provide a title.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            
        }else{
            let date: Date = self.date_picker.date
            
            let new_task_uuid: String = Task.create_task(task_name, self.task_list_index, date)
            TaskList.lists[self.task_list_index!].tasks.append(new_task_uuid)
                    
            self.dismiss_self()
        }
        
    }
    
}








