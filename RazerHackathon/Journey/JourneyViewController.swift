//
//  JourneyViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire
import SwiftSpinner

class JourneyViewController: UIViewController {
    
    let scratchthecard = scratchGameURL
    let spinthewheel = spinGameURL
    let shakethetree = shakeGameURL
    var destinationGame = ""
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var discoverDailyOuterView: UIView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var gamesView: UIView!
    @IBOutlet var playToLevelUpBtn: UIView!
    @IBOutlet weak var progressBarBtn: UIButton!
    @IBOutlet weak var dimThisView: UIView!
    @IBOutlet weak var questBtn: UIButton!
    @IBOutlet weak var questYConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var snekiSnek: UIButton!
    @IBOutlet weak var upgradedBanner: UIImageView!
    @IBOutlet weak var upgradedBannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var discoverDailyLabel: UILabel!
    @IBOutlet weak var discoverContentLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GamesViewController {
            vc.gameURL = self.destinationGame
        }
    }
    
    func transition(){
        discoverDailyOuterView.backgroundColor = UIColor(red:0.46, green:0.08, blue:0.14, alpha:1.0)
        discoverDailyLabel.textColor = .white
        discoverContentLabel.text = "We’re so proud of you. Let us get you ready for new goals! "
    }
    
    func congradulationPopup() {
        let popupTitle = "HEY THERE!"
        let popupMessage = "You've unlocked CAREER STARTER! " + "\n" + "Here's a reward on us."
        let popupImage = UIImage(named: "sneki-graduated")
        let popup = PopupDialog(title: popupTitle, message: popupMessage, image: popupImage)
        let claimButton = DefaultButton(title: "CLAIM") {
            self.backgroundView.image = UIImage(named: "bg-2")
            self.snekiSnek.setImage(UIImage(named: "mascot-work"), for: .normal)
            self.progressBarBtn.setBackgroundImage(UIImage(named: "progress"), for: .normal)
            self.transition()
        }
        
        popup.addButtons([claimButton])
        self.present(popup, animated: true, completion: nil)
    }
    

    
    func createEndowmentAccount(){
        let clientID = defaults.string(forKey: "clientID") // fetched during onboarding flow
        let createFixedDepAccountURL = "https://razerhackathon.sandbox.mambu.com/api/savings"
        let accountHolderType = "CLIENT"
        let accountState = "APPROVED"
        let productTypeKey = "8a8e867271bd280c0171bf768b9c1a81"
        let allowOverdraft = "false"
        let accountType = "FIXED_DEPOSIT"
        let interestRate = "2"
        
        let headers = mambuBasicAuth()
        
        do {
            let deposit = EndowmentAccountModel(savingsAccount: SavingsAccount(accountHolderType: accountHolderType, accountHolderKey: clientID!, accountState: accountState, productTypeKey: productTypeKey, allowOverdraft: allowOverdraft, accountType: accountType, interestSettings: InterestSettings(interestRate: interestRate)))
            let data = try? JSONEncoder().encode(deposit)
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            AF.request(createFixedDepAccountURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: headers).responseJSON(completionHandler: { _ in
                isSavingsAccountCreated = true
                SwiftSpinner.show(duration: 4.0, title: "Creating an Endowment Plan for you...").addTapHandler({
                    SwiftSpinner.hide()
                })
                self.tabBarController?.selectedIndex = 0
            })
        } catch {
            print(error)
        }
    }
    
    func animateBanner(){
        view.layoutIfNeeded()
        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseIn, animations: {
            self.upgradedBanner.alpha = 1
            self.upgradedBannerTopConstraint.constant += 16
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: {
            self.upgradedBanner.alpha = 0
            self.upgradedBannerTopConstraint.constant += 16
            self.view.layoutIfNeeded()
            
        })
    }
    
    fileprivate func setupUI() {
        questBtn.adjustsImageWhenHighlighted = false
        questBtn.adjustsImageWhenDisabled = false
        overrideUserInterfaceStyle = .light
        enterBtn.layer.cornerRadius = 8
        gamesView.roundCorners([.topRight, .topLeft], radius: 16)
        playToLevelUpBtn.layer.cornerRadius = 8
        discoverDailyOuterView.layer.cornerRadius = 8
        discoverDailyOuterView.layer.masksToBounds = false
        discoverDailyOuterView.layer.shadowRadius = 4
        discoverDailyOuterView.layer.shadowOpacity = 1
        discoverDailyOuterView.layer.shadowColor = UIColor.gray.cgColor
        discoverDailyOuterView.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
    
    @IBAction func onTapProgress(_ sender: Any) {
        if !progressFilled {
            UIView.animate(withDuration: 0.3, animations: {
                self.dimThisView.alpha = 0.5
                self.questBtn.alpha = 1
                self.questYConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else if progressFilled && !isBannerReady && isCongradulationReady{
            congradulationPopup()
            isBannerReady = true
        } else if progressFilled && isBannerReady && isCongradulationReady{
            animateBanner()
            progressBarBtn.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onTapQuest(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimThisView.alpha = 0
            self.questBtn.alpha = 0
            self.questYConstraint.constant = 32
            self.view.layoutIfNeeded()
            progressFilled = true
            self.createEndowmentAccount()
            self.progressBarBtn.setBackgroundImage(UIImage(named: "progress-full"), for: .normal)
            isCongradulationReady = true
        })
    }
    
    @IBAction func tapEnter(_ sender: Any) {
        performSegue(withIdentifier: "toDiscoverDailyScreen", sender: nil)
    }
    
    @IBAction func tapSpin(_ sender: Any) {
        self.destinationGame = spinthewheel
        performSegue(withIdentifier: "toGamesScreen", sender: nil)
    }
    
    @IBAction func tapScratch(_ sender: Any) {
        self.destinationGame = scratchthecard
        performSegue(withIdentifier: "toGamesScreen", sender: nil)
    }
    
    @IBAction func tapShake(_ sender: Any) {
        self.destinationGame = shakethetree
        performSegue(withIdentifier: "toGamesScreen", sender: nil)
    }
}

