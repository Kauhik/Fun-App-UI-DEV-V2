//
//  CameraFilterView.swift
//  Cultural Bridge Quest
//

import SwiftUI

struct CameraFilterView: View {
    let culture: CultureType
    let onBack: () -> Void
    let onScanSuccess: () -> Void
    
    @State private var selectedFilter: CameraFilter = .visualScan
    @State private var isScanning = false
    @State private var showAROverlay = false
    @State private var scanProgress: Double = 0.0
    @State private var detectedItems: [String] = []
    @State private var scrollOffset: CGFloat = 0
    @State private var currentFilterIndex: Int = 0
    
    private let filterWidth: CGFloat = 100
    private let filterSpacing: CGFloat = 20
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Camera Preview Background
            CameraPreviewView(filter: selectedFilter, isScanning: isScanning, showAROverlay: showAROverlay)
            
            VStack(spacing: 0) {
                // Top Navigation
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                            Text("Back")
                                .font(.body)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Culture indicator
                    HStack(spacing: 8) {
                        Text(culture.flag)
                        Text("Cultural Scanner")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    // Info button
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // Filter Title and Description
                VStack(spacing: 8) {
                    Text(selectedFilter.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: selectedFilter)
                    
                    Text(selectedFilter.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut(duration: 0.3), value: selectedFilter)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.6), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                
                // Scanning Progress
                if isScanning {
                    VStack(spacing: 12) {
                        ProgressView(value: scanProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .frame(width: 200)
                        
                        Text(selectedFilter.scanningText)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.vertical, 16)
                    .transition(.opacity.combined(with: .scale))
                }
                
                // Scrollable Filter Carousel (Instagram/Snapchat style)
                ScrollableFilterCarousel(
                    selectedFilter: $selectedFilter,
                    currentFilterIndex: $currentFilterIndex,
                    onFilterChange: { filter in
                        selectedFilter = filter
                        showAROverlay = filter == .arDiscovery
                    }
                )
                .padding(.vertical, 20)
                
                // Main Action Button
                Button(action: startScanning) {
                    HStack(spacing: 12) {
                        if isScanning {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.9)
                        } else {
                            Image(systemName: selectedFilter.actionIcon)
                                .font(.title3)
                        }
                        
                        Text(isScanning ? "Scanning..." : selectedFilter.actionText)
                            .fontWeight(.semibold)
                    }
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: isScanning ? [.orange, .red] : selectedFilter.buttonColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: selectedFilter.buttonColors.first?.opacity(0.4) ?? .clear, radius: 8, x: 0, y: 4)
                    .animation(.easeInOut(duration: 0.3), value: selectedFilter)
                }
                .disabled(isScanning)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            // AR Overlay Elements
            if showAROverlay && selectedFilter == .arDiscovery {
                AROverlayView()
            }
        }
        .statusBarHidden()
    }
    
    private func startScanning() {
        isScanning = true
        scanProgress = 0.0
        detectedItems.removeAll()
        
        // Simulate scanning animation
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            scanProgress += 0.05
            
            if scanProgress >= 1.0 {
                timer.invalidate()
                isScanning = false
                
                // Simulate detection success
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onScanSuccess()
                }
            }
        }
    }
}

struct ScrollableFilterCarousel: View {
    @Binding var selectedFilter: CameraFilter
    @Binding var currentFilterIndex: Int
    let onFilterChange: (CameraFilter) -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    
    private let filterWidth: CGFloat = 80
    private let filterSpacing: CGFloat = 20
    private let totalFilterWidth: CGFloat = 100 // filterWidth + filterSpacing
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let centerOffset = screenWidth / 2 - filterWidth / 2
            
            HStack(spacing: filterSpacing) {
                ForEach(Array(CameraFilter.allCases.enumerated()), id: \.offset) { index, filter in
                    ScrollableFilterButton(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        isScanning: false,
                        scale: getScaleForFilter(at: index, screenWidth: screenWidth)
                    )
                    .frame(width: filterWidth)
                }
            }
            .offset(x: centerOffset + scrollOffset + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let velocity = value.predictedEndTranslation.width - value.translation.width
                        let totalOffset = scrollOffset + dragOffset
                        
                        // Calculate which filter should be selected
                        let filterIndex = max(0, min(CameraFilter.allCases.count - 1,
                                                   Int(round(-totalOffset / totalFilterWidth))))
                        
                        // Animate to the selected filter
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            scrollOffset = -CGFloat(filterIndex) * totalFilterWidth
                            dragOffset = 0
                        }
                        
