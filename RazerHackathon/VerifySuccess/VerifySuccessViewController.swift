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
    let verifyNRICURL: String = eKYCFwdURL
    let baseURL: String = mambuBaseURL
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bdayLabel: UILabel!
    @IBOutlet weak var birthCountryLabel: UILabel!
    @IBOutlet weak var nricLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
                        
                        setDefaultsValue(key: "branchID", value: branchID)
                        setDefaultsValue(key: "clientID", value: clientID)
                        self.createCurrentAccount()
                    })
                })
            } catch {
                self.showErrorAlert()
            }
        })
    }
    
    func createCurrentAccount(){
        let currentAccountURL = baseURL + "savings"
        let accountHolderType = "CLIENT"
        let accountHolderKey = getDefaultsValue(key: "clientID")
        let accountState = "APPROVED"
        let productTypeKey = "8a8e878471bf59cf0171bf6979700440"
        let allowOverdraft = "true"
        let accountType = "CURRENT_ACCOUNT"
        let interestRate = "1.25"
        
        let currentAccountRequest = CurrentAccountModel(savingsAccount: SavingsAccount(accountHolderType: accountHolderType, accountHolderKey: accountHolderKey, accountState: accountState, productTypeKey: productTypeKey, allowOverdraft: allowOverdraft, accountType: accountType, interestSettings: InterestSettings(interestRate: interestRate)))
        
        let data = try? JSONEncoder().encode(currentAccountRequest)
        
        do {
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            
            let headers = mambuBasicAuth()
            
            AF.request(currentAccountURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON(completionHandler: {
                _ in
            })
        } catch {
            print(error)
        }
    }
    
    func createClientID(branchID: String, credentials: NRICModel, onCompletion: @escaping ((_ response: String) -> Void)){
        let clientsURL = baseURL + "clients"
        
        let nameArr = credentials.vision.extract.name.components(separatedBy: " ")
        let firstName = nameArr.first ?? ""
        let lastName = nameArr.last ?? ""
        let idTempKey = "8a8e867271bd280c0171bf7e4ec71b01"
        let docType = "NRIC/Passport Number"
        let docId = credentials.vision.extract.idNum
        
        let client = ClientModel(client: Client(firstName:firstName, lastName: lastName, assignedBranchKey: branchID), idDocuments: [IDDocuments(identificationDocumentTemplateKey: idTempKey, documentType: docType, documentId: docId)])
        
        let data = try? JSONEncoder().encode(client)
        
        do {
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            let headers = mambuBasicAuth()
            
            
            AF.request(clientsURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON { response in
                
                let result = try? JSONDecoder().decode(ClientModelResponse.self, from: response.data!)
                if let id = result?.client.encodedKey {
                    onCompletion(id)
                } else {
                    onCompletion("")
                }
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
    
    fileprivate func showErrorAlert() {
        let alert = UIAlertController(title: "Your picture wasn't super clear", message: "Let's retake the photo, yeah?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    fileprivate func setupUI() {
        showAnimatedSkeleton()
        overrideUserInterfaceStyle = .light
        continueBtn.layer.cornerRadius = 4
        continueBtn.isEnabled = false
        retakeBtn.layer.cornerRadius = 4
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
    
    @IBAction func tapRetakeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapContinueBtn(_ sender: Any) {
        performSegue(withIdentifier: "toHomeScreen", sender: nil)
    }
}
