//
//  ImageListRow.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/23/24.
//

import SwiftUI

struct ImageListRow: View {
    let imaged: ImageData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let username = imaged.username, let timestamp = imaged.timestamp {
                    Text(username).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14))
                    Spacer()
                    Text(timestamp).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14))
                }
            }
            HStack(alignment: .top) {
                if let urlString = imaged.imageUrl, let imageUrl = URL(string: urlString) {
                    AsyncImage(url: imageUrl) {
                        $0.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(height: 181)
                }
            }
        }
    }
}