                        // Update selected filter
                        if filterIndex != currentFilterIndex {
                            currentFilterIndex = filterIndex
                            let newFilter = CameraFilter.allCases[filterIndex]
                            selectedFilter = newFilter
                            onFilterChange(newFilter)
                            
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        }
                    }
            )
            .onAppear {
                // Center the first filter initially
                if let initialIndex = CameraFilter.allCases.firstIndex(of: selectedFilter) {
                    scrollOffset = -CGFloat(initialIndex) * totalFilterWidth
                    currentFilterIndex = initialIndex
                }
            }
        }
        .frame(height: 120)
        .clipped()
    }
    
    private func getScaleForFilter(at index: Int, screenWidth: CGFloat) -> CGFloat {
        let filterPosition = scrollOffset + dragOffset + CGFloat(index) * totalFilterWidth
        let centerPosition = screenWidth / 2 - filterWidth / 2
        let distanceFromCenter = abs(filterPosition + centerPosition)
        
        // Scale based on distance from center
        let maxDistance: CGFloat = 150
        let normalizedDistance = min(distanceFromCenter / maxDistance, 1.0)
        return 1.0 - (normalizedDistance * 0.3) // Scale from 1.0 to 0.7
    }
}

struct ScrollableFilterButton: View {
    let filter: CameraFilter
    let isSelected: Bool
    let isScanning: Bool
    let scale: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isSelected ? filter.buttonColors : [Color.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(isSelected ? 1.0 : 0.3), lineWidth: 2)
                    )
                    .shadow(color: isSelected ? filter.buttonColors.first?.opacity(0.5) ?? .clear : .clear, radius: 8)
                
                if isScanning && isSelected {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: filter.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            
            Text(filter.title)
                .font(.caption2)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(.white)
                .opacity(isSelected ? 1.0 : 0.7)
        }
        .scaleEffect(scale)
        .animation(.spring(response: 0.4), value: scale)
        .animation(.spring(response: 0.4), value: isSelected)
    }
}

enum CameraFilter: CaseIterable {
    case visualScan, audioClue, nfcScan, arDiscovery
    
    var title: String {
        switch self {
        case .visualScan: return "Visual Scan"
        case .audioClue: return "Audio Clue"
        case .nfcScan: return "NFC Clue"
        case .arDiscovery: return "AR Discovery"
        }
    }
    
    var description: String {
        switch self {
        case .visualScan: return "Point camera at cultural items"
        case .audioClue: return "Listen for audio clues"
        case .nfcScan: return "Tap NFC-enabled cards"
        case .arDiscovery: return "Recreate the Dance!"
        }
    }
    
    var icon: String {
        switch self {
        case .visualScan: return "camera.fill"
        case .audioClue: return "mic.fill"
        case .nfcScan: return "wave.3.right.circle.fill"
        case .arDiscovery: return "arkit"
        }
    }
    
    var actionIcon: String {
        switch self {
        case .visualScan: return "camera.viewfinder"
        case .audioClue: return "mic.badge.plus"
        case .nfcScan: return "wave.3.right"
        case .arDiscovery: return "figure.dance"
        }
    }
    
    var actionText: String {
        switch self {
        case .visualScan: return "Start Scan"
        case .audioClue: return "Start Listening"
        case .nfcScan: return "Hold near NFC Tag..."
        case .arDiscovery: return "Do a Dance..."
        }
    }
    
    var scanningText: String {
        switch self {
        case .visualScan: return "Scanning for cultural landmarks..."
        case .audioClue: return "Listening for cultural clues..."
        case .nfcScan: return "Searching for NFC signals..."
        case .arDiscovery: return "Analyzing your moves..."
        }
    }
    
    var buttonColors: [Color] {
        switch self {
        case .visualScan: return [.blue, .cyan]
        case .audioClue: return [.purple, .pink]
        case .nfcScan: return [.green, .mint]
        case .arDiscovery: return [.orange, .yellow]
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .visualScan: return .clear
        case .audioClue: return .black
        case .nfcScan: return .black
        case .arDiscovery: return .clear
        }
    }
}

struct CameraPreviewView: View {
    let filter: CameraFilter
    let isScanning: Bool
    let showAROverlay: Bool
    
