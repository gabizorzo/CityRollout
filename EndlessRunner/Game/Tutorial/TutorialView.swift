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
    @IBOutlet weak var imageView: UIImageView!
    
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
            setImage(visible: false)
            tutorialLabel.text = String(localized: "label1.tutorial")
        case 2:
            tutorialLabel.text = String(localized: "label2.tutorial")
        case 3:
            setImage(visible: true)
        case 4:
            setImage(visible: false)
            tutorialLabel.text = String(localized: "label3.tutorial")
        case 5:
            setImage(visible: true)
        case 6:
            setImage(visible: false)
            tutorialLabel.text = String(localized: "label4.tutorial")
        case 7:
            tutorialLabel.text = String(localized: "label5.tutorial")
        default:
            break
        }
    }
    
    private func setButtonText() {
        if status >= 7 {
            continueButton.setTitle(String(localized: "play.tutorial"), for: .normal)
        } else {
            continueButton.setTitle(String(localized: "continue.tutorial"), for: .normal)
        }
    }
    
    private func setImage(visible: Bool) {
        imageView.image = UIImage(named: "tutorial.arrows.png")
        
        if visible {
            imageView.isHidden = false
            tutorialLabel.isHidden = true
        } else {
            imageView.isHidden = true
            tutorialLabel.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self).x
        
        let location = touchLocation > UIScreen.main.bounds.width/2 ? 1.0 : -1.0
        
        movePlayer(location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        stopPlayer()
    }
    
    var movePlayer: (_ location: Double) -> Void = { location in }
    var stopPlayer: () -> Void = {}
}
