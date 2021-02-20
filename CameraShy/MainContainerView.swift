//
//  MainContainerView.swift
//  CameraShy
//
//  Created by Eric Zhang on 2021-02-20.
//

import SwiftUI
import AVKit

struct MainContainerView: View {    
    @State var image: UIImage? = nil
    @State var showCaptureImageView = false
    @State var showAlert = false
    @ObservedObject var test = ImageUploader()

    var alert: Alert {
        Alert(title: Text("Camera Access Required"), message: Text("This app requires camera access to function. If you would like to continue using CameraShy, please go to Settings and allow Camera access."), dismissButton: .default(Text("OK")))
    }
    var body: some View {
        ZStack {
            // UIKit views go here?
            VStack {
                Spacer()
                
                if image != nil {
                    
                }
                HStack {
                    Spacer()
                    Button(action: {
                        switch AVCaptureDevice.authorizationStatus(for: .video) {
                            case .authorized:
                                self.showCaptureImageView.toggle() // The user has previously granted access to the camera.
                                                    
                            case .notDetermined: // The user has not yet been asked for camera access.
                                AVCaptureDevice.requestAccess(for: .video) { granted in
                                    if granted {
                                        self.showCaptureImageView.toggle()
                                    }
                                }

                            case .denied:
                                self.showAlert.toggle()// The user has previously denied access.
                                return

                            case .restricted: // The user can't grant access due to restrictions.
                                self.showAlert.toggle()
                                return
                            @unknown default:
                                self.showAlert.toggle()
                                return
                            }
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundColor(.white)
                                
                            
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 16)
                    }
                    .background(Color("ButtonColor"))
                    .clipShape(Capsule())
                    .buttonStyle(ScaleButtonStyle())
                    .alert(isPresented: $showAlert, content: {self.alert})
                    .sheet(isPresented: $showCaptureImageView) {
                        CaptureImageView(isShown: $showCaptureImageView, image: $image)
                            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))

                    }
                    .padding(.vertical, 10)

                    Spacer()
                   
                }
                .cornerRadius(5)
                .background(Color("LightBlue").edgesIgnoringSafeArea(.bottom))
            }

        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)

    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerView()
    }
}
