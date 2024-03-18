import SwiftUI

struct CryptoList: View {
    @State private var searchText = ""
    
    var filteredItems: [CryptoListItemViewModel] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredItems, id: \.id) { item in
                            CryptoListItemView(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    let items: [CryptoListItemViewModel] = [
        CryptoListItemViewModel(title: "Item 1", subtitle: "Subtitle 1", detailImage: "image1", text1: "Text 1", text2: "Text 2"),
        CryptoListItemViewModel(title: "Item 2", subtitle: "Subtitle 2", detailImage: "image2", text1: "Text 3", text2: "Text 4"),
        // Add more items as needed
    ]
}

