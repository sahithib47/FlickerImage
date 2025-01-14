import SwiftUI

struct ContentView: View {
    @State private var progress = 0.6
    @ObservedObject var viewModel: FlickerimageViewModel = FlickerimageViewModel()
    @State private var searchText = ""
    @State private var selectedItem: Item?
    
    @State private var path = NavigationPath()

    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                searchBar
                contentGrid
            }
            .navigationTitle("Flickr Images")
            .overlay(
                viewModel.showSpinner ? ProgressView().progressViewStyle(CircularProgressViewStyle()) : nil
            )
        }
    }

    // Search Bar
    private var searchBar: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .padding(.leading, 35)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                )
                .onChange(of: searchText) { newValue in
                    viewModel.getImages(tagString: newValue.isEmpty ? "porcupine" : newValue)
                }

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    viewModel.getImages(tagString: "porcupine")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private var contentGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.itemsData ?? [], id: \.id) { item in
                    CustomImageView(imageString: item.media.m)
                        .onTapGesture {
                            selectedItem = item
                            path.append(item)
                        }
                }
            }
            .padding()
        }
        .navigationDestination(for: Item.self) { item in
            DetailView(item: item)
        }
    }
}

struct CustomImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    var imageString: String?
    var onImageLoaded: ((UIImage) -> Void)?
    
    @State private var isLoaded = false
    var body: some View {
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 150)
                    .onAppear {
                        if !isLoaded {
                            onImageLoaded?(image)
                            isLoaded = true
                        }
                    }
            } else {
                ProgressView()
                    .frame(width: 200, height: 150)
            }
        }
        .onAppear {
            if let urlString = imageString {
                imageLoader.loadImage(from: urlString)
            }
        }
    }
}

