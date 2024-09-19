//
//  PauseViewController.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 31/07/24.
//

import UIKit

class PauseView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var unpauseButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var menuLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PauseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let overlay = UIView(frame: contentView.frame)
        overlay.isUserInteractionEnabled = false
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        overlay.layer.zPosition = -1
        self.contentView.addSubview(overlay)
        
        unpauseButton.setTitle(String(localized: "pauseView.unpause"), for: .normal)
        unpauseButton.setTitleColor(.white, for: .normal)
        unpauseButton.titleLabel?.numberOfLines = 0
        unpauseButton.titleLabel?.lineBreakMode = .byCharWrapping
        
        menuLabel.text = String(localized: "pauseView.exit")
        menuLabel.font = .boldSystemFont(ofSize: menuLabel.font.pointSize)
        menuLabel.numberOfLines = 0
        menuLabel.lineBreakMode = .byCharWrapping
        
        howToPlayButton.setTitle(String(localized: "pauseView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.lineBreakMode = .byCharWrapping

        adjustButtonsHeight()
    }
    
    private func adjustButtonsHeight() {
        let scalingFactor = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory ? 1.5 : 1.7
        guard let unpauseButtonHeight = unpauseButton.titleLabel?.intrinsicContentSize.height,
              let howToPlayButtonHeight = howToPlayButton.titleLabel?.intrinsicContentSize.height else { return }
        
        unpauseButton.heightAnchor.constraint(equalToConstant: unpauseButtonHeight * scalingFactor).isActive = true
        howToPlayButton.heightAnchor.constraint(equalToConstant: howToPlayButtonHeight * scalingFactor).isActive = true
 
        self.layoutIfNeeded()
    }
    
    //MARK: - Actions
    var unpauseButtonAction: () -> Void = {}
    @IBAction func unpauseAction(_ sender: Any) {
        unpauseButtonAction()
    }
    
    var menuButtonAction: () -> Void = {}
    @IBAction func menuAction(_ sender: Any) {
        menuButtonAction()
    }
    
    var howToPlayButtonAction: () -> Void = {} // passar essa closure na game view e chamar na action abaixo
    @IBAction func howToPlayAction(_ sender: Any) {
        print(#function)
    }
}
