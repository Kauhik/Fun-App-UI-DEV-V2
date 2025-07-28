//
//  WelcomeView.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct WelcomeView: View {
    @Binding var teamNumber: String
    @Binding var teamName: String
    @Binding var selectedCulture: CultureType
    let onPlay: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 20)
                
                // App Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "globe.asia.australia.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red, .blue, .green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(spacing: 8) {
                        Text("Cultural Bridge")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        
                        Text("Quest")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    Text("Learn • Connect • Discover")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                
                // Cultural Selection
                VStack(spacing: 16) {
                    Text("Choose Your Cultural Mix")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        ForEach(CultureType.allCases, id: \.self) { culture in
                            CultureSelectionCard(
                                culture: culture,
                                isSelected: selectedCulture == culture,
                                onSelect: { selectedCulture = culture }
                            )
                        }
                    }
                }
                
                // Team Information
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(.blue)
                            Text("Team Information")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Team Name")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            TextField("Enter your team name", text: $teamName)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Team Number")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            TextField("Enter team number", text: $teamNumber)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                
                // Welcome Message
                VStack(spacing: 12) {
                    Text(selectedCulture.greeting)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Ready to discover amazing cultural expressions and connect with your teammates?")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                .padding(.horizontal)
                
                // Play Button
                Button(action: onPlay) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                        Text("Start Quest")
                            .fontWeight(.semibold)
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(teamName.isEmpty || teamNumber.isEmpty)
                .opacity(teamName.isEmpty || teamNumber.isEmpty ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: teamName.isEmpty || teamNumber.isEmpty)
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct CultureSelectionCard: View {
    let culture: CultureType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Text(culture.flag)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(culture.rawValue)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(culture.greeting)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
