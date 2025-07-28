//
//  PuzzleView.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct PuzzleView: View {
    @Binding var lockerStates: [String: LockerState]
    @Binding var discoveredCode: String
    let teamName: String
    let onScanClue: () -> Void
    let onSolve: () -> Void
    
    private let lockerGrid = [
        ["A", "B"],
        ["C", "D"],
        ["E"]
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "lock.rectangle.stack.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cultural Puzzle")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Team: \(teamName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Locker #30")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(solvedCount)/5 Solved")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text("Work together to unlock all cultural expressions!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Locker Grid
                VStack(spacing: 20) {
                    ForEach(0..<lockerGrid.count, id: \.self) { rowIndex in
                        HStack(spacing: 20) {
                            ForEach(lockerGrid[rowIndex], id: \.self) { lockerId in
                                LockerButton(
                                    id: lockerId,
                                    state: lockerStates[lockerId] ?? .locked,
                                    code: getCodeForLocker(lockerId)
                                )
                            }
                            
                            if lockerGrid[rowIndex].count == 1 {
                                Spacer()
                                    .frame(width: 100)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Progress Indicator
                VStack(spacing: 12) {
                    HStack {
                        ForEach(0..<5, id: \.self) { index in
                            Circle()
                                .fill(index < solvedCount ? Color.green : Color(.systemGray4))
                                .frame(width: 12, height: 12)
                                .animation(.spring(response: 0.5), value: solvedCount)
                        }
                    }
                    
                    Text("\(solvedCount) of 5 cultural expressions discovered")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Scan Button
                Button(action: onScanClue) {
                    HStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.title3)
                        
                        Text("Scan Cultural Clue")
                            .fontWeight(.semibold)
                    }
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var solvedCount: Int {
        lockerStates.values.filter { $0 == .solved }.count
    }
    
    private func getCodeForLocker(_ lockerId: String) -> String {
        if discoveredCode.count >= (["A": 1, "B": 2, "C": 3, "D": 4, "E": 5][lockerId] ?? 0) {
            let index = (["A": 0, "B": 1, "C": 2, "D": 3, "E": 4][lockerId] ?? 0)
            if index < discoveredCode.count {
                return String(discoveredCode[discoveredCode.index(discoveredCode.startIndex, offsetBy: index)])
            }
        }
        return ""
    }
}

struct LockerButton: View {
    let id: String
    let state: LockerState
    let code: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(id)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColor)
                    .frame(width: 100, height: 100)
                    .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
                
                if !code.isEmpty {
                    Text(code)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: lockIcon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .animation(.spring(response: 0.6), value: state)
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .locked:
            return Color(.systemGray3)
        case .unlocked:
            return .blue
        case .solved:
            return .green
        }
    }
    
    private var shadowColor: Color {
        backgroundColor.opacity(0.4)
    }
    
    private var lockIcon: String {
        switch state {
        case .locked:
            return "lock.fill"
        case .unlocked:
            return "lock.open.fill"
        case .solved:
            return "checkmark.seal.fill"
        }
    }
}
