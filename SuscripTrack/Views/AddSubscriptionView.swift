//
//  AddSubscriptionView.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import SwiftUI
import CoreData

struct AddSubscriptionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var monthlyPrice = ""
    @State private var billingDate = Date()
    @State private var selectedCategory = "Entertainment"
    @State private var selectedIcon = "tv.fill"
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var nameError = ""
    @State private var priceError = ""
    
    private let categories = ["Entertainment", "Services", "Utilities", "Health", "Education", "Other"]
    private let icons = [
        "tv.fill", "music.note", "gamecontroller.fill", "book.fill",
        "heart.fill", "car.fill", "house.fill", "wifi", "phone.fill",
        "envelope.fill", "cloud.fill", "creditcard.fill", "app.fill",
        "star.fill", "globe", "camera.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscription Details")) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Subscription Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !nameError.isEmpty {
                            Text(nameError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Monthly Price", text: $monthlyPrice)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !priceError.isEmpty {
                            Text(priceError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    DatePicker("Billing Date", selection: $billingDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(icons, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                            }) {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .foregroundColor(selectedIcon == icon ? .white : .blue)
                                    .frame(width: 50, height: 50)
                                    .background(selectedIcon == icon ? Color.blue : Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: saveSubscription) {
                        HStack {
                            Spacer()
                            Text("Save Subscription")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func validateInput() -> Bool {
        var isValid = true
        
        // Reset errors
        nameError = ""
        priceError = ""
        
        // Validate name
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameError = "Please enter a subscription name"
            isValid = false
        }
        
        // Validate price
        if monthlyPrice.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            priceError = "Please enter a monthly price"
            isValid = false
        } else if Double(monthlyPrice) == nil {
            priceError = "Please enter a valid price"
            isValid = false
        } else if let price = Double(monthlyPrice), price <= 0 {
            priceError = "Price must be greater than 0"
            isValid = false
        }
        
        return isValid
    }
    
    private func saveSubscription() {
        guard validateInput() else { return }
        
        guard let price = Double(monthlyPrice) else {
            alertMessage = "Invalid price format"
            showingAlert = true
            return
        }
        
        let newSubscription = Subscription(context: viewContext)
        newSubscription.id = UUID()
        newSubscription.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        newSubscription.monthlyPrice = price
        newSubscription.billingDate = billingDate
        newSubscription.category = selectedCategory
        newSubscription.iconName = selectedIcon
        
        do {
            try viewContext.save()
            
            // Schedule notification
            NotificationManager.shared.scheduleNotification(for: newSubscription)
            
            // Reset form
            resetForm()
            
            // Show success message
            alertMessage = "Subscription added successfully!"
            showingAlert = true
            
        } catch {
            alertMessage = "Failed to save subscription: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func resetForm() {
        name = ""
        monthlyPrice = ""
        billingDate = Date()
        selectedCategory = "Entertainment"
        selectedIcon = "tv.fill"
        nameError = ""
        priceError = ""
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
