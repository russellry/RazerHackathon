//
//  JourneyViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit

class JourneyViewController: UIViewController {

    let scratchthecard = "https://light.microsite.perxtech.io/game/2?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    let spinthewheel = "https://light.microsite.perxtech.io/game/4?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    let shakethetree = "https://light.microsite.perxtech.io/game/7?token=a97c73454236f3d093d64cdb2884be1ee6908dd2f7815c3eba5641ee6315ee64"
    var destinationGame = ""
    @IBOutlet weak var discoverDailyOuterView: UIView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var gamesView: UIView!
    @IBOutlet var playToLevelUpBtn: UIView!
    @IBOutlet weak var progressImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GamesViewController {
            vc.gameURL = self.destinationGame
        }
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

