


import SwiftUI
import UIKit

struct VCSwiftUIView: UIViewControllerRepresentable {
    let storyboard: String = "Main"
    let VC: String = "GameSetup"

  func makeUIViewController(context: UIViewControllerRepresentableContext<VCSwiftUIView>) -> ViewController {
    
    //Load the storyboard
    let loadedStoryboard = UIStoryboard(name: storyboard, bundle: nil)
    
    //Load the ViewController
     return loadedStoryboard.instantiateViewController(withIdentifier: VC) as! ViewController
    
  }
  
  func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<VCSwiftUIView>) {
  }
}
