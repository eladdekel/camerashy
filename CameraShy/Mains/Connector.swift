


import SwiftUI
import UIKit

struct VCSwiftUIView: UIViewControllerRepresentable {
    let storyboard: String = "Main"
    let VC: String = "GameSettingsVC"

  func makeUIViewController(context: UIViewControllerRepresentableContext<VCSwiftUIView>) -> GameSettingsVC {
    
    //Load the storyboard
    let loadedStoryboard = UIStoryboard(name: storyboard, bundle: nil)
    
    //Load the ViewController
     return loadedStoryboard.instantiateViewController(withIdentifier: VC) as! GameSettingsVC
    
  }
  
  func updateUIViewController(_ uiViewController: GameSettingsVC, context: UIViewControllerRepresentableContext<VCSwiftUIView>) {
  }
}
