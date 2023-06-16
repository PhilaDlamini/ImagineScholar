//
//  LoginView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Binding var screen : String
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack (spacing: 50) {
            
            Text ("Create an account")
                .font(.subheadline.weight(.heavy))
            
            Form {
                Section {
                    TextField("Email address", text: $email)
                }

                Section {
                    TextField("Password", text: $password)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Button (action: login) {
                Text("Login")
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            
            HStack(spacing: 10){
                Text("Don't have account?")
                Button("Create one") {
                    screen = "create"
                }
                
            }
            
            //the alternate logins
            VStack(spacing: 20) {
                Button {
                    
                } label: {
                    Label("Continue with Google", systemImage: "pencil")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(.regularMaterial)
                }
                
                Button {
                    
                } label: {
                    Label("Continue with Facebook", systemImage: "command")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(.regularMaterial)
                }
                
                Button {
                    
                } label: {
                    Label("Continue with Apple", systemImage: "car")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(.regularMaterial)
                }
            }
            
        }
        .padding(20)
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                let errorCode  = AuthErrorCode.Code(rawValue: error._code)
                       switch errorCode {
                       case .wrongPassword:
                           print("Invalid email or password.")
                       case .userNotFound:
                           print("User not found.")
                       case .invalidEmail:
                           print("Invalid email format.")
                       case .networkError:
                           print("Network error occurred. Please check your internet connection.")
                       default:
                           print("unknown error \(error.localizedDescription)")
                       }
            } else {
                screen = "create"
            }
            
        }
    }
}

