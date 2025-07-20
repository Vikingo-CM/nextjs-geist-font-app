//
//  NotificationManager.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    func scheduleNotification(for subscription: Subscription) {
        guard let billingDate = subscription.billingDate else {
            print("No billing date found for subscription: \(subscription.wrappedName)")
            return
        }
        
        // Calculate notification date (2 days before billing)
        let calendar = Calendar.current
        guard let notificationDate = calendar.date(byAdding: .day, value: -2, to: billingDate) else {
            print("Could not calculate notification date for subscription: \(subscription.wrappedName)")
            return
        }
        
        // Don't schedule notifications for past dates
        if notificationDate < Date() {
            print("Notification date is in the past for subscription: \(subscription.wrappedName)")
            return
        }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Subscription Reminder"
        content.body = "\(subscription.wrappedName) will be charged \(FormatterUtility.formatCurrency(subscription.monthlyPrice)) in 2 days"
        content.sound = .default
        content.badge = 1
        
        // Add user info for potential future use
        content.userInfo = [
            "subscriptionId": subscription.wrappedID.uuidString,
            "subscriptionName": subscription.wrappedName,
            "amount": subscription.monthlyPrice
        ]
        
        // Create date components for trigger
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create request with unique identifier
        let identifier = "subscription_\(subscription.wrappedID.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(subscription.wrappedName): \(error.localizedDescription)")
            } else {
                print("Successfully scheduled notification for \(subscription.wrappedName) on \(FormatterUtility.formatDate(notificationDate))")
            }
        }
    }
    
    func cancelNotification(for subscription: Subscription) {
        let identifier = "subscription_\(subscription.wrappedID.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled notification for subscription: \(subscription.wrappedName)")
    }
    
    func updateNotification(for subscription: Subscription) {
        // Cancel existing notification
        cancelNotification(for: subscription)
        
        // Schedule new notification
        scheduleNotification(for: subscription)
    }
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    func checkNotificationSettings(completion: @escaping (UNNotificationSettings) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings)
            }
        }
    }
    
    // Helper method to reschedule all notifications (useful after app updates)
    func rescheduleAllNotifications(for subscriptions: [Subscription]) {
        // Remove all pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Reschedule notifications for all subscriptions
        for subscription in subscriptions {
            scheduleNotification(for: subscription)
        }
        
        print("Rescheduled notifications for \(subscriptions.count) subscriptions")
    }
}

// MARK: - Notification Settings Helper
extension NotificationManager {
    func openNotificationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
