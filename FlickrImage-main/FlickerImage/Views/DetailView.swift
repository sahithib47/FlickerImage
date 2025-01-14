import SwiftUI
struct DetailView: View {
    let item: Item?
    
    public var body: some View {
        ScrollView {
            VStack {
                CustomImageView(imageString: item?.media.m)
                
                Text("Width: \(item?.extractDimensions().0 ?? "")   Height: \(item?.extractDimensions().1 ?? "")")
                    .font(.subheadline)
                    .padding()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Title: \(item?.title ?? "No title available")")
                        .font(.headline)
                        .padding([.leading, .trailing, .top])
                    
                    Text("Description: \(TextUtils.stripHTMLTags(item?.description ?? "No description available"))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                    
                    Text("Author: \(item?.author ?? "Unknown author")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                    
                    Text("Published Date: \(TextUtils.formatDate(dateString: item?.published ?? ""))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing])
                }
                
                // Share button to share image and metadata
                Button(action: {
                    if let image = UIImage(named: item?.media.m ?? ""), let title = item?.title, let description = item?.description {
                        SharingUtils.shareImageAndMetadata(image: image, title: title, description: description)
                    }
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .transition(.scale)
    }
}
