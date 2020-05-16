//
//  OnboardingViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 15/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var verifyNRICBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        verifyNRICBtn.layer.cornerRadius = 4
    }
    
    @IBAction func tapVerifyNRIC(_ sender: Any) {
        performSegue(withIdentifier: "toTakePhotoScreen", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before rnavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
