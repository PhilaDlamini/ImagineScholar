//
//  AddNewsLetter.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/23/23.
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct AddNewsLetter: View {
    @State private var title = ""
    @State private var description = ""
    @State private var fileName = "No file chosen"
    @State private var pickingFile = false
    @State private var fileUrl: URL?
    @Environment(\.dismiss) var dismiss
    let storage = Storage.storage().reference().child("newsletters")
    
    var body: some View {
            Form {
                Section {
                    TextField("Title", text: $title)
                }
                
                Section("Description") {
                    TextEditor(text: $description)

                }
                
                Section("File") {
                    TextField(fileName, text: $fileName)
                }
                .onTapGesture {
                    pickingFile = true
                }
                
                Section {
                    Button("Upload", action: upload)
                }
            }
            .fileImporter(isPresented: $pickingFile, allowedContentTypes: [.pdf]) {res in
                do {
                    fileUrl = try res.get()
                    fileName = fileUrl?.lastPathComponent ?? "Unknown"
                    
                    //upload to storage
                } catch {
                    print("error getting file \(error.localizedDescription)")
                }
            }
            .navigationTitle("Add NewsLetter")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func upload() {
        if let url = fileUrl {
            guard let data = try? Data(contentsOf: url) else {
                print("Error reading URL data")
                return
            }
            
            let uid = UUID().uuidString
            storage.child(uid).putData(data, metadata: nil) {metadata, error in
                if let error = error {
                    print("Error uploading pdf \(error.localizedDescription)")
                } else {
                    
                    //download the url
                    storage.child(uid).downloadURL() {url, error in
                        if let error = error {
                            print("Error getting image url \(error.localizedDescription)")
                        } else {
                            
                            //save the newsletters data to the databaser
                            let newsletter = NewsLetter(id: uid, title: title, storageURL: url!.absoluteString, description: description)
                            
                            let ref = Database.database().reference()
                            ref.child("newsletters").child(uid).setValue(try! newsletter.getDict()) {(error, ref) in
                                if let error = error {
                                    print("Error saving newsletter data! \(error.localizedDescription)")
                                } else {
                                    
                                    print("saved newsletter data!")
                                    dismiss()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

struct AddNewsLetter_Previews: PreviewProvider {
    static var previews: some View {
        AddNewsLetter()
    }
}
