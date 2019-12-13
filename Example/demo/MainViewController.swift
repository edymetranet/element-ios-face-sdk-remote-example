//
//  MainViewController.swift
//  fm-demo-public
//
//  Created by Laurent Grandhomme on 10/11/18.
//  Copyright © 2018 Element. All rights reserved.
//

import UIKit
#if !(targetEnvironment(simulator))
import ElementSDK
#endif

class MainViewController: UIViewController {
#if !(targetEnvironment(simulator))
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.width(),
                                                  height: UIScreen.height() - 80))
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    var ds : TableViewDataSource?
    
    var accounts : [ELTAccount]
    
    init() {
        self.accounts = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.title = "Remote Example " + version
        }
        
        self.tableView.registerClass(AccountTableViewCell.self)
        self.tableView.backgroundColor = .clear
        self.view.addSubview(self.tableView)

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Enroll", style: .done, target: self, action: #selector(MainViewController.enroll))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(MainViewController.signIn))
    }
    
    @objc func enroll() {
        self.showTextField(title: "Enter your name", placeholder: "Name", submitButtonTitle: "Enroll") { (text) in
            let acc : ELTAccount = ELTAccount.createNewAccount(withFirstName: text, lastName: "")
            let enrollmentVC = RemoteFaceEnrollmentViewController(firstName: acc.firstName, lastName: acc.lastName, userId: acc.userId, successBlock: { (vc) in
                _ = vc.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    acc.save()
                    self.reloadData()
                }
            }, onCancel: { (vc) in
                _ = vc.navigationController?.popViewController(animated: true)
            })
            enrollmentVC?.showGazeInstructions = true
            self.navigationController?.pushViewController(enrollmentVC!, animated: true)
        }
    }
    
    @objc func signIn() {
        let signInViewController = UserSignInViewController()
        signInViewController.signInType = .userId
        let signInNavigationController = UINavigationController(rootViewController: signInViewController)
        self.navigationController?.present(signInNavigationController, animated: true) {
        
        }
    }
    
    func reloadData() {
        // get a list of accounts stored on the device
        self.accounts = ELTAccount.allAccounts()
        var sectionModel = TableViewSectionModel()
        
        for account in self.accounts {
            sectionModel.cellModels.append(TableViewCellModel<AccountTableViewCell>(model: account, canBeSelected: true, onSelect: {
                self.handleTap(account)
            }, onDisplay: nil, onSwipeToDelete: {
                print("ask confirmation to delete", account)
                self.confirmDelete(account: account)
            }))
            
        }
        self.ds = TableViewDataSource(section: sectionModel)
        self.tableView.delegate = ds
        self.tableView.dataSource = ds
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func confirmDelete(account: ELTAccount) {
        let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to remove this account?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) in
            print("we can delete the account")
            // remove
            account.deleteFromDevice()
            self.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) in
            self.reloadData()
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sdkLevelAuthentication(userId: String) {
        // authenticate the user
        let sdkLevelAuthVc = RemoteFaceAuthenticationViewController(userId: userId, onAuthentication: { (viewController, confidenceScore, message) in
            print("success authenticating ", userId)
            _ = viewController.navigationController?.popViewController(animated: true)
        }, onCancel: { (viewController) in
            print("success authenticating ", userId)
            _ = viewController.navigationController?.popViewController(animated: true)
        })
        sdkLevelAuthVc?.showGazeInstructions = true
        self.navigationController?.pushViewController(sdkLevelAuthVc!, animated: true)
    }
    
    func handleTap(_ account: ELTAccount) {
        self.sdkLevelAuthentication(userId: account.userId)
    }
#endif
}
