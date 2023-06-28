//
//  NewsletterView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import SwiftUI

struct NewslettersView: View {
    var body: some View {
        List{
            ForEach(0...10, id: \.self) {
                Text("Newsletter \($0) here")
            }
        }
    }
}

struct NewsletterView_Previews: PreviewProvider {
    static var previews: some View {
        NewslettersView()
    }
}
