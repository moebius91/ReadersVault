//
//  CommunityGroupsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityGroupsView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(uiImage: UIImage(named: "CommunityGroupsImage")!)
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 200)
                .clipped()
                .border(.black, width: 2)
            Text("Zu den Gruppen")
                .font(.title2)
                .bold()
                .padding(.top, 10)
                .padding(.leading, 24)
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
                .shadow(color: .gray, radius: 1, x: -1, y: -1)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommunityGroupsView()
}
