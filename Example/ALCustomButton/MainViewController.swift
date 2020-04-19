//
//  ViewController.swift
//  ALCustomButton
//
//  Created by unalCe on 03/16/2020.
//  Copyright (c) 2020 unalCe. All rights reserved.
//

import UIKit
import ALCustomButton

class MainViewController: UIViewController {
    
    @IBOutlet weak var exampleButton: ALButton!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    
    @IBOutlet weak var titleAlignmentStackView: UIStackView!
    @IBOutlet weak var cornerRadSlider: UISlider!
    
    /// Programmatically
    private lazy var showroomButton: ALButton = {
        let tb = ALButton()
        tb.setTextFont(UIFont(name: "ProximaNova-Bold", size: 16))
        tb.text = "Show me some inspiration!"
        tb.backgroundColor = UIColor(red: 0xFF/255, green: 0xE7/255, blue: 0x5E/255, alpha: 1) // hex: ffe75e
        tb.addTarget(self, action: #selector(navigateToShowroom), for: .touchUpInside)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    
    // MARK: - Properties
    
    private var lightGreen = UIColor(red: 177/255, green: 1, blue: 205/255, alpha: 1)
    private var spotifyGreen = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1)
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrintFontNames()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupExampleButton()
        setupShowroomButtonConstraints()
        
        titleAlignmentStackView.alpha = 0.6
        titleAlignmentStackView.isUserInteractionEnabled = false
    }
    
    // MARK: - UI Setup
    
    private func setupExampleButton() {
        exampleButton.backgroundColor = spotifyGreen
        //exampleButton.setRounded()
        exampleButton.setIconAndText(icon: UIImage(named: "spotify-dark"), text: "Spotify")
        exampleButton.setTextFont(UIFont(name: "ProximaNova-Bold", size: 20))
        exampleButton.setShadow(color: .black, radius: 6, offset: .zero, opacity: 0.4, innerShadows: false)
    }
    
    private func setupShowroomButtonConstraints() {
        view.addSubview(showroomButton)
        
        NSLayoutConstraint.activate([
            showroomButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 60),
            showroomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showroomButton.heightAnchor.constraint(equalToConstant: 50),
            showroomButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    
    // MARK: - Actions
    
    @IBAction func spotifyTapped(_ sender: ALButton) {
        debugPrint("Spotify Tapped")
    }
    
    @IBAction func iconPosifitonChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            exampleButton.setIconPosition(.left)
            exampleButton.setIconSize(32)
        case 1:
            exampleButton.setIconSize(32)
            exampleButton.setIconPosition(.right)
        case 2:
            exampleButton.setIconSize(16)
            exampleButton.setIconPosition(.top)
        case 3:
            exampleButton.setIconSize(16)
            exampleButton.setIconPosition(.bottom)
        default:
            break
        }
    }
    
    @IBAction func contentAlignmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            exampleButton.setContentAlignment(.centered)
            titleAlignmentStackView.alpha = 0.6
            titleAlignmentStackView.isUserInteractionEnabled = false
        case 1:
            exampleButton.setContentAlignment(.spreaded)
            titleAlignmentStackView.alpha = 1
            titleAlignmentStackView.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    
    @IBAction func titleAlignmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            exampleButton.setTextAlignment(.left)
        case 1:
            exampleButton.setTextAlignment(.center)
        case 2:
            exampleButton.setTextAlignment(.right)
        default:
            break
        }
    }
    
    @IBAction func cornerRadiusSliderChanged(_ sender: UISlider) {
        let cornerRad = exampleButton.bounds.height / 2
        let coefficient = CGFloat(sender.value)
        exampleButton.cornerRadius = cornerRad * coefficient
    }
    
    @IBAction func roundButtonTapped(_ sender: UIButton) {
        exampleButton.setRounded()
        cornerRadSlider.setValue(cornerRadSlider.maximumValue, animated: true)
    }
    
    
    @IBAction func shadowSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            exampleButton.setShadow(color: .black, radius: 6, offset: .zero, opacity: 0.4, innerShadows: false)
        } else {
            exampleButton.removeShadows()
        }
    }
    
    
    @IBAction func gradientSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            exampleButton.setGradientBackground(with: [lightGreen, spotifyGreen], direction: .horizontal)
        } else {
            exampleButton.removeGradientBackground()
        }
    }
    
    // MARK: - Navigation
    @objc private func navigateToShowroom() {
        navigationController?.pushViewController(ShowRoomViewController(), animated: true)
    }
    
}


/// MARK: -
extension MainViewController {
    private func debugPrintFontNames() {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
}