    var body: some View {
        ZStack {
            // Background based on filter type
            Group {
                if filter.backgroundColor == .black {
                    Color.black
                } else {
                    // Simulated camera feed
                    Color.black
                        .overlay(
                            Rectangle()
                                .fill(Color.black.opacity(0.2))
                        )
                }
            }
            
            // Filter-specific overlays
            switch filter {
            case .visualScan:
                CameraViewfinderOverlay(isScanning: isScanning)
                
            case .audioClue:
                AudioVisualizerOverlay(isScanning: isScanning)
                
            case .nfcScan:
                NFCOverlay(isScanning: isScanning)
                
            case .arDiscovery:
                if showAROverlay {
                    ARDanceOverlay()
                }
            }
        }
    }
}

struct CameraViewfinderOverlay: View {
    let isScanning: Bool
    
    var body: some View {
        ZStack {
            // Viewfinder frame
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 300, height: 220)
                .overlay(
                    // Corner indicators positioned at actual corners
                    ZStack {
                        // Top-left corner
                        ViewfinderCorner()
                            .position(x: 15, y: 15)
                        
                        // Top-right corner
                        ViewfinderCorner()
                            .rotationEffect(.degrees(90))
                            .position(x: 285, y: 15)
                        
                        // Bottom-left corner
                        ViewfinderCorner()
                            .rotationEffect(.degrees(-90))
                            .position(x: 15, y: 205)
                        
                        // Bottom-right corner
                        ViewfinderCorner()
                            .rotationEffect(.degrees(180))
                            .position(x: 285, y: 205)
                    }
                    .frame(width: 300, height: 220)
                )
            
            // Scanning animation
            if isScanning {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.clear, Color.blue.opacity(0.6), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 300, height: 4)
                    .offset(y: -110)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isScanning)
            }
        }
    }
}

struct ViewfinderCorner: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 20))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
        }
        .stroke(Color.white, lineWidth: 3)
        .frame(width: 20, height: 20)
    }
}

struct AudioVisualizerOverlay: View {
    let isScanning: Bool
    @State private var audioLevels: [CGFloat] = Array(repeating: 0.1, count: 7)
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .opacity(isScanning ? 1.0 : 0.5)
            
            // Audio visualizer bars
            HStack(spacing: 4) {
                ForEach(0..<audioLevels.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 6, height: audioLevels[index] * 60)
                        .animation(.easeInOut(duration: 0.3), value: audioLevels[index])
                }
            }
            .opacity(isScanning ? 1.0 : 0.3)
        }
        .onAppear {
            startAudioAnimation()
        }
        .onChange(of: isScanning) { _, newValue in
            if newValue {
                startAudioAnimation()
            }
        }
    }
    
    private func startAudioAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if !isScanning {
                timer.invalidate()
                return
            }
            
            for i in 0..<audioLevels.count {
                audioLevels[i] = CGFloat.random(in: 0.2...1.0)
            }
        }
    }
}

struct NFCOverlay: View {
    let isScanning: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // NFC waves animation
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 100 + CGFloat(index * 40))
                        .scaleEffect(isScanning ? 1.5 : 1.0)
                        .opacity(isScanning ? 0.0 : 0.7)
                        .animation(
                            .easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.3),
                            value: isScanning
                        )
                }
                
                // NFC icon
                Image(systemName: "wave.3.right.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .scaleEffect(isScanning ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isScanning)
            }
            
            Text("Hold your device near an NFC tag")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
}

struct ARDanceOverlay: View {
    @State private var showDancePrompt = true
    
    var body: some View {
        VStack {
            Spacer()
            
            // AR Dance instruction overlay
            VStack(spacing: 16) {
                Text("AR Clue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Recreate the Dance!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                // Dance figure animation
                Image(systemName: "figure.dance")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .scaleEffect(showDancePrompt ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showDancePrompt)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            )
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct AROverlayView: View {
    var body: some View {
        // AR elements that appear on top of camera
        VStack {
            HStack {
                Spacer()
                
                // AR instruction badge
                HStack(spacing: 8) {
                    Image(systemName: "arkit")
                        .foregroundColor(.orange)
                    Text("Follow the moves!")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.7))
                .clipShape(Capsule())
                .padding(.trailing, 20)
                .padding(.top, 80)
            }
            
            Spacer()
        }
    }
}