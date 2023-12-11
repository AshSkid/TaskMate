//
//  StyleManager.swift
//  TaskMate
//
//  Created by xcode on 12/7/23.
//

import UIKit


struct StyleManager{
    static func row_padding_width() -> CGFloat { return 10 }
    static func row_padding_height() -> CGFloat { return 8 }
    static func row_height() -> CGFloat { return 40 }
    static func corner_radius() -> CGFloat { return 10 }
    
    
//    I couldn't find a proper way to do this, so this is just the value I got from testing
    static func window_top_padding() -> CGFloat { return 50 }
    
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
            height: StyleManager.row_height()
        )
    }
    
    struct Theme {
        static func background() -> UIColor {
            return UIColor(red: CGFloat(0.1176), green: CGFloat(0.1176), blue: CGFloat(0.1176), alpha: 1.0)
        }
        
        static func text() -> UIColor {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        static func text_2() -> UIColor {
            return UIColor(red: CGFloat(0.6157), green: CGFloat(0.6157), blue: CGFloat(0.6157), alpha: 1.0)
        }
        
        static func fill() -> UIColor {
            return UIColor(red: CGFloat(0.1843), green: CGFloat(0.1843), blue: CGFloat(0.1843), alpha: 1.0)
        }
        
        static func system_is_darkmode() -> Bool {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        
        static func red() -> UIColor {
            return UIColor(red: 1.0, green: CGFloat(0.2509), blue: CGFloat(0.2509), alpha: 1.0)
        }
        
        static func today() -> UIColor {
            return UIColor(red: 1.0, green: CGFloat(0.6666), blue: 0.0, alpha: 1.0)
        }
        
        static func all() -> UIColor {
            return UIColor(red: CGFloat(0.0980), green: CGFloat(0.6078), blue: CGFloat(0.0902), alpha: 1.0)
        }
        
        static func restore() -> UIColor {
            return UIColor(red: 0.0, green: CGFloat(0.8), blue: 1.0, alpha: 1.0)
        }
        
    }

    
    
    
    static func is_landscape() -> Bool {
       return UIDevice.current.orientation.isLandscape
    }
    
    static func is_portrait() -> Bool {
       return UIDevice.current.orientation.isFlat == false
    }
    
}

