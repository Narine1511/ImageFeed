//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Наринэ  Овсепян on 20.04.2026.
//

/*import UIKit
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
    }*/

/*
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var blockingView: UIView?
    
    static func show() {
        DispatchQueue.main.async {
            // Находим активное окно (то, которое сейчас на экране)
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow }) else {
                return
            }
            
            // Создаём прозрачную вьюху для блокировки
            let view = UIView(frame: window.bounds)
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true
            window.addSubview(view)
            blockingView = view
            
            ProgressHUD.animate()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            blockingView?.removeFromSuperview()
            blockingView = nil
            ProgressHUD.dismiss()
        }
    }
}*/

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var blockingView: UIView?
    
    static func show() {
        DispatchQueue.main.async {
            // Находим активное окно
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow }) else {
                return
            }
            
            // 1. Создаём блокирующую вьюху поверх всего
            let view = UIView(frame: window.bounds)
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)  // затемнение
            view.isUserInteractionEnabled = true  // блокирует нажатия
            window.addSubview(view)
            blockingView = view
            
            // 2. Показываем ProgressHUD
            ProgressHUD.animate()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            // 1. Убираем блокирующую вьюху
            blockingView?.removeFromSuperview()
            blockingView = nil
            
            // 2. Скрываем ProgressHUD
            ProgressHUD.dismiss()
        }
    }
}
