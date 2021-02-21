//
//  SwiftUIView.swift
//  CameraShy
//
//  Created by Eric Zhang on 2021-02-19.
//
import SwiftUI

struct Welcome: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to CameraShy")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .offset(y: -50)
                    .padding(.horizontal, 50)
                    .foregroundColor(.white)
                Image("navigate")
                    .resizable()
                    .frame(width: 400, height: 285)
                    .foregroundColor(.white)
                Spacer()
                NavigationLink(destination: SignUp()){
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            
                        
                        Text("Get Started")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                            .foregroundColor(.white)

                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    
                }
                .background(Color("ButtonColor"))
                .clipShape(Capsule())
                .padding(.bottom, 20)
                .buttonStyle(ScaleButtonStyle())
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color("MediumBlue").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))

        }
        .accentColor(.white)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1, anchor:.center)
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
