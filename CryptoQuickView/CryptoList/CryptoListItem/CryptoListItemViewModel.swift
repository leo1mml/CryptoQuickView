import Foundation

struct CryptoListItemViewModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let detailImage: String
    let text1: String
    let text2: String
}
