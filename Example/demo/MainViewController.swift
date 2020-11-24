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
    
    var appLevelProcessing : Bool
    
    init() {
        self.accounts = []
        // self.appLevelProcessing == true -> App layer processing
        // self.appLevelProcessing == true -> SDK layer processing
        self.appLevelProcessing = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchProcessing(control: UISwitch) {
        self.appLevelProcessing = control.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.title = "Remote Example " + version
        }
        
        let switchView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: 70))
        let switchLabel = UILabel(frame: CGRect(x: 20, y: 20, width: UIScreen.width() - 80, height: 40))
        switchLabel.text = "App layer processing:"
        switchLabel.font = UIFont.systemFont(ofSize: 20)
        switchView.addSubview(switchLabel)
        let switchControl = UISwitch(frame: CGRect(x: UIScreen.width() - 70, y: 20, width: 50, height: 40))
        switchControl.setOn(self.appLevelProcessing, animated: false)
        switchControl.addTarget(self, action: #selector(switchProcessing(control:)), for: .valueChanged)
        switchView.addSubview(switchControl)
        self.tableView.tableHeaderView = switchView
        
        self.tableView.registerClass(AccountTableViewCell.self)
        self.tableView.backgroundColor = .clear
        self.view.addSubview(self.tableView)

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Enroll", style: .done, target: self, action: #selector(MainViewController.enroll))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(MainViewController.signIn))
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
    
    // MARK: Authentication
    
    func sdkLevelAuthenticationViewController(userId: String) -> RemoteFaceAuthenticationViewController? {
        // authenticate the user
        let sdkLevelAuthVc = RemoteFaceAuthenticationViewController(userId: userId, onAuthentication: { (viewController, confidenceScore, message) in
            print("success authenticating ", userId)
            _ = viewController.navigationController?.popViewController(animated: true)
        }, onEarlyExit: { (viewController, reason) in
            print("success authenticating ", userId)
            _ = viewController.navigationController?.popViewController(animated: true)
        })
        return sdkLevelAuthVc
    }
    
    func appLayerAuthenticationViewController(userId: String) -> RemoteFaceAuthenticationViewController? {
        let vc = RemoteFaceAuthenticationViewController(asyncVerifyBlock: {
            images, latitude, longitude, logs, callback in
            // you may pass in additional parameters
            let result = ElementRemoteProcessingTransaction.verifyUserId(userId, with: images, latitude: latitude, longitude: longitude, logs: logs, additionalParameters: nil)
            callback(result)
        }, onAuthentication: {
            viewController, confidenceScore in
            print("success authenticating")
            _ = viewController.navigationController?.popViewController(animated: true)
        }, onEarlyExit: {
            viewController, reason in
            print("authentication cancelled")
            _ = viewController.navigationController?.popViewController(animated: true)
        })
        return vc
    }
    
    func handleTap(_ account: ELTAccount) {
        let vc : RemoteFaceAuthenticationViewController?
        if self.appLevelProcessing {
            vc = self.appLayerAuthenticationViewController(userId: account.userId)
        } else {
            vc = self.sdkLevelAuthenticationViewController(userId: account.userId)
        }
        // show instructions before capture or not
        vc?.showGazeInstructions = false
        // show authentication success message
        vc?.showAuthenticationSuccessScreen = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: Enrollment
    
    func sdkLevelEnrollmentViewController(account: ELTAccount) -> RemoteFaceEnrollmentViewController? {
        let enrollmentVC = RemoteFaceEnrollmentViewController(firstName: account.firstName, lastName: account.lastName, userId: account.userId, successBlock: { (vc) in
            _ = vc.navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                account.save()
                self.reloadData()
            }
        }, onEarlyExit: { (vc, reason) in
            _ = vc.navigationController?.popViewController(animated: true)
        })
        return enrollmentVC
    }
    
    func appLayerEnrollmentViewController(account: ELTAccount) -> RemoteFaceEnrollmentViewController? {
        let enrollmentVC = RemoteFaceEnrollmentViewController(successBlock: { (viewController, images) in
            _ = viewController.navigationController?.popViewController(animated: true)
            LoadingController.showLoading("Enrolling...")
            ElementRemoteProcessingTransaction.enrollUser(withFirstName: account.firstName, lastName: account.lastName, userId: account.userId, images: images, additionalParameters: nil, successBlock: { (resp) in
                print(resp)
                LoadingController.hideLoading()
                DispatchQueue.main.async {
                    self.showMessage(title: "Account created", message: nil, block: {

                    })
                }
            }, errorBlock: { (error) in
                print(error)
                LoadingController.hideLoading()
                DispatchQueue.main.async {
                    self.showMessage(title: "An error happened", message: nil, block: {

                    })
                }
            })
        }, onEarlyExit: { (viewController, reason) in
            _ = viewController.navigationController?.popViewController(animated: true)
        })
        return enrollmentVC
    }
    
    @objc func enroll() {
        self.showTextField(title: "Enter your name", placeholder: "Name", submitButtonTitle: "Enroll") { (text) in
            let acc : ELTAccount = ELTAccount.createNewAccount(withFirstName: text, lastName: "")
            let enrollmentVC : RemoteFaceEnrollmentViewController?
            if self.appLevelProcessing {
                enrollmentVC = self.appLayerEnrollmentViewController(account: acc)
            } else {
                enrollmentVC = self.sdkLevelEnrollmentViewController(account: acc)
            }
            // show instructions before capture or not
            enrollmentVC?.showGazeInstructions = false
            // enrollment success message
            enrollmentVC?.enrollmentMessageBlock = {
                return "Enrolled!"
            }
            // show the enrollment success popup
            enrollmentVC?.showEnrollmentSuccessScreen = true
            self.navigationController?.pushViewController(enrollmentVC!, animated: true)
        }
    }
#endif
}
