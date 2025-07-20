//
//  PieChartView.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import SwiftUI

struct PieChartView: View {
    let data: [CategoryData]
    @State private var animationProgress: CGFloat = 0
    
    private var total: Double {
        data.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 - 20
            
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
                
                // Pie slices
                ForEach(Array(data.enumerated()), id: \.element.category) { index, categoryData in
                    PieSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: categoryData.color
                    )
                    .scaleEffect(animationProgress)
                    .animation(.easeInOut(duration: 1.0).delay(Double(index) * 0.1), value: animationProgress)
                }
                
                // Center circle with total
                VStack(spacing: 4) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(FormatterUtility.formatCurrency(total))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .position(center)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        guard total > 0 else { return .degrees(0) }
        
        let previousTotal = data.prefix(index).reduce(0) { $0 + $1.amount }
        return .degrees((previousTotal / total) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        guard total > 0 else { return .degrees(0) }
        
        let currentTotal = data.prefix(index + 1).reduce(0) { $0 + $1.amount }
        return .degrees((currentTotal / total) * 360 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 - 20
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
            .overlay(
                Path { path in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .stroke(Color(.systemBackground), lineWidth: 2)
            )
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            CategoryData(category: "Entertainment", amount: 25.97, color: .blue),
            CategoryData(category: "Services", amount: 55.98, color: .green),
            CategoryData(category: "Utilities", amount: 12.99, color: .orange)
        ]
        
        PieChartView(data: sampleData)
            .frame(height: 250)
            .padding()
    }
}
