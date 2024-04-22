//
//  FAQ.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 4/22/24.
//

import Foundation
import SwiftUI

struct FAQ {
    var question: String
    var answer: String
}

import SwiftUI

struct FAQsView: View {
    let faqs: [FAQ] = [
        FAQ(question: "How do I reset my password?", answer: "Go to Settings > Account > Reset Password. Enter your email, and we'll send you instructions."),
        FAQ(question: "Can I sync my data across multiple devices?", answer: "Yes, enable syncing in the Settings under Account options, and sign in with the same account on all your devices."),
        FAQ(question: "What is your refund policy?", answer: "We offer a full refund within the first 30 days of purchase. Contact support via the Help section for assistance."),
        FAQ(question: "How to contact customer support?", answer: "Customer support can be reached through the Help section in our app or by sending an email to support@ourapp.com.")
    ]

    var body: some View {
        NavigationView {
            List(faqs, id: \.question) { faq in
                FAQCell(faq: faq)
            }
            .navigationTitle("FAQs")
        }
    }
}

struct FAQCell: View {
    var faq: FAQ
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(faq.question)
                .font(.headline)
                .foregroundColor(.blue)
            if isExpanded {
                Text(faq.answer)
                    .font(.body)
                    .foregroundColor(.black)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isExpanded)
            }
        }
        .padding()
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

struct FAQsView_Previews: PreviewProvider {
    static var previews: some View {
        FAQsView()
    }
}

