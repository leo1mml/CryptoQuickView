import SwiftUI

struct CryptoListItemView: View {
    var item: CryptoListItemViewModel
    
    var body: some View {
        HStack {
            Image(item.detailImage)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                .shadow(radius: 2)
            
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
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

