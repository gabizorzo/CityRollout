//
//  MenuView.swift
//  EndlessRunner
//
//  Created by João Dall Agnol on 22/07/24.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        startButton.setTitle(" Tap to play", for: .normal)
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}
