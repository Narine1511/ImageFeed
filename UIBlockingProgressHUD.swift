//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 20.04.2026.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    private static var window: UIWindow? {
        return windowScene?.windows.first
    }
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.animate()
        }
    }
        
        static func dismiss() {
            DispatchQueue.main.async {
                window?.isUserInteractionEnabled = true
                ProgressHUD.dismiss()
            }
        }
    }
