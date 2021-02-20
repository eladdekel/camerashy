//
//  GameCreationVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit

class GameCreationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputGameName: UITextField!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var gameName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        UISetup()
        inputGameName.delegate = self

        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         
             // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    func UISetup() {
        mainView.backgroundColor = UIColor(named: "MediumBlue")
       // inputGameName.backgroundColor = UIColor(named: "backgroundTextblock")
        inputGameName.adjustsFontSizeToFitWidth = true
        let customFont:UIFont = UIFont.init(name: "Helvetica", size: 32)!
        inputGameName.font = customFont
        inputGameName.adjustsFontSizeToFitWidth = true
        errorLabel.text = ""
        inputGameName.placeholder = "Input Team Name Here"
        nextButton.layer.cornerRadius = 20
        
    }

    @IBAction func nextButton(_ sender: Any) {
        if inputGameName.text != nil && inputGameName.text != "" {
            if inputGameName.text!.count > 3 {
                
                gameName = inputGameName.text!
                performSegue(withIdentifier: "gameSettings", sender: gameName)
                
                
            } else {
                errorLabel.text = "The Game Name must be longer than 3 characters."
            }
    }
        errorLabel.text = "Input a valid Game Name"
  

}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSettings" {
            let destVC = segue.destination as! GameSettingsVC
            destVC.gameName = sender as! String
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - (keyboardSize.height / 2)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    

}
