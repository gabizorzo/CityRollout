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
        menuButton.setTitle(String(localized: "pauseView.exit"), for: .normal)
        menuButton.setTitleColor(.white, for: .normal)
        howToPlayButton.setTitle(String(localized: "pauseView.howToPlay"), for: .normal)
        howToPlayButton.setTitleColor(.white, for: .normal)
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
