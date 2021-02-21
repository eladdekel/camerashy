//
//  Waitroom.swift
//  swiftuiviews
//
//  Created by Eric Zhang on 2021-02-20.
//
import SwiftUI

struct Waitroom: View {
    var host: Bool
    var code: String
    @State var pushBack = false
    @State var pushForward = false
    @Environment(\.presentationMode) var presentationMode
    let call = CallingHandlers()
    
    var body: some View {
        ScrollView {
            
            NavigationLink(destination: UsualMainView(), isActive: $pushBack) {
                EmptyView()
            }
         
            
            VStack {
                Text("Invite Your Friends")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 50)
                    .foregroundColor(.white)
                Text("Enter the code below to join this room.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(5)
                    .padding(.horizontal, 50)
                    .foregroundColor(.white)
                VStack {
                    HStack {
                        Text(code)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                }
                .background(Color("TextColor"))
                .clipShape(Capsule())
                .padding(.top, 20)
                .padding(.bottom, 50)

                                
            }
            .padding(.top, 50)
            VStack {
                HStack {
                    Text("1/5 people in room")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                }
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
            }
            .background(Color("TextColor"))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.vertical, 20)
            if (host) {
                Button(action: {
                    NotificationCenter.default.post(name: NSNotification.Name("hostBeganGame"), object: nil)
                }){
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            
                        
                        Text("Start Game")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                            .foregroundColor(.white)

                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    
                }
                .background(Color("OrangeColor"))
                .clipShape(Capsule())
                .padding(.bottom, 10)
                .buttonStyle(ScaleButtonStyle())
                
                Button(action: {
                    self.pushBack = true
                    call.cancelGame()
                    NotificationCenter.default.post(name: NSNotification.Name("leaveGameWait"), object: nil)
                }){
                    HStack {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 18, height: 20)
                            .foregroundColor(.white)
                            
                        
                        Text("Cancel Game")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                            .foregroundColor(.white)

                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    
                }
                .background(Color("LightBlue"))
                .clipShape(Capsule())
                .padding(.bottom, 10)
                .buttonStyle(ScaleButtonStyle())
            }
            else {
                Button(action: {
                 //   self.presentationMode.wrappedValue.dismiss()
                    call.onPlayerLeave()
                    NotificationCenter.default.post(name: NSNotification.Name("leaveGameWait"), object: nil)

                    
                }){
                    HStack {
                        Image(systemName: "hand.raised.slash")
                            .resizable()
                            .frame(width: 18, height: 20)
                            .foregroundColor(.white)
                            
                        
                        Text("Leave Game")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                            .foregroundColor(.white)

                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    
                }
                .background(Color("OrangeColor"))
                .clipShape(Capsule())
                .padding(.bottom, 20)
                .buttonStyle(ScaleButtonStyle())
            
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color("MediumBlue").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .navigationBarBackButtonHidden(true)
    }
    


}


struct Waitroom_Previews: PreviewProvider {
    static var previews: some View {
        Waitroom(host: true, code: "ABCDE")
    }
}
