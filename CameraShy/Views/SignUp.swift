//
//  SignUp.swift
//  CameraShy
//
//  Created by Eric Zhang on 2021-02-19.
//

import SwiftUI
import AuthenticationServices
import Alamofire
import AVKit


struct SignUp: View {
    @State var continueNext: Bool = false

    
    
    var body: some View {
        VStack {
            Text("Sign Up/Log In")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .lineLimit(2)
                .padding(.top, 50)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                .padding(.bottom, 20)
//                AppleSignInButton()
//                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                    .scaleEffect(1.5)
                 
            NavigationLink(destination: Profile(), isActive: $continueNext) {
                                EmptyView()
                            }
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    continueNext = false

                    switch result {
                        case .success(let authResults):
                            
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                
                                UserDefaults().setValue(appleIDCredential.user, forKey: "AppleInfoUser")
                                UserDefaults().setValue(appleIDCredential.fullName, forKey: "AppleInfoName")
                                UserDefaults().setValue(appleIDCredential.email, forKey: "AppleInfoEmail")

                                      print("worked!")
                                      
                                  default:
                                      break
                                  }
                 
                            
                            continueNext = true
                            
                            break
                        case .failure(let error):
                            continueNext = false
                            print("Authorisation failed: \(error.localizedDescription)")
                    }
                }
                // black button
                .signInWithAppleButtonStyle(.black)
                .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .scaleEffect(1.5)
            
            
//            // white button
//            .signInWithAppleButtonStyle(.white)
//            // white with border
//            .signInWithAppleButtonStyle(.whiteOutline)
            
            Text("By signing up, you agree to adhere by our Terms of Service and acknowledge that you have read the Privacy Policy. ")
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.top, 15)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("MediumBlue").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
    }
}

struct AppleSignInButton: UIViewRepresentable {
     func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()

     }
     func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context:
     Context) {
     }
}


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
