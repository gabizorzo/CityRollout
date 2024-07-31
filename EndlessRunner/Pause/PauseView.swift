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
        menuButton.setTitle("Go to Menu", for: .normal)
    }
    
    
    //MARK: - Actions
    var unpauseButtonAction: () -> Void = {}
    @IBAction func unpauseAction(_ sender: Any) {
        unpauseButtonAction()
    }
    
    @IBAction func menuAction(_ sender: Any) {
        print("Menu Action")
    }
    
}
