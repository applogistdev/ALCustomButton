//
//  ViewController.swift
//  ALCustomButton
//
//  Created by unalCe on 03/16/2020.
//  Copyright (c) 2020 unalCe. All rights reserved.
//

import UIKit
import ALCustomButton

class ViewController: UIViewController {
    
    @IBOutlet weak var exampleButton: ALButton!
    
    @IBOutlet weak var titleAlignmentStackView: UIStackView!
    @IBOutlet weak var cornerRadSlider: UISlider!
    
    private lazy var toggleButton: ALButton = {
        let tb = ALButton()
        tb.setRounded()
        tb.text = "Show me some inspiration!"
        tb.setTextColor(.orange)
        tb.addTarget(self, action: #selector(colorToggleButtonTapped), for: .touchUpInside)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    // MARK: - Properties
    
    private var spotifyGreen = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1)
    // private var facebookBlue
    
    
    private var isInDarkMode: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = ALButton(frame: CGRect(x: 50, y: 450, width: 250, height: 50))
        button.setRounded()
        button.backgroundColor = .orange
        button.text = "Deneme Shadow"
        button.setBorder(width: 0)
        button.setShadow(color: .darkGray, radius: 6, offset: .zero, opacity: 0.4, innerShadows: false)
        
        view.addSubview(button)
        
        debugPrintFontNames()
        
        setupExampleButton()
        
        titleAlignmentStackView.alpha = 0.6
        titleAlignmentStackView.isUserInteractionEnabled = false
    }
    
    
    // MARK: - UI Setup
    
    private func setupExampleButton() {
        exampleButton.backgroundColor = spotifyGreen
        // exampleButton.setGradientBackground(with: [.red, .orange])
        exampleButton.setRounded()
        exampleButton.setBorder(width: 0)
        exampleButton.setIconAndText(icon: UIImage(named: "spotify-dark"), text: "Spotify")
        exampleButton.setTextFont(UIFont(name: "ProximaNova-Bold", size: 20))
        exampleButton.setShadow(color: .black, radius: 6, offset: .zero, opacity: 0.4, innerShadows: false)
    }
    
    private func setupExamplesNavigationButton() {
        
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
            exampleButton.setShadow(color: .darkGray, radius: 6, offset: .zero, opacity: 0.4, innerShadows: false)
        } else {
            exampleButton.clearShadows()
        }
    }
    
    
    @objc func colorToggleButtonTapped(_ sender: ALButton) {
        isInDarkMode.toggle()
        
        if isInDarkMode {
            exampleButton.icon = UIImage(named: "spotify-green")
            exampleButton.backgroundColor = .clear
            exampleButton.setBorder(width: 2, color: spotifyGreen)
            exampleButton.setTextColor(spotifyGreen)
            exampleButton.setContentAlignment(.centered)
        } else {
            exampleButton.icon = UIImage(named: "spotify-dark")
            exampleButton.backgroundColor = spotifyGreen
            exampleButton.setBorder(width: 0)
            exampleButton.setTextColor(.black)
            exampleButton.setIconPosition(.bottom)
            exampleButton.setIconSize(12)
            exampleButton.setContentAlignment(.spreaded)
        }
    }
    
}


/// MARK: -
extension ViewController {
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

