//
//  WaitRoomAdapter.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit
import SwiftUI

class WaitRoomAdapter: UIViewController {

    var host: Bool = false
    var gameId: String = ""
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

  
        
        let contentView = UIHostingController(rootView: Waitroom(host: host, code: gameId))
        
        // Do any additional setup after loading the view.
        addChild(contentView)
        view.addSubview(contentView.view)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("hostBeganGame"), object: nil, queue: nil) { (_) in
            self.presentingViewController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("openModule"), object: nil)
            })
            
           

        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("leaveGameWait"), object: nil, queue: nil) { (_) in
            self.presentingViewController?.dismiss(animated: true)
        
        }
        
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    

  

}
