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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    
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
        
        unpauseButton.setTitle(String(localized: "pauseView.unpause"), for: .normal)
        unpauseButton.setTitleColor(.white, for: .normal)
        unpauseButton.titleLabel?.numberOfLines = 0
        unpauseButton.titleLabel?.lineBreakMode = .byCharWrapping
        
        menuButton.setTitle(String(localized: "pauseView.exit"), for: .normal)
        menuButton.setTitleColor(.white, for: .normal)
        menuButton.titleLabel?.numberOfLines = 0
        menuButton.titleLabel?.lineBreakMode = .byCharWrapping
        
        howToPlayButton.setTitle(String(localized: "pauseView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        howToPlayButton.titleLabel?.numberOfLines = 0
        howToPlayButton.titleLabel?.lineBreakMode = .byCharWrapping

        let scalingFactor = UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory ? 1.85 : 1.95
        guard let unpauseButtonHeight = unpauseButton.titleLabel?.intrinsicContentSize.height,
              let menuButtonHeight = menuButton.titleLabel?.intrinsicContentSize.height,
              let howToPlayButtonHeight = howToPlayButton.titleLabel?.intrinsicContentSize.height else { return }
        
        if let unpauseButtonHeightContraint = unpauseButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }),
           let menuButtonHeightConstraint = menuButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }),
           let howToPlayButtonButtonHeightConstraint = howToPlayButton.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal })
        {
            unpauseButtonHeightContraint.constant = unpauseButtonHeight * scalingFactor
            menuButtonHeightConstraint.constant = menuButtonHeight * scalingFactor
            howToPlayButtonButtonHeightConstraint.constant = howToPlayButtonHeight * scalingFactor
        }
        
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
