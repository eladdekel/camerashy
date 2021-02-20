


import SwiftUI
import UIKit

struct VCSwiftUIView: UIViewControllerRepresentable {
    let storyboard: String = "Main"
    let VC: String = "GameSetup"

  func makeUIViewController(context: UIViewControllerRepresentableContext<VCSwiftUIView>) -> UINavigationController {
    
    //Load the storyboard
    let loadedStoryboard = UIStoryboard(name: storyboard, bundle: nil)
    
    //Load the ViewController
     return loadedStoryboard.instantiateViewController(withIdentifier: VC) as! UINavigationController
    
  }
  
  func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<VCSwiftUIView>) {
  }
}
