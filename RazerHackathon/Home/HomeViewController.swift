//
//  HomeViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    let defaults = UserDefaults.standard
    var accounts = [ClientAccountModel]()
    var transactions = [TransactionModel]()
    let clientID = "8a8e87947217506401721c02f7b0293d"
    
    @IBOutlet weak var transactionTable: UITableView!
    @IBOutlet weak var accountsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        navigationItem.setHidesBackButton(true, animated: true)
        let nibCell = UINib(nibName: "AccountCollectionViewCell", bundle: nil)
        self.accountsCollection.register(nibCell, forCellWithReuseIdentifier: "AccountCollectionViewCell")

        // Do any additional setup after loading the view.
        obtainClientAccounts { (clientaccounts) in
            print(clientaccounts)
            self.accounts = clientaccounts
            self.accountsCollection.reloadData()
            self.depositIntoCurrentAccount()
            let currentAccountID = self.accounts[0].encodedKey
            self.getAllTransactions(currentAccountID: currentAccountID)
        }
        
    }
    
    func getAllTransactions(currentAccountID: String) {
        let getAllTransactionURL = "https://razerhackathon.sandbox.mambu.com/api/savings/\(currentAccountID)/transactions"
        let user = "Team11"
        let password = "pass8AE7D4715"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        AF.request(getAllTransactionURL, method: .get, headers: HTTPHeaders(headers)).responseJSON { response in
            do {
                let result = try JSONDecoder().decode([TransactionModel].self, from: response.data!)
                self.transactions = result
                self.transactionTable.reloadData()

            } catch {
                NSLog("Failed to fetch transactions")
            }
        }
    }
    
    func obtainClientAccounts(onCompletion: @escaping ((_: [ClientAccountModel]) -> Void)) {
        //        let clientID = defaults.string(forKey: "clientID") // fetched during onboarding flow
        let obtainClientAccountURL = "https://razerhackathon.sandbox.mambu.com/api/clients/\(clientID)/savings"
        let user = "Team11"
        let password = "pass8AE7D4715"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        AF.request(obtainClientAccountURL, method: .get, headers: HTTPHeaders(headers)).responseJSON { response in
            do {
                let result = try JSONDecoder().decode([ClientAccountModel].self, from: response.data!)
                onCompletion(result)
            } catch {
                NSLog("Failed to fetch client accounts")
                onCompletion([ClientAccountModel]())
            }
        }
    }
    
    func depositIntoCurrentAccount() {
        let currentAccountID = accounts[0].encodedKey
        print(currentAccountID)
        let user = "Team11"
        let password = "pass8AE7D4715"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        let type = "DEPOSIT"
        let amount = [200, 2000, 1000, 100, 500]
        let value = "123456"
        let customID = "IDENTIFIER_TRANSACTION_CHANNEL_I"
        let method = "bank"
        let notesArr = ["Money from part-time job","Side Hustle","Business Deal","Walking the neighbours dog","Car Wash" ]
        let depositURL = "https://razerhackathon.sandbox.mambu.com/api/savings/\(currentAccountID)/transactions"
        do {
            for i in 0...4 {
                let deposit = DepositModel(amount: Double(amount[i]), notes: notesArr[i], type: type, method: method, customInformation: [CustomInformation(value: value, customFieldID: customID)])
                let data = try? JSONEncoder().encode(deposit)
                let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                AF.request(depositURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: HTTPHeaders(headers))
            }
        } catch {
            print(error)
        }
    }
    
    func transferOutFromCurrentAccount() {
        let currentAccountID = accounts[0].encodedKey
        let savingsAccountID = "WBYA568"
        let user = "Team11"
        let password = "pass8AE7D4715"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        let type = "TRANSFER"
        let notes = "Save Together with Razer Pay"
        let amount = "20"
        let method = "bank"

        let depositURL = "https://razerhackathon.sandbox.mambu.com/api/savings/\(currentAccountID)/transactions"
        do {
            let transfer = TransferModel(type: type, amount: amount, notes: notes, toSavingsAccount: savingsAccountID, method: method)
                let data = try? JSONEncoder().encode(transfer)
                let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                AF.request(depositURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: HTTPHeaders(headers))
        } catch {
            print(error)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        
        let transaction = transactions[indexPath.row]
        cell.descLabel.text = transaction.comment
        
        let type = transaction.type
        
        if type == "DEPOSIT" {
            cell.amountLabel.text = "+ SGD \(transaction.amount)"
            cell.amountLabel.textColor = .systemGreen
        } else {
            cell.amountLabel.text = "- SGD \(transaction.amount)"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCollectionViewCell", for: indexPath) as! AccountCollectionViewCell
            
        let account = accounts[indexPath.row]
        print(account)
        
        cell.accountTypeLabel.text = account.accountType
        cell.accountNumberLabel.text = account.encodedKey
        cell.balanceLabel.text = account.balance
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let accountID = accounts[indexPath.row].encodedKey
        getAllTransactions(currentAccountID: accountID)

    }
    
}
