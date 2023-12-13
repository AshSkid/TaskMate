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
        
        var text_field: UITextField = UITextField(frame: StyleManager.get_default_row_frame());
        text_field.frame.origin.y += StyleManager.window_top_padding() + 6*StyleManager.row_padding_height()
        text_field.backgroundColor = StyleManager.Theme.fill()
        text_field.placeholder = "Task Name"
        text_field.layer.cornerRadius = StyleManager.corner_radius()
        
        
        return text_field
    }()
    
    
    var date_picker: UIDatePicker = {
        var picker = UIDatePicker(frame: StyleManager.get_default_row_frame())
        picker.frame.origin.y += StyleManager.window_top_padding() + 13*StyleManager.row_padding_height() + StyleManager.row_height()
        
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
        super.view.backgroundColor = StyleManager.Theme.background()
        if self.mode == .create {
            super.navigationItem.title = "Create Task"
        }else{
            super.navigationItem.title = "Edit Task"
        }
        
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        super.navigationItem.leftBarButtonItem!.tintColor = StyleManager.Theme.text_2()
        
        let name_text_label = UILabel(frame: CGRect(
            x: StyleManager.row_padding_width(),
            y: StyleManager.window_top_padding() + 2*StyleManager.row_padding_height(),
            width: StyleManager.screen_width(),
            height: StyleManager.row_height()
        ))
        super.view.addSubview(name_text_label)
        name_text_label.text = "Name:"
        name_text_label.textColor = StyleManager.Theme.text()
        
        
        
        self.view.addSubview(self.name_text_field)
        
        
        let date_label = UILabel(frame: CGRect(
            x: StyleManager.row_padding_width(),
            y: StyleManager.window_top_padding() + 9*StyleManager.row_padding_height() + StyleManager.row_height(),
            width: StyleManager.screen_width(),
            height: StyleManager.row_height()
        ))
        super.view.addSubview(date_label)
        date_label.text = "Date:"
        date_label.textColor = StyleManager.Theme.text()
        
        
        
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
        create_button.backgroundColor = StyleManager.Theme.fill()
        create_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
        create_button.frame = StyleManager.get_default_row_frame()
        create_button.frame.origin.y += StyleManager.window_top_padding() + 20*StyleManager.row_padding_height() + 2*StyleManager.row_height()
        create_button.layer.cornerRadius = StyleManager.corner_radius()
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








