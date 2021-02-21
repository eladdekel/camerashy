//
//  Profile.swift
//  CameraShy
//
//  Created by Eric Zhang on 2021-02-19.
//
import SwiftUI
import AVKit
import Alamofire

struct Profile: View {
    @State var image: UIImage? = nil
    @State var showCaptureImageView = false
    @State var showAlert = false
    @ObservedObject var imgupload = ImageUploader()
    var alert: Alert {
        Alert(title: Text("Camera Access Required"), message: Text("This app requires camera access to function. If you would like to continue using CameraShy, please go to Settings and allow Camera access."), dismissButton: .default(Text("OK")))
    }


    var body: some View {
        VStack {
            Text("Complete Your Profile")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 50)
                .foregroundColor(.white)
                .padding(.bottom, 20)
                 
            ZStack {
                VStack {
                    if (image != nil) {
                        Image(uiImage:image!).resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 8))
                            .shadow(radius: 10)
                        Spacer()
                    }
                    else {
                        Image(systemName: "faceid")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    VStack {
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
                                    
                                
                                Text("Take Photo")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 16)
                        }
                        .background(Color("ButtonColor"))
                        .clipShape(Capsule())
                        .buttonStyle(ScaleButtonStyle())
                        .alert(isPresented: $showAlert, content: {self.alert})

                        if (image != nil) {
                            NavigationLink(destination: UsualMainView(), isActive: $imgupload.ahead){
                                HStack {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .frame(width: 25, height: 20)
                                        .foregroundColor(.white)
                                        
                                    
                                    Text("Continue")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 16)
                                .onTapGesture {
                                    imgupload.uploadImage(image: image!)
                                }

                            }
                            .background(Color("ButtonColor"))
                            .clipShape(Capsule())
                            .buttonStyle(ScaleButtonStyle())
                       

                        }
                    }
                    .padding(.bottom, 100)

                    
                }
                .sheet(isPresented: $showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image)
                        .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))

                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("MediumBlue").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .navigationBarBackButtonHidden(true)

    }
}

class ImageUploader: ObservableObject {
    @Published var ahead = false
    
 
    func uploadImage(image: UIImage) {
        let api_url = "https://api.imgur.com/3/image"
        let url = URL(string: api_url)

        var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let imgData = image.jpegData(compressionQuality: 0.5)!

            AF.upload(multipartFormData: { multiPart in
                multiPart.append(imgData, withName: "image", fileName: "file.png", mimeType: "image/png")
            }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in

                           switch data.result {

                           case .success(_):
                            do {
                                
                                DispatchQueue.main.async {
                                    self.ahead = true
                                }
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                              
                                print("Success!")
                                print(dictionary)
                           }
                           catch {
                              // catch error.
                            print("catch error")

                                  }
                            break
                                
                           case .failure(_):
                            print("failure")

                            break
                            
                        }


                })
    }

}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: UIImage?
    init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = unwrapImage
        isCoordinatorShown = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}


struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, image: $image)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera

        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
