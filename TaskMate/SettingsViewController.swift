//
//  SettingsViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

import UIKit

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

