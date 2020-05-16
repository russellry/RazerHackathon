//
//  VerifySuccessViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView

class VerifySuccessViewController: UIViewController {
    
    var base64image: String?
    let verifyNRICURL: String = "https://niw1itg937.execute-api.ap-southeast-1.amazonaws.com/Prod/verify"
    let baseURL: String = "https://razerhackathon.sandbox.mambu.com/api/"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bdayLabel: UILabel!
    @IBOutlet weak var birthCountryLabel: UILabel!
    @IBOutlet weak var nricLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimatedSkeleton()
        overrideUserInterfaceStyle = .light
        continueBtn.layer.cornerRadius = 4
        continueBtn.isEnabled = false
        retakeBtn.layer.cornerRadius = 4
        startProcess()
    }
    
    func startProcess() {
        let headers = [
            "x-api-key": "uwFcGSR4Fb5Zzxwvhkch",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "base64image": base64image
        ]
        
        AF.request(verifyNRICURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(headers)).responseJSON(completionHandler: { response in
            do {
                let nricModel = try JSONDecoder().decode(NRICModel.self, from: response.data!)
                self.hideAnimatedSkeleton()
                self.nameLabel.text = nricModel.vision.extract.name
                self.typeLabel.text = nricModel.vision.type
                self.nricLabel.text = nricModel.vision.extract.idNum
                self.raceLabel.text = nricModel.vision.extract.race
                self.birthCountryLabel.text = nricModel.vision.extract.countryOfBirth
                self.bdayLabel.text = nricModel.vision.extract.dob
                self.continueBtn.isEnabled = true
                self.getBranchID(onCompletion: { [weak self] branchID in
                    self?.createClientID(branchID: branchID, credentials: nricModel, onCompletion: { [weak self] clientID in
                        
                        guard let self = self else {
                            return
                        }
                        
                        self.defaults.set(branchID, forKey: "branchID")
                        self.defaults.set(clientID, forKey: "clientID")
                        self.createCurrentAccount()
                    })
                })
            } catch {
                let alert = UIAlertController(title: "Your picture wasn't super clear", message: "Let's retake the photo, yeah?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
    
    func createCurrentAccount(){
        let currentAccountURL = baseURL + "savings"
        let accountHolderType = "CLIENT"
        guard let accountHolderKey = defaults.string(forKey: "clientID") else {
            return
        }
        let accountState = "APPROVED"
        let productTypeKey = "8a8e878471bf59cf0171bf6979700440"
        let allowOverdraft = "true"
        let accountType = "CURRENT_ACCOUNT"
        let interestRate = "1.25"
        
        let currentAccountDetails = CurrentAccountModel(savingsAccount: SavingsAccount(accountHolderType: accountHolderType, accountHolderKey: accountHolderKey, accountState: accountState, productTypeKey: productTypeKey, allowOverdraft: allowOverdraft, accountType: accountType, interestSettings: InterestSettings(interestRate: interestRate)))
        
        let data = try? JSONEncoder().encode(currentAccountDetails)
        
        do {
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            
            let headers = mambuBasicAuth()
            
            AF.request(currentAccountURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON { rr in
                return
            }
        } catch {
            print(error)
        }
    }
    
    func createClientID(branchID: String, credentials: NRICModel, onCompletion: @escaping ((_ response: String) -> Void)){
        let clientsURL = baseURL + "clients"
        let nameArr = credentials.vision.extract.name.components(separatedBy: " ")
        let client = ClientModel(client: Client(
            firstName: nameArr.first ?? "",
            lastName: nameArr.last ?? "",
            assignedBranchKey: branchID),
                                 idDocuments: [IDDocuments(identificationDocumentTemplateKey: "8a8e867271bd280c0171bf7e4ec71b01",
                                                           documentType: "NRIC/Passport Number",
                                                           documentId: credentials.vision.extract.idNum)])
        
        let data = try? JSONEncoder().encode(client)
        
        do {
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            let headers = mambuBasicAuth()
            
            
            AF.request(clientsURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
                
                let result = try? JSONDecoder().decode(ClientModelResponse.self, from: response.data!)
                onCompletion((result?.client.encodedKey)!)
            }
        } catch {
            print(error)
        }
    }
    
    func getBranchID(onCompletion: @escaping ((_ response: String) -> Void)) {
        let branchURL = baseURL + "branches/team11"
        var branchId = ""
        let headers = mambuBasicAuth()
        
        AF.request(branchURL, method: .get, headers: headers).responseJSON { response in
            do {
                let result = try JSONDecoder().decode(BranchModel.self, from: response.data!)
                branchId = result.encodedKey
                onCompletion(branchId)
                
            } catch {
                NSLog("Failed to fetch branchId")
                onCompletion(branchId)
            }
        }
    }
    
    @IBAction func tapRetakeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapContinueBtn(_ sender: Any) {
        performSegue(withIdentifier: "toHomeScreen", sender: nil)
    }
    
    
    fileprivate func showAnimatedSkeleton() {
        nameLabel.showAnimatedSkeleton()
        typeLabel.showAnimatedSkeleton()
        bdayLabel.showAnimatedSkeleton()
        birthCountryLabel.showAnimatedSkeleton()
        nricLabel.showAnimatedSkeleton()
        raceLabel.showAnimatedSkeleton()
    }
    
    fileprivate func hideAnimatedSkeleton() {
        self.nameLabel.hideSkeleton()
        self.typeLabel.hideSkeleton()
        self.bdayLabel.hideSkeleton()
        self.birthCountryLabel.hideSkeleton()
        self.nricLabel.hideSkeleton()
        self.raceLabel.hideSkeleton()
    }
}
