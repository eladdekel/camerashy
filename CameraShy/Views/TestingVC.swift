//
//  TestingVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit
import Alamofire

class TestingVC: UIViewController {

    @IBOutlet weak var buttonPlease: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressButton(_ sender: Any) {
        let parameters: Parameters = [
            "osId": "590c5ab9-0425-40bc-92f7-5af17b3734cf",
            "msg": "hello"
         ]

        
        AF.request("http://camera-shy.space/api/test_notif", method: .put, parameters: parameters).response {
            response in
            print(response)
            
        }

        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
