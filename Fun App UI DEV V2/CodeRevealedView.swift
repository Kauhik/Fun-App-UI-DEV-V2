//
//  CodeRevealedView.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct CodeRevealedView: View {
    let code: String
    let teamName: String
    let onDone: () -> Void
    
    @State private var showConfetti = false
    @State private var animateCode = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Success Animation
                VStack(spacing: 20) {
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateCode ? 1.2 : 1.0)
                        .animation(.spring(response: 0.6).repeatCount(3, autoreverses: true), value: animateCode)
                    
                    VStack(spacing: 8) {
                        Text("Fantastic Work!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Team \(teamName)")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Cultural Success Message
                VStack(spacing: 12) {
                    Text("🌏 Cultural Bridge Built! 🌏")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text("You've successfully connected cultures and discovered new expressions together!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                .padding(.horizontal, 20)
                
                // Code Display
                VStack(spacing: 16) {
                    Text("Your Unity Code")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 200)
                            .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 16) {
                            // Cultural Symbol
                            Text("🤝")
                                .font(.system(size: 40))
                            
                            // Code
                            Text(code)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(4)
                        }
                    }
                    .scaleEffect(animateCode ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCode)
                }
                
                // Cultural Message
                VStack(spacing: 8) {
                    Text("\"Unity in Diversity\"")
                        .font(.title3)
                        .fontWeight(.medium)
                        .italic()
                        .foregroundColor(.primary)
                    
                    Text("🇸🇬 Bhinneka Tunggal Ika 🇮🇩")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Continue Button
                Button(action: onDone) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.forward.circle.fill")
                        Text("Continue Quest")
                            .fontWeight(.semibold)
                    }
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            animateCode = true
        }
    }
}
