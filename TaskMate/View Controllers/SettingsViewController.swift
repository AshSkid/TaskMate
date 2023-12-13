//
//  SettingsViewController.swift
//  TaskMate
//
//  Created by xcode on 11/16/23.
//

//.///////////////////////////////////////////////////////////////////////
//                                                                      //
//  This could be added in the future (along with more settings), but   //
//  due to time constraints this feature had to be left out for now     //
//                                                                      //
//.///////////////////////////////////////////////////////////////////////





//import UIKit
//
//class SettingsViewController: UIViewController {
//    let dark_button: UIButton = {
//        let button = UIButton()
//        button.setTitle("Dark", for: .normal)
//        button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        button.backgroundColor = StyleManager.Theme.fill()
//        button.layer.cornerRadius = StyleManager.corner_radius()
//        button.layer.maskedCorners = CACornerMask(rawValue: 0b0011)
//
//        return button
//    }()
//
//    let light_button: UIButton = {
//        let button = UIButton()
//        button.setTitle("Light", for: .normal)
//        button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        button.backgroundColor = StyleManager.Theme.fill()
//
//        return button
//    }()
//
//
//    let system_button: UIButton = {
//        let button = UIButton()
//        button.setTitle("System", for: .normal)
//        button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        button.backgroundColor = StyleManager.Theme.fill()
//        button.layer.cornerRadius = StyleManager.corner_radius()
//        button.layer.maskedCorners = CACornerMask(rawValue: 0b1100)
//
//        return button
//    }()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        super.view.backgroundColor = StyleManager.Theme.background()
//        super.navigationItem.title = "Settings"
//
//        super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.dismiss_self))
//        super.navigationItem.rightBarButtonItem!.tintColor = StyleManager.Theme.text_2()
//
//
//
//        let theme_label = UILabel(frame: CGRect(
//            x: StyleManager.row_padding_width(),
//            y: StyleManager.window_top_padding() + 2*StyleManager.row_padding_height(),
//            width: StyleManager.screen_width(),
//            height: StyleManager.row_height()
//        ))
//        super.view.addSubview(theme_label)
//        theme_label.text = "Theme:"
//        theme_label.textColor = StyleManager.Theme.text()
//
//        let theme_selector_background = UIView(frame: StyleManager.get_default_row_frame())
//        theme_selector_background.frame.origin.y += StyleManager.window_top_padding() + 6*StyleManager.row_padding_height()
//        theme_selector_background.frame.size.height = 3*StyleManager.row_height() + 2*StyleManager.row_padding_height()
//        super.view.addSubview(theme_selector_background)
//        theme_selector_background.backgroundColor = StyleManager.Theme.fill()
//        theme_selector_background.layer.cornerRadius = StyleManager.corner_radius()
//
//
//
//
//        self.dark_button.addTarget(self, action: #selector(self.set_dark_mode), for: .touchUpInside)
//        if StyleManager.Theme.mode == .dark {
//            self.dark_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//        }
//
//        self.light_button.addTarget(self, action: #selector(self.set_light_mode), for: .touchUpInside)
//        if StyleManager.Theme.mode == .light {
//            self.light_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//        }
//
//        self.system_button.addTarget(self, action: #selector(self.set_system_mode), for: .touchUpInside)
//        if StyleManager.Theme.mode == .system {
//            self.system_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//        }
//
//
//        let stack_view = UIStackView(arrangedSubviews: [self.dark_button, self.light_button, self.system_button])
//        stack_view.frame = theme_selector_background.bounds
//        theme_selector_background.addSubview(stack_view)
//
//        stack_view.backgroundColor = StyleManager.Theme.text_2()
//        stack_view.axis = .vertical
//        stack_view.distribution = .fillEqually
//        stack_view.spacing = 1
//
//        stack_view.layer.cornerRadius = StyleManager.corner_radius()
//    }
//
//    @objc private func dismiss_self() -> Void {
//        super.dismiss(animated: true, completion: nil)
//    }
//
//
//    @objc func set_dark_mode() -> Void {
//        self.dark_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//        self.light_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        self.system_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//
//        StyleManager.Theme.mode = .dark
//    }
//
//    @objc func set_light_mode() -> Void {
//        self.dark_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        self.light_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//        self.system_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//
//        StyleManager.Theme.mode = .light
//    }
//
//    @objc func set_system_mode() -> Void {
//        self.dark_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        self.light_button.setTitleColor(StyleManager.Theme.text_2(), for: .normal)
//        self.system_button.setTitleColor(StyleManager.Theme.text(), for: .normal)
//
//        StyleManager.Theme.mode = .system
//    }
//}

