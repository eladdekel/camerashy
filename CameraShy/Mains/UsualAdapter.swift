//
//  WelcomeAdapter.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit
import SwiftUI
import STPopup

class UsualAdapter: UIViewController, GameEndedDelegate {


    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var awardView: AlertView!
    let contentView = UIHostingController(rootView: UsualMainView())
    var timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hello")
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("openModule"), object: nil, queue: nil) { (_) in
            self.presentingViewController?.dismiss(animated: true)
            self.performSegue(withIdentifier: "gameOn", sender: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("hostGameStart"), object: nil, queue: nil) { (_) in
            self.performSegue(withIdentifier: "hostGameStart", sender: nil)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("createGame"), object: nil, queue: nil) { (_) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameSettingsVC") as! GameSettingsVC
            self.present(vc, animated: true)
          //  self.performSegue(withIdentifier: "createGame", sender: nil)
        }
        
        
      //  lossNumber(2)  RUN LOSSNUMBER WHEN GAME ENDS
    }
    @objc func backgroundViewDidTap() {
        dismiss(animated: true)
    }

    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }
    
    func blur() {
        awardView.layer.opacity = 0.95
        awardView.layer.cornerRadius = 15
        awardView.roundCorners(corners: .allCorners, radius: 15)
        awardView.backgroundColor = UIColor(named: "TextColor")
       
        
        
    }
    
    
    func gameEnded(_ players: Double, _ time: String, _ kills: Double) {
        lossNumber(Int(players))
    }
    
    
    
    func lossNumber(_ loss: Int) {
        blur()
        numberLabel.text = "\(loss)"
        switch loss {
        case 1:
            awardView.backgroundColor = UIColor(named: "OrangeColor")
            endLabel.text = "st"
            messageLabel.text = "Congratulations! You Won!"
            endLabel.textColor = .black
            messageLabel.textColor = .black
            numberLabel.textColor = .black
        case 2:
            endLabel.text = "nd"
            messageLabel.text = "So close! Good job."
            endLabel.textColor = .white
            messageLabel.textColor = .white
            numberLabel.textColor = .white
        case 3:
            endLabel.text = "rd"
            messageLabel.text = "So close... yet still far away."
            endLabel.textColor = .white
            messageLabel.textColor = .white
            numberLabel.textColor = .white
        default:
            endLabel.text = "th"
            endLabel.textColor = .white
            messageLabel.textColor = .white
            numberLabel.textColor = .white
        }
        
        view.bringSubviewToFront(awardView)
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(timeEnds), userInfo: nil, repeats: false)
    }
 
    @objc func timeEnds() {
        UIView.animate(withDuration: 2) {
            self.awardView.alpha = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hostGameStart" {
            let destvc = segue.destination as! WaitRoomAdapter
            destvc.host = true
        }
        if segue.identifier == "gameOn" {
            let destvc = segue.destination as! GameMechVC
            destvc.delegate = self
            
        }
    }
    
}
