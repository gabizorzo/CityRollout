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
        overlay.layer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        overlay.layer.zPosition = -1
        self.contentView.addSubview(overlay)
        
        let buttonInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        unpauseButton.setTitle(String(localized: "pauseView.unpause"), for: .normal)
        unpauseButton.setTitleColor(.white, for: .normal)
        var buttonConfig = unpauseButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        unpauseButton.configuration = buttonConfig
        
        menuLabel.text = String(localized: "pauseView.exit")
        if let boldFontDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .body)
            .withSymbolicTraits(.traitBold) {
            menuLabel.font = UIFont(descriptor: boldFontDescriptor, size: 0.0)
        }
        
        howToPlayButton.setTitle(String(localized: "pauseView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
        buttonConfig = howToPlayButton.configuration
        buttonConfig?.contentInsets = buttonInsets
        buttonConfig?.titleLineBreakMode = .byTruncatingTail
        howToPlayButton.configuration = buttonConfig
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
