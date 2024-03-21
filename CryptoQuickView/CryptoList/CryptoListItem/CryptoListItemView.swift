import SwiftUI

struct CryptoListItemView: View {
    var item: CryptoListItemViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: BitfinexAPI.getImageURL(for: item.subtitle)) { image in
                image.image?.resizable()
            }
            .scaleEffect(0.5)
            .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.text1)
                    .font(.caption)
                Text(item.text2)
                    .foregroundStyle(Color.green)
                    .font(.caption)
            }
        }
        .padding(8)
        .background()
        .cornerRadius(8)
        .shadow(color: .secondary, radius: 2)
    }
}

