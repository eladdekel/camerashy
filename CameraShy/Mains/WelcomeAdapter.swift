//
//  WelcomeAdapter.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit
import SwiftUI

class WelcomeAdapter: UIViewController {

    let contentView = UIHostingController(rootView: Welcome())

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    

    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }

}
