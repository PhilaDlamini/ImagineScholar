import SwiftUI

//Displays a quoted post in the view
struct QuotedPostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: post.authorURL)) {phase in
                    
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                
                Text(post.author)
                    .font(.headline)
                
                Text(post.getDisplayTime(from: post.timestamp))
                    .font(.subheadline)
                Spacer()
            }
            Text(post.content)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .fill(.gray)
        )
    }
}
