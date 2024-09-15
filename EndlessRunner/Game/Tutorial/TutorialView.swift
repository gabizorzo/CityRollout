//
//  TutorialView.swift
//  EndlessRunner
//
//  Created by Gabriela Zorzo on 15/09/24.
//

import UIKit

class TutorialView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var stackView: UIView!
    
    @IBAction func continueButtonAction(_ sender: Any) {
        status = status + 1
        
        if status == 6 {
            print("DISMISS VIEW")
        }
        
        setLabelText()
        setButtonText()
    }
    
    var status: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setLabelText()
        setButtonText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setLabelText()
        setButtonText()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setLabelText() {
        switch status {
        case 1:
            tutorialLabel.text = String(localized: "label1.tutorial")
        case 2:
            tutorialLabel.text = String(localized: "label2.tutorial")
        case 3:
            tutorialLabel.text = String(localized: "label3.tutorial")
        case 4:
            tutorialLabel.text = String(localized: "label4.tutorial")
        case 5:
            tutorialLabel.text = String(localized: "label5.tutorial")
        default:
            break
        }
    }
    
    private func setButtonText() {
        if status == 5 {
            continueButton.setTitle(String(localized: "play.tutorial"), for: .normal)
        } else {
            continueButton.setTitle(String(localized: "continue.tutorial"), for: .normal)
        }
    }
}
