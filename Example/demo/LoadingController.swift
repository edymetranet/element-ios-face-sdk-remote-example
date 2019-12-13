//
//  LoadingController.swift
//  demo
//
//  Created by Laurent Grandhomme on 9/29/16.
//  Copyright © 2016 Element. All rights reserved.
//

import UIKit

class LoadingView : UIView {
    var loadingLabel : UILabel
    var loadingFrame : UIView
    
    override init(frame: CGRect) {
        self.loadingLabel = UILabel(frame: frame)
        self.loadingLabel.numberOfLines = 0
        self.loadingLabel.backgroundColor = UIColor.clear
        self.loadingLabel.textColor = UIColor.white
        self.loadingLabel.font = UIFont.systemFont(ofSize: 24)
        self.loadingLabel.textAlignment = .center
        self.loadingFrame = UIView(frame: frame)
        self.loadingFrame.backgroundColor = UIColor.black
        self.loadingFrame.layer.cornerRadius = 5
        self.loadingFrame.addSubview(self.loadingLabel)
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addSubview(self.loadingFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(_ str: String) {
        self.loadingLabel.frame = self.frame
        self.loadingLabel.setWidth(loadingLabel.width() - 40)
        self.loadingLabel.text = str
        self.loadingLabel.sizeToFit()
        
        self.loadingFrame.frame = self.loadingLabel.frame
        self.loadingFrame.extendSizeBy(20)
        self.loadingFrame.centerInSuperView()
        
        self.loadingLabel.centerInSuperView()
    }
}

class LoadingController {
    static var loadingView : LoadingView = {
        let view = LoadingView(frame: (UIApplication.shared.delegate?.window??.frame)!)
        return view
    }()
    
    class func showLoading(_ message: String) {
        DispatchQueue.main.async {
            self.loadingView.setMessage(message)
            UIApplication.shared.delegate?.window??.addSubview(self.loadingView)
        }
    }
    
    class func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
    }
}
