//
//  NewsletterView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct NewsLetterView: View {
    let newsletter: NewsLetter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading){
                Text(newsletter.title)
                    .font(.headline)
                Text(newsletter.getDisplayTime(from: newsletter.timestamp))
                    .font(.subheadline)
            }
        
            Text(newsletter.description)
        }
    }
}

struct NewsLettersView: View {
    @State private var newsletters = [NewsLetter]()
    @EnvironmentObject var user: User
    let storage = Storage.storage().reference().child("newsletters")
    let ref = Database.database().reference().child("newsletters")


    var body: some View {
        NavigationView {
            List {
                ForEach(newsletters) {letter in
                    
                    NavigationLink(destination: PDFViewer(url: URL(string: letter.storageURL)!, title: letter.title)) {
                        NewsLetterView(newsletter: letter)

                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                        Text("Newsletters")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: AddNewsLetter()) {
                        Image(systemName: "plus.circle")
                    }
            
                }
            }
            .onAppear {
                attachListeners()
            }
        }
    }
    
    func attachListeners() {
        
        //if a new letter is added, append it to the list of posts
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let letterData = snapshot.value as? [String: Any] {
                    let letter: NewsLetter = try! NewsLetter.fromDict(dictionary: letterData)
                    if !newsletters.contains(where: {$0.id == letter.id}) {
                        newsletters.insert(letter, at: 0)
                    }
                }
            }
        }
    
        
        //if a letter is removed, update the view
        ref.observe(.childRemoved) {snapshot in
           if let letterData = snapshot.value as? [String: Any] {
               let letter: NewsLetter = try! NewsLetter.fromDict(dictionary: letterData)
               newsletters.removeAll(where: {$0.id == letter.id})
               print("Removed letter")
            }
        }
    }
    
}

struct NewsletterView_Previews: PreviewProvider {
    static var previews: some View {
        NewsLettersView()
    }
}
