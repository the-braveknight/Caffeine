//
//  Settings.swift
//  Caffeine
//
//  Created by Zaid Rahawi on 3/19/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import UIKit

struct Settings {
    enum ColorMode: String {
        case normal
        case dark
        
        var tableViewColor: UIColor {
            switch self {
            case .normal: return .groupTableViewBackground
            case .dark: return #colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .normal: return .black
            case .dark: return .orange
            }
        }
        
        var barTintColor: UIColor {
            switch self {
            case .normal: return .white
            case .dark: return .black
            }
        }
        
        var cellColor: UIColor {
            switch self {
            case .normal: return .white
            case .dark: return #colorLiteral(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .normal: return .black
            case .dark: return .lightText
            }
        }
        
        func progressTintColor(forState state: DownloadState) -> UIColor {
            switch self {
            case .normal:
                switch state {
                case .suspended: return .darkGray
                default: return .black
                }
            case .dark:
                switch state {
                case .suspended: return .black
                default: return .lightText
                }
            }
        }
        
        var keyboardAppearance: UIKeyboardAppearance {
            switch self {
            case .normal: return .default
            case .dark: return .dark
            }
        }
        
        var tableViewSeperatorColor: UIColor? {
            switch self {
            case .normal: return .groupTableViewBackground
            case .dark: return .black
            }
        }
        
        var barStyle: UIBarStyle {
            switch self {
            case .normal: return .default
            case .dark: return .black
            }
        }
        
        var textAttributes: [NSAttributedStringKey : Any] {
            return [.foregroundColor : textColor]
        }
        
        var searchBarTextAttributes: [String : Any] {
            return [NSAttributedStringKey.foregroundColor.rawValue : textColor]
        }
    }
    
    static var colorMode: ColorMode {
        get {
            return UserDefaults.standard.colorMode(forKey: "ColorMode") ?? Defaults.colorMode
        } set {
            UserDefaults.standard.set(newValue, forKey: "ColorMode")
            NotificationCenter.default.post(name: .colorModeChanged, object: newValue)
        }
    }
    
    enum Defaults {
        static let colorMode: ColorMode = .normal
    }
}

extension Notification.Name {
    static let colorModeChanged = Notification.Name(rawValue: "ColorModeChanged")
}

extension UserDefaults {
    func set(_ colorMode: Settings.ColorMode, forKey key: String) {
        set(colorMode.rawValue, forKey: key)
    }
    
    func colorMode(forKey key: String) -> Settings.ColorMode? {
        if let rawValue = UserDefaults.standard.string(forKey: key) {
            return Settings.ColorMode(rawValue: rawValue)
        }
        return nil
    }
}
