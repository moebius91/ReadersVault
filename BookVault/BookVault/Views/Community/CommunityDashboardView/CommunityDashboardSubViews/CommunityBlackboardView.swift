//
//  CommunityBlackboardView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityBlackboardView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(uiImage: UIImage(named: "CommunityBlackboardImage")!)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity, height: 200)
                .clipped()
                .border(.black, width: 2)
            Text("Zum Schwarzenbrett")
                .font(.title2)
                .bold()
                .padding(.top, 10)
                .padding(.leading, 24)
                .foregroundStyle(.black)
                .shadow(color: .white, radius: 1, x: 1, y: 1)
                .shadow(color: .gray, radius: 1, x: -1, y: -1)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommunityBlackboardView()
}
