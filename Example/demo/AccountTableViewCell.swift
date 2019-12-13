//
//  AccountTableViewCell.swift
//  demo
//
//  Created by Laurent Grandhomme on 10/31/17.
//  Copyright © 2017 Element. All rights reserved.
//

import UIKit

#if !(targetEnvironment(simulator))
import ElementSDK
#endif

#if !(targetEnvironment(simulator))
class AccountTableViewCell: UITableViewCell, TableViewCellProtocol {

    static let cellWidth = UIScreen.width()
    static let labelHeight : CGFloat = 26
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: AccountTableViewCell.cellWidth - 20, height: AccountTableViewCell.labelHeight)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.blue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var bottomLabel : UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 10,
                             y: 10 + AccountTableViewCell.labelHeight + 10,
                             width: AccountTableViewCell.cellWidth - 20,
                             height: AccountTableViewCell.labelHeight)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.blue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.addSubview(self.nameLabel)
        self.addSubview(self.bottomLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionViewCellProtocol
    func configure(_ model: ELTAccount) {
        self.nameLabel.text = model.firstName + " " + model.lastName
        self.bottomLabel.text = model.userId
    }
    
    class func heightForModel(_ model: ELTAccount) -> CGFloat {
        return 10 + AccountTableViewCell.labelHeight * 2 + 10 + 10
    }
}
#endif
