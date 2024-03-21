import SwiftUI

struct CryptoListItemView: View {
    var item: CryptoListItemViewModel
    private var placeholder: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    var body: some View {
        HStack {
            if let url = BitfinexAPI.getImageURL(for: item.subtitle) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    placeholder
                }
                .scaleEffect(0.8)
                .frame(width: 50, height: 50)
            } else {
                placeholder
                    .frame(width: 50, height: 50)
                    .scaleEffect(0.8)
            }
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

