//
//  CreateListViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit


class CreateListViewController: UIViewController {
    static var just_created: Bool = false
    
    enum Mode {
        case create
        case edit
    }
    var mode: Mode = .create
    var task_list_uuid: UUID?
    
    // only call this one if editing (not needed for create mode)
    func setup(_ list_uuid: UUID) -> Void {
        self.task_list_uuid = list_uuid
        self.mode = .edit
    }
    
    
    
    var name_text_field: UITextField = {
        var text_field: UITextField = UITextField(frame: StyleManager.get_default_row_frame());
        text_field.frame.origin.y += StyleManager.window_top_padding() + 6*StyleManager.row_padding_height()
        text_field.backgroundColor = StyleManager.Theme.fill()
        text_field.placeholder = "Task List Name"
        text_field.layer.cornerRadius = StyleManager.corner_radius()
        
        return text_field
    }()
    
    var color_button: UIButton = {
        let button = UIButton(frame: StyleManager.get_default_row_frame())
        button.frame.origin.y += StyleManager.window_top_padding() + 13*StyleManager.row_padding_height() + StyleManager.row_height()
        
        button.backgroundColor = StyleManager.Theme.fill()
        button.layer.cornerRadius = StyleManager.corner_radius()
        
        return button
    }()
    
    var color_picker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.title = "Background Color"
        picker.supportsAlpha = false
        picker.modalPresentationStyle = .popover
//        colorPicker.popoverPresentationController?.sourceItem = self.navigationItem.rightBarButtonItem
        picker.supportsAlpha = false
        
        return picker
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = StyleManager.Theme.background()
        
        if self.mode == .create {
            super.navigationItem.title = "Create Task List"
        } else {
            super.navigationItem.title = "Task List Settings"
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
        
        super.view.addSubview(self.name_text_field)
        
        if self.mode == .edit {
            self.name_text_field.text = TaskList.lists_map[self.task_list_uuid!]!.title
        }
        
        
        
        
        let color_text_label = UILabel(frame: CGRect(
            x: StyleManager.row_padding_width(),
            y: StyleManager.window_top_padding() + 9*StyleManager.row_padding_height() + StyleManager.row_height(),
            width: StyleManager.screen_width(),
            height: StyleManager.row_height()
        ))
        super.view.addSubview(color_text_label)
        color_text_label.text = "Color:"
        color_text_label.textColor = StyleManager.Theme.text()
        
        
        
        super.view.addSubview(self.color_button)
        if self.mode == .create {
            let default_color = UIColor(red: CGFloat(0.0039), green: CGFloat(0.7804), blue: CGFloat(0.9882), alpha: 1.0)
            
            self.color_picker.selectedColor = default_color
            
            self.color_button.setTitle(default_color.accessibilityName, for: .normal)
            self.color_button.setTitleColor(default_color, for: .normal)
            
        } else {
            self.color_picker.selectedColor = TaskList.lists_map[self.task_list_uuid!]!.color
            
            self.color_button.setTitle(TaskList.lists_map[self.task_list_uuid!]!.color.accessibilityName, for: .normal)
            self.color_button.setTitleColor(TaskList.lists_map[self.task_list_uuid!]!.color, for: .normal)
        }
        self.color_button.addTarget(self, action: #selector(self.open_color_picker), for: .touchUpInside)
        
        
        
        
        
        
        
        let create_button = UIButton()
        if self.mode == .create {
            create_button.setTitle("Create", for: .normal)
        }else{
            create_button.setTitle("Update", for: .normal)
        }
        
        super.view.addSubview(create_button)
        create_button.backgroundColor = StyleManager.Theme.fill()
        create_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
        create_button.frame = StyleManager.get_default_row_frame()
        create_button.frame.origin.y += StyleManager.window_top_padding() + 20*StyleManager.row_padding_height() + 2*StyleManager.row_height()
        create_button.layer.cornerRadius = StyleManager.corner_radius()
        create_button.addTarget(self, action: #selector(self.create_list), for: .touchUpInside)
    }
    
    
    
    
    @objc func open_color_picker(){
        self.color_picker.delegate = self
        
        self.present(self.color_picker, animated: true)
    }
    
    
    
    
    
    
    @objc private func dismiss_self(){
        super.dismiss(animated: true, completion: nil)
    }
    
    @objc func create_list(){
        let list_name: String = self.name_text_field.text!
        let list_color: UIColor = self.color_picker.selectedColor
        
        if list_name.count == 0 {
            let alert = UIAlertController(title: "Task List has no title!", message: "In order to create a Task List, you must provide a title.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            if self.mode == .create {
                CreateListViewController.just_created = true
                TaskList.create_new_list(list_name, list_color)
                
            } else {
                TaskList.lists_map[self.task_list_uuid!]!.title = list_name
                TaskList.lists_map[self.task_list_uuid!]!.color = list_color
                
                CoreDataManager.update_task_list(list_name, self.task_list_uuid!, list_color)
            }
            
            self.dismiss_self()
        }
        
        
    }
}



extension CreateListViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidFinish(_ controller: UIColorPickerViewController){
        self.color_button.setTitle(self.color_picker.selectedColor.accessibilityName, for: .normal)
        self.color_button.setTitleColor(self.color_picker.selectedColor, for: .normal)
    }
    
//    func colorPickerViewController(_ controller: UIColorPickerViewController, didSelect: UIColor, continuously: Bool){
//
//    }
}
