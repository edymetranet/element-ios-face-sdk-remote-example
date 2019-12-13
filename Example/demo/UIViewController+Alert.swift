//
//  UIViewController+Alert.swift
//  demo
//
//  Created by Laurent Grandhomme on 9/28/16.
//  Copyright © 2016 Element. All rights reserved.
//

import UIKit

extension UIViewController {
    func showMessage(title: String?, message: String? = nil, block: (()->())? = nil) {
    
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                if let b = block {
                    b()
                }
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
        }
    }
    
    func showTextField(title: String, placeholder: String, submitButtonTitle: String, tapButton: @escaping (String)->()) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: title, preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = placeholder
            }
            
            let OKAction = UIAlertAction(title: submitButtonTitle, style: .default) { (action) in
                let tf = alertController.textFields![0] as UITextField
                tapButton(tf.text ?? "")
            }
            alertController.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true) {
                
            }
        }
    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}
