//
//  ShowRoomViewController.swift
//  ALCustomButton_Example
//
//  Created by Unal Celik on 18.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ALCustomButton

class ShowRoomViewController: UIViewController {
    
    private var viewHeight: CGFloat {
        view.bounds.height
    }
    
    private var viewWidth: CGFloat {
        view.bounds.width
    }
    
    private var buttonStartXPoint: CGFloat {
        viewWidth * 0.05
    }
    
    private func buttonStartYPoint(for index: Int) -> CGFloat {
            viewHeight * 0.2
            + buttonHeight * CGFloat(index)
            + CGFloat(index - 1) * spaceBetweenButtons
    }
    
    private var buttonWidth: CGFloat {
        viewWidth * 0.9
    }
    
    private var buttonHeight: CGFloat = 50
    
    private var spaceBetweenButtons: CGFloat = 40

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBarTransparent()
        
        title = "ALCustomButton"
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        makeSoundCloudButton()
        makeFacebookButton()
        makeAppleSignIn()
        makeCepYolButton()
        makeAppleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Setup
    // Few examples to give some idea
    
    private func makeSoundCloudButton() {
        let lightOrange = UIColor(red: 0xFF/255, green: 0x95/255, blue: 0x33/255, alpha: 1)   // FF9533
        let darkOrange = UIColor(red: 254/255, green: 80/255, blue: 0, alpha: 1) // RGB: (254 80 0)
        
        let scButton = ALButton(frame: CGRect(x: buttonStartXPoint, y: buttonStartYPoint(for: 0), width: buttonWidth, height: buttonHeight))
        
        scButton.setRounded()
        scButton.setIconAndText(icon: UIImage(named: "soundcloud-light"),
                                text: "SOUNDCLOUD")
        scButton.setGradientBackground(with: [lightOrange, darkOrange],
                                       direction: .vertical)
        scButton.setContentAlignment(.spreaded)
        scButton.setTextFont(.systemFont(ofSize: 20, weight: .semibold))
        scButton.setTextColor(.white)
        
        view.addSubview(scButton)
    }

    private func makeFacebookButton() {
        let facebookBlue = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        
        let fbButton = ALButton(frame: CGRect(x: buttonStartXPoint, y: buttonStartYPoint(for: 1), width: buttonWidth, height: buttonHeight))
        fbButton.cornerRad = 12
        fbButton.text = "Facebook"
        fbButton.icon = #imageLiteral(resourceName: "facebook")
        fbButton.setTextColor(facebookBlue)
        fbButton.setTextFont(.systemFont(ofSize: 18, weight: .semibold))
        fbButton.setBorder(width: 1, color: facebookBlue)
        fbButton.setContentAlignment(.spreaded)
        
        view.addSubview(fbButton)
    }
    
    private func makeAppleSignIn() {
        let apButton = ALButton(frame: CGRect(x: buttonStartXPoint, y: buttonStartYPoint(for: 2), width: buttonWidth, height: buttonHeight))
        apButton.backgroundColor = .black
        apButton.setContentAlignment(.centered) // Default
        apButton.setIconAndText(icon: UIImage(named: "apple-light"),
                                text: "Sign in with Apple")
        apButton.setIconSize(24)
        apButton.setTextColor(.white)
         /// Human Interface Guidelines recommends using %43 of the button's height as the font size.
        apButton.setTextFont(.systemFont(ofSize: buttonHeight * 0.43, weight: .medium))
        apButton.cornerRad = 5
        
        view.addSubview(apButton)
    }
    
    private func makeCepYolButton() {
        let cyButton = ALButton(frame: CGRect(x: buttonStartXPoint, y: buttonStartYPoint(for: 3),
                                              width: buttonWidth, height: buttonHeight))
        cyButton.setupCYButtonWith(title: "Find Flight Tickets")
        view.addSubview(cyButton)
    }
    
    private func makeAppleButton() {
        let apButton = ALButton(frame: CGRect(x: view.center.x - 30,
                                              y: buttonStartYPoint(for: 4),
                                              width: 60,
                                              height: 60))
        apButton.backgroundColor = .clear
        apButton.setBorder(width: 1.5, color: .black)
        apButton.cornerRad = 6
        apButton.icon = #imageLiteral(resourceName: "apple-dark")
        apButton.setIconSize(30)
        
        view.addSubview(apButton)
    }
}


/// - You can define an extension method to set up your app specific button once and use with ease whenever needed.
extension ALButton {
    
    public func setupCYButtonWith(title: String) {
        self.cornerRad = 8
        self.setIconAndText(icon: UIImage(named: "plane-light"), text: title)
        self.setTextColor(.white)
        self.setTextFont(.systemFont(ofSize: self.bounds.height * 0.43, weight: .semibold))
        self.setContentAlignment(.spreaded)
        
        let cepYolBlue = UIColor(red: 28/255, green: 87/255, blue: 238/255, alpha: 1)
        self.backgroundColor = cepYolBlue
        self.setShadow(color: cepYolBlue, radius: 6, offset: CGSize(width: 3, height: 4), opacity: 0.5, innerShadows: false)
    }
}


extension ShowRoomViewController {
    func makeNavigationBarTransparent()  {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
