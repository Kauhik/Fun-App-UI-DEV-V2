//
//  CategoriesView.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct CategoriesView: View {
    @Binding var categories: [PuzzleCategory]
    let culture: CultureType
    let onComplete: (String) -> Void
    
    @State private var draggedCategory: PuzzleCategory?
    @State private var showingCulturalInfo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Text(culture.flag)
                            .font(.title)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cultural Expressions")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Match expressions with meanings")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingCulturalInfo = true }) {
                            Image(systemName: "info.circle")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Progress Bar
                    VStack(spacing: 8) {
                        HStack {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(matchedCount)/\(categories.count)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                        
                        ProgressView(value: Double(matchedCount), total: Double(categories.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    }
                }
                .padding(.horizontal, 20)
                
                // Instructions
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "hand.draw")
                            .foregroundColor(.orange)
                        
                        Text("Drag the cultural expressions to their meanings")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    Text("Learn about each other's cultures while solving!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                
                // Categories and Meanings Grid
                VStack(spacing: 16) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        CulturalMatchRow(
                            category: categories[index],
                            categoryIndex: index,
                            draggedCategory: $draggedCategory,
                            onDrop: { droppedCategoryIndex in
                                if droppedCategoryIndex == index {
                                    categories[index].isMatched = true
                                    checkCompletion()
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Reset Button
                if categories.contains(where: { $0.isMatched }) {
                    Button(action: resetPuzzle) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Reset Puzzle")
                        }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showingCulturalInfo) {
            CulturalInfoSheet(culture: culture, categories: categories)
        }
    }
    
    private var matchedCount: Int {
        categories.filter { $0.isMatched }.count
    }
    
    private func checkCompletion() {
        if categories.allSatisfy({ $0.isMatched }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                onComplete("UNITY")
            }
        }
    }
    
    private func resetPuzzle() {
        for i in 0..<categories.count {
            categories[i].isMatched = false
        }
    }
}

struct CulturalMatchRow: View {
    let category: PuzzleCategory
    let categoryIndex: Int
    @Binding var draggedCategory: PuzzleCategory?
    let onDrop: (Int) -> Void
    
    @State private var isTargeted = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Expression
            CategoryDragButton(
                category: category,
                draggedCategory: $draggedCategory,
                isMatched: category.isMatched
            )
            
            // Arrow or Check
            Image(systemName: category.isMatched ? "checkmark.circle.fill" : "arrow.right")
                .foregroundColor(category.isMatched ? .green : .gray)
                .font(.title3)
                .animation(.spring(response: 0.5), value: category.isMatched)
            
            // Meaning Drop Zone
            MeaningDropZone(
                meaning: category.culturalMeaning,
                categoryIndex: categoryIndex,
                isMatched: category.isMatched,
                isTargeted: isTargeted,
                onDrop: { droppedCategoryIndex in
                    onDrop(droppedCategoryIndex)
                }
            )
            .dropDestination(for: String.self) { items, location in
                if let droppedItem = items.first {
                    if let droppedIndex = getCategoryIndex(for: droppedItem) {
                        onDrop(droppedIndex)
                        return true
                    }
                }
                return false
            } isTargeted: { targeted in
                isTargeted = targeted
            }
        }
        .padding(.vertical, 4)
    }
    
    private func getCategoryIndex(for categoryName: String) -> Int? {
        return categoryIndex
    }
}

struct CategoryDragButton: View {
    let category: PuzzleCategory
    @Binding var draggedCategory: PuzzleCategory?
    let isMatched: Bool
    
    var body: some View {
        Text(category.name)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isMatched ? Color.green : category.color)
                    .shadow(color: (isMatched ? Color.green : category.color).opacity(0.3), radius: 6, x: 0, y: 3)
            )
            .scaleEffect(draggedCategory?.name == category.name ? 1.05 : 1.0)
            .opacity(isMatched ? 0.8 : 1.0)
            .animation(.spring(response: 0.4), value: draggedCategory?.name == category.name)
            .animation(.spring(response: 0.5), value: isMatched)
            .draggable(category.name) {
                Text(category.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(category.color.opacity(0.9))
                    )
            }
            .disabled(isMatched)
    }
}

struct MeaningDropZone: View {
    let meaning: String
    let categoryIndex: Int
    let isMatched: Bool
    let isTargeted: Bool
    let onDrop: (Int) -> Void
    
    var body: some View {
        Text(meaning)
            .font(.body)
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
            )
            .scaleEffect(isTargeted ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: isTargeted)
            .animation(.spring(response: 0.5), value: isMatched)
    }
    
    private var backgroundColor: Color {
        if isMatched {
            return Color.green.opacity(0.15)
        } else if isTargeted {
            return Color.blue.opacity(0.15)
        } else {
            return Color(.systemBackground)
        }
    }
    
    private var borderColor: Color {
        if isMatched {
            return Color.green
        } else if isTargeted {
            return Color.blue
        } else {
            return Color(.systemGray4)
        }
    }
}

struct CulturalInfoSheet: View {
    let culture: CultureType
    let categories: [PuzzleCategory]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(culture.flag)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cultural Guide")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(culture.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        Text("Learn about these cultural expressions and share with your teammates!")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Cultural Expressions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Expressions in this puzzle:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ForEach(categories.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(categories[index].name)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(categories[index].color)
                                        .clipShape(Capsule())
                                    
                                    Spacer()
                                }
                                
                                Text(categories[index].culturalMeaning)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Cultural Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

