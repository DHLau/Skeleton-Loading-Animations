//
//  ContentView.swift
//  Skeleton Loading Animations
//
//  Created by Alan on 2025/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading: Bool = false
    @State private var cards: [Card] = []
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                if cards.isEmpty {
                    ForEach(0..<5, id:\.self) { _ in
                        SomeCardView()
                    }
                } else {
                    ForEach(cards) { card in
                        SomeCardView(card: card)
                    }
                }
            }
            .padding(20)
        }
        .scrollDisabled(cards.isEmpty)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.smooth) {
                cards = [
                    .init(
                        image:"wwdc25",
                        title: "World Wide Developer Conference 2025",
                        subTitle: "From June 9th 2025",
                        description: "Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers."
                    )
                ]
            }
        }
    }
}


// VStack {
//     SomeCardView(card: card)
//         .onTapGesture {
//             withAnimation(.smooth) {
//                 if card == nil {
//                     card = .init(
//                     image:"wwdc25",
//                     title: "World Wide Developer Conference 2025", subTitle: "From June 9th 2025",
//                     description: "Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers."
//                     )
//                 } else {
//                     card = nil
//                 }
//             }
//         }
//     Spacer()
// }
 

struct Card: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var subTitle: String
    var description: String
}

extension Card {
    static var mock: Card {
        .init(
            image: "wwdc25",
            title: "World Wide Developer Conference 2025",
            subTitle: "From June 9th 2025",
            description: "Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers."
        )
    }
    
    static var cardData: Card {
        .init(
            image: "wwdc25",
            title: "World Wide Developer Conference 2025",
            subTitle: "From June 9th 2025",
            description: "Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers.Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers.Be there for the reveal of the latest Apple tools, frameworks, and features. Learn to elevate your apps and games through video sessions hosted by Apple engineers and designers."
        )
    }
}

struct SomeCardView: View {
    var card: Card?
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    if let card {
                        Image(card.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        SkeletonView(.rect)
                    }
                }
                .frame(height: 220)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                
                if let card {
                    Text(card.title)
                        .fontWeight(.semibold)
                } else {
                    SkeletonView(.rect(cornerRadius: 5))
                        .frame(height: 20)
                }
                
                Group {
                    if let card {
                        Text(card.subTitle)
                            .font(.callout)
                            .fontWeight(.semibold)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                            .frame(height: 20)
                    }
                }
                .padding(.trailing, 30)
                
                ZStack {
                    if let card {
                        Text(card.description)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                    }
                }
                .frame(height: 50)
                .lineLimit(3)
            }
            .padding([.horizontal, .top], 6)
            .padding(.bottom, 25)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

#Preview {
    ContentView()
}
