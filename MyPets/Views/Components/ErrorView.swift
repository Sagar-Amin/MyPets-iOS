//
//  ErrorView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error loading pets")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"]),
                 retryAction: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
