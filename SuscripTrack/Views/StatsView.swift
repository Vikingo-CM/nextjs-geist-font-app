//
//  StatsView.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import SwiftUI
import CoreData

struct StatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Subscription.category, ascending: true)],
        animation: .default)
    private var subscriptions: FetchedResults<Subscription>
    
    private var categoryData: [CategoryData] {
        let grouped = Dictionary(grouping: subscriptions) { $0.wrappedCategory }
        return grouped.map { category, subs in
            CategoryData(
                category: category,
                amount: subs.reduce(0) { $0 + $1.monthlyPrice },
                color: colorForCategory(category)
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    private var totalSpending: Double {
        categoryData.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Total Spending Card
                    VStack(spacing: 8) {
                        Text("Monthly Spending")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(FormatterUtility.formatCurrency(totalSpending))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(subscriptions.count) active subscriptions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if categoryData.isEmpty {
                        // Empty State
                        VStack(spacing: 16) {
                            Image(systemName: "chart.pie")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Data Available")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text("Add some subscriptions to see your spending statistics")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Pie Chart
                        VStack(spacing: 16) {
                            Text("Spending by Category")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            
                            PieChartView(data: categoryData)
                                .frame(height: 250)
                                .padding(.horizontal)
                            
                            // Legend
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(categoryData, id: \.category) { data in
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(data.color)
                                            .frame(width: 12, height: 12)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(data.category)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                            
                                            Text(FormatterUtility.formatCurrency(data.amount))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Category Breakdown
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category Breakdown")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            
                            ForEach(categoryData, id: \.category) { data in
                                CategoryRowView(data: data, totalSpending: totalSpending)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Entertainment":
            return .blue
        case "Services":
            return .green
        case "Utilities":
            return .orange
        case "Health":
            return .red
        case "Education":
            return .purple
        default:
            return .gray
        }
    }
}

struct CategoryData {
    let category: String
    let amount: Double
    let color: Color
}

struct CategoryRowView: View {
    let data: CategoryData
    let totalSpending: Double
    
    private var percentage: Double {
        guard totalSpending > 0 else { return 0 }
        return (data.amount / totalSpending) * 100
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(data.color)
                    .frame(width: 12, height: 12)
                
                Text(data.category)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(FormatterUtility.formatCurrency(data.amount))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(Int(percentage))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(data.color)
                        .frame(width: geometry.size.width * (percentage / 100), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
