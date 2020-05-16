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

class JourneyViewController: UIViewController {
    
    let scratchthecard = "https://light.microsite.perxtech.io/game/2?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    let spinthewheel = "https://light.microsite.perxtech.io/game/4?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    let shakethetree = "https://light.microsite.perxtech.io/game/8?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    var destinationGame = ""
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
    let defaults = UserDefaults.standard
    
    let popupTitle = "HEY THERE!"
    let popupMessage = "You've unlocked CAREER STARTER! " + "\n" + "Here's a reward on us."
    let popupImage = UIImage(named: "sneki-graduated")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fillProgress), name: .progressFilled, object: nil)
        setupUI()
    }
    
    func transition(){
        discoverDailyOuterView.backgroundColor = UIColor(red:0.46, green:0.08, blue:0.14, alpha:1.0)
        discoverDailyLabel.textColor = .white
        discoverContentLabel.text = "We’re so proud of you. Let us get you ready for new goals! "
    }
    
    @objc func fillProgress() {
        self.createEndowmentAccount()
        progressBarBtn.setBackgroundImage(UIImage(named: "progress-full"), for: .normal)
        isCongradulationReady = true
    }
    
    func congradulationPopup() {
        let popup = PopupDialog(title: popupTitle, message: popupMessage, image: popupImage)
        let claimButton = DefaultButton(title: "CLAIM") {
            self.backgroundView.image = UIImage(named: "bg-2")
            self.snekiSnek.setImage(UIImage(named: "mascot-work"), for: .normal)
            self.transition()
        }
        
        popup.addButtons([claimButton])
        self.present(popup, animated: true, completion: nil)
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
    
    func createEndowmentAccount(){
        let clientID = defaults.string(forKey: "clientID") // fetched during onboarding flow
        
        let createFixedDepAccountURL = "https://razerhackathon.sandbox.mambu.com/api/savings"
        let accountHolderType = "CLIENT"
        let accountState = "APPROVED"
        let productTypeKey = "8a8e867271bd280c0171bf768b9c1a81"
        let allowOverdraft = "false"
        let accountType = "FIXED_DEPOSIT"
        let interestRate = "2"
        
        let user = "Team11"
        let password = "pass8AE7D4715"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        do {
            let deposit = EndowmentAccountModel(savingsAccount: SavingsAccount(accountHolderType: accountHolderType, accountHolderKey: clientID!, accountState: accountState, productTypeKey: productTypeKey, allowOverdraft: allowOverdraft, accountType: accountType, interestSettings: InterestSettings(interestRate: interestRate)))
            let data = try? JSONEncoder().encode(deposit)
            let params = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            AF.request(createFixedDepAccountURL, method: .post, parameters: params, encoding: JSONEncoding.default,  headers: HTTPHeaders(headers)).responseJSON(completionHandler: { _ in
                isSavingsAccountCreated = true
                self.tabBarController?.selectedIndex = 0
            })
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GamesViewController {
            vc.gameURL = self.destinationGame
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
            NotificationCenter.default.post(Notification(name: .progressFilled))
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

