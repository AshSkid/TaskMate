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
        super.view.backgroundColor = .systemBackground
        super.navigationItem.title = "Create List"
        
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismiss_self))
        
        self.view.addSubview(self.name_text_field)
        
        let color_button = UIButton()
        color_button.setTitle("Color", for: .normal)
        super.view.addSubview(color_button)
        color_button.backgroundColor = .systemGray3
        color_button.setTitleColor(.white, for: .normal)
        color_button.frame = CGRect(x: 100, y: 200, width: 200, height: 45)
        color_button.addTarget(self, action: #selector(self.open_color_picker), for: .touchUpInside)
        
        let create_button = UIButton()
        create_button.setTitle("Create", for: .normal)
        super.view.addSubview(create_button)
        create_button.backgroundColor = .systemGray3
        create_button.setTitleColor(.white, for: .normal)
        create_button.frame = CGRect(x: 100, y: 400, width: 200, height: 45)
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
        
        if list_name.count == 0 {
            let alert = UIAlertController(title: "Task List has no title!", message: "In order to create a Task List, you must provide a title.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            CreateListViewController.just_created = true
            TaskList.add_list(list_name, self.color_picker.selectedColor)
            self.dismiss_self()
        }
        
        
    }
}



extension CreateListViewController: UIColorPickerViewControllerDelegate{
//    func colorPickerViewControllerDidFinish(_ controller: UIColorPickerViewController){
//        print("close")
//    }
    
//    func colorPickerViewController(_ controller: UIColorPickerViewController, didSelect: UIColor, continuously: Bool){
//
//    }
}
