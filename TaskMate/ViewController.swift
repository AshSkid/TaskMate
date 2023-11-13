//
//  ViewController.swift
//  test
//
//  Created by xcode on 10/4/23.
//

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}
//
//
//

class ViewController: UIViewController {
    let table_view = UITableView()
    var safe_area: UILayoutGuide!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Notes"
        
        self.safe_area = super.view.layoutMarginsGuide
        
        self.setup_table_view()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "notes_list.at(indexPath.row)"
        return cell
    }
}

