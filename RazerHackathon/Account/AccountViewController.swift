//
//  AccountViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {
    
    let baseURL = mambuBaseURL
    
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var transferTextField: UITextField!
    @IBOutlet var outerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !isMockAPIHidden {
            outerView.alpha = 1
        }
    }
    
    func deposit(amount: String){
        let currentAccountID = getDefaultsValue(key: "currentAccount")
        
        let headers = mambuBasicAuth()
        
        let type = "DEPOSIT"
        let amount = Double(amount)
        let value = "123456"
        let customID = "IDENTIFIER_TRANSACTION_CHANNEL_I"
        let method = "bank"
        let note = "Test Deposit"
        let depositURL = baseURL +  "savings/\(currentAccountID)/transactions"
        do {
            let deposit = DepositModel(amount: amount!, notes: note, type: type, method: method, customInformation: [CustomInformation(value: value, customFieldID: customID)])
            let data = try? JSONEncoder().encode(deposit)
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            AF.request(depositURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON(completionHandler: {
                _ in
            })
        } catch {
            print(error)
        }
    }
    
    func transfer(amount: String){
        let currentAccountID = getDefaultsValue(key: "currentAccount")
        let savingsAccountID = getDefaultsValue(key: "endowmentPlan")
        
        let headers = mambuBasicAuth()
        
        let type = "TRANSFER"
        let notes = "Test Transfer"
        let amount = amount
        let method = "bank"
        
        let depositURL = baseURL + "savings/\(currentAccountID)/transactions"
        
        do {
            let transfer = TransferModel(type: type, amount: amount, notes: notes, toSavingsAccount: savingsAccountID, method: method)
            let data = try? JSONEncoder().encode(transfer)
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            AF.request(depositURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON(completionHandler: {
                _ in
            })
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func onTapDeposit(_ sender: Any) {
        self.deposit(amount: depositTextField.text!)
        
    }
    
    @IBAction func onTapTransfer(_ sender: Any) {
        self.transfer(amount: transferTextField.text!)
    }
    
    @IBAction func onTapHideKeyboard(_ sender: Any) {
        depositTextField.resignFirstResponder()
        transferTextField.resignFirstResponder()
    }
}
