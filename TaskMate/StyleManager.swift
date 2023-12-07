//
//  StyleManager.swift
//  TaskMate
//
//  Created by xcode on 12/7/23.
//

import UIKit


struct StyleManager{
    static func row_padding_width() -> CGFloat { return 5 }
    static func row_padding_height() -> CGFloat { return 3 }
    static func row_height() -> CGFloat { return 40 }
    static func corner_radius() -> CGFloat { return 10 }
    
    static func screen_width() -> CGFloat {
        let screen = UIScreen.main.bounds
        return screen.size.width
    }
    
    static func screen_height() -> CGFloat {
        let screen = UIScreen.main.bounds
        return screen.size.height
    }
    
    static func get_default_row_frame() -> CGRect {
        return CGRect(
            x: StyleManager.row_padding_width(),
            y: StyleManager.row_padding_height(),
            width: StyleManager.screen_width() - 2*StyleManager.row_padding_width(),
            height: StyleManager.row_height() - StyleManager.row_padding_height()
        )
    }
    
    struct Theme {
        static func background() -> UIColor {
            return .systemBackground
        }
        
        static func text() -> UIColor {
            return .white
        }
        
        static func fill() -> UIColor {
            return .gray
        }
        
        static func system_is_darkmode() -> Bool {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
    }

    
    
    
    static func is_landscape() -> Bool {
       return UIDevice.current.orientation.isLandscape
    }
    
    static func is_portrait() -> Bool {
       return UIDevice.current.orientation.isFlat == false
    }
    
}

