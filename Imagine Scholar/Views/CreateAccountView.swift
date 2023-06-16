//
//  CreateAccountView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/23/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct CreateAccountView: View {
    @State private var name  = ""
    @State private var email = ""
    @State private var password = ""
    @State private var accountType = "Student"
    @State private var image: Image?
    @State private var pickedImage: UIImage?
    @State private var showingPicker = false
    @Binding var screen: String
    let accountTypes = ["Student", "Alumni", "Facilitator"]
    
    
    var body: some View {
        VStack(spacing: 20)  {
            
            Text("Create an account")
                .font(.headline)
            
            
            HStack {
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                Button("Select") {
                    showingPicker = true
                }
            }
                        
            Form {
                
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    TextField("Email", text: $email)
                }
                
                Section {
                    TextField("Password", text: $password)
                        .textContentType(.password)
                }
                
                Section {
                    Picker("Account type", selection: $accountType) {
                        ForEach(accountTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }

            }
            
            
            Button ("Create Account", action: create_account)
            .buttonStyle(.borderedProminent)
            
            HStack(spacing: 10) {
                Text("Already have account?")
                Button("Log in") {
                    screen = "login"
                }
            }
            
            Rectangle()
                .fill(.gray)
                .frame(height: 1)
            
            
            VStack(spacing: 20) {
                Button {
                    
                } label: {
                    Label("Continue with Google", systemImage: "pencil")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Button {
                    
                } label: {
                    Label("Continue with Facebook", systemImage: "command")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                      
                }
    
                
                Button {
                 
                    
                } label: {
                    Label("Continue with Apple", systemImage: "car")
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
            }
            
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker(image: $pickedImage)
        }
        .onChange(of: pickedImage) { _ in
            guard let inputImage = pickedImage else {return}
            image = Image(uiImage: inputImage)
        }
    }
    
    func create_account() {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            //catch any errors
            if let error = error {
                let errorCode = AuthErrorCode.Code(rawValue: error._code)
                
                switch errorCode {
                    case .emailAlreadyInUse:
                    print("Email already in use")
                        break
                    
                    case .invalidEmail:
                    print("Email was invalid")
                        break
                    
                    case .weakPassword:
                    print("Weak password")
                        break
                        
                    default:
                    print("unknown error \(error.localizedDescription)")
                        break
                }
                
            } else {
                
                let currentUser = Auth.auth().currentUser!

                
                //upload the image
                let storage = Storage.storage().reference()
                let data = pickedImage!.jpegData(compressionQuality: 0.8)!
                storage.child("profile pics").child(currentUser.uid).putData(data, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image \(error.localizedDescription)")
                    } else {
                        
                        //get image url
                        storage.child("profile pics").child(currentUser.uid).downloadURL() {url, error in
                            if let error = error {
                                print("Error getting image url \(error.localizedDescription)")
                            } else {
                                
                                //save the user information
                                let user = User(uid: currentUser.uid, name: name, email: email, type: accountType, imageURL: url!)
                                
                                let ref = Database.database().reference()
                                ref.child("users").child(user.uid).setValue(try! user.getDict()) {(error, ref) in
                                    if let error = error {
                                        print("Error saving user data! \(error.localizedDescription)")
                                    } else {
                                        
                                        print("saved user data!")
                                        
                                        if let encoded = try? JSONEncoder().encode(user) {
                                            UserDefaults.standard.set(encoded, forKey: "user")
                                            print("Saved user data to user defaults")
                                        } else {
                                            print("Failed to save user data to defaults")
                                        }
                                       
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }  
            }
        }
        
    }
    
}


//TODO: show progress view while creating the account 
