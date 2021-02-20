//
//  UsualMainView.swift
//  CameraShy
//
//  Created by Eric Zhang on 2021-02-20.
//

import SwiftUI
import Foundation

struct UsualMainView: View {
    @State var code = ""
    @State var teamName = ""
    @State private var isPresented = false


    var body: some View {
        ZStack {
            
            ScrollView() {
                VStack {
                    
                    HStack {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 20)

                        Text("Your Gallery")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                        Spacer()

                    }
                    .padding(.top, 15)

                    
                    Text("No photos yet... join a game for photos to appear here!")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 80)
                }
                Divider()
                VStack {
                    
                    HStack {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .frame(width: 25, height: 17)
                            .foregroundColor(.white)
                            .padding(.leading, 20)

                        Text("Join a Game")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                        Spacer()

                    }
                    .padding(.top, 15)
                    
                    VStack {
                        TextField("Enter Code", text: $code)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("LightBlue"))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                     
                        }
                    .padding(.horizontal, 30)
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 28, height: 13)
                                .foregroundColor(.white)
                                
                            
                            Text("Join")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .background(Color("ButtonColor"))
                    .clipShape(Capsule())
                    
                    
                }
                Divider()
                VStack {
                    
                    HStack {
                        Image(systemName: "plus.bubble.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                            .padding(.leading, 20)

                        Text("Host a Game")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                        Spacer()

                    }
                    .padding(.top, 15)
                    
                    VStack {
                        TextField("Enter Room Name", text: $teamName)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("LightBlue"))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                     
                        }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        self.isPresented = true
                        
                        
                        
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 22, height: 20)
                                .foregroundColor(.white)
                            Text("Create Room")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .background(Color("OrangeColor"))

                    .clipShape(Capsule())
                    .padding(.bottom, 5)
                    .sheet(isPresented: $isPresented, content: {
                        VCSwiftUIView()
                    })
                }
                Spacer()
            }
            .background(Color("MediumBlue").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .padding(.top, 95)

            
            VStack {
                HStack {
                    Text("CameraShy")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 20)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                    Spacer()
                   
                    NavigationLink(destination: CameraButton()){
                        HStack {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("OrangeColor"))
                                
                            
                        }
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                    }
//                    .background(Color("OrangeColor"))
//                    .clipShape(Capsule())
                    .padding(.trailing, 20)
                    .padding(.bottom, 5)
                }
                .padding(.top, 40)
                .background(Color("ButtonColor").edgesIgnoringSafeArea(.top))
                
                Spacer()
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onChange(of: teamName) { name in
            Singleton.shared.teamName = name
            
            print(Singleton.shared.teamName)
        }
    }
}

class ContentViewDelegate: ObservableObject {
    @Published var delegate : String = ""
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct UsualMainView_Previews: PreviewProvider {
    static var previews: some View {
        UsualMainView()
    }
}
