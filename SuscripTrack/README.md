# SuscripTrack - iOS Subscription Manager

A modern iOS app built with SwiftUI and CoreData to help users manage their personal subscriptions and track monthly spending.

## Features

### 🏠 Main Screen (Home Tab)
- **Subscription List**: View all active subscriptions with name, monthly price, and billing date
- **Total Monthly Cost**: Automatically calculated and displayed at the top
- **Visual Indicators**: Billing reminders with color-coded alerts for upcoming payments
- **Swipe to Delete**: Easy subscription management

### ➕ Add Subscription (Add Tab)
- **Comprehensive Form**: Add subscription details including:
  - Name (with validation)
  - Monthly price (numeric input with validation)
  - Billing date (date picker)
  - Category selection (Entertainment, Services, Utilities, Health, Education, Other)
  - Icon selection from SF Symbols
- **Input Validation**: Real-time validation with inline error messages
- **Auto-Notifications**: Automatically schedules reminders 2 days before billing

### 📊 Statistics (Stats Tab)
- **Interactive Pie Chart**: Visual breakdown of spending by category
- **Category Breakdown**: Detailed list with percentages and progress bars
- **Total Spending Overview**: Monthly spending summary
- **Color-Coded Categories**: Easy-to-understand visual representation

### 🔔 Smart Notifications
- **Automatic Reminders**: Local push notifications 2 days before each billing date
- **Permission Handling**: Graceful permission requests and error handling
- **Notification Management**: Automatic scheduling, updating, and cancellation

## Technical Architecture

### Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Database**: CoreData for local data persistence
- **Notifications**: UserNotifications framework for local push notifications
- **Design**: iOS native design patterns with San Francisco font

### Project Structure
```
SuscripTrack/
├── SuscripTrackApp.swift                    # App entry point with TabView
├── Views/
│   ├── ContentView.swift                    # Main subscription list
│   ├── AddSubscriptionView.swift            # Add/Edit subscription form
│   ├── StatsView.swift                      # Statistics dashboard
│   └── PieChartView.swift                   # Custom pie chart component
├── Models/
│   └── Subscription+CoreData.swift          # CoreData model with extensions
├── Persistence/
│   └── PersistenceController.swift          # CoreData stack management
├── Notifications/
│   └── NotificationManager.swift            # Local notification handling
├── Utilities/
│   └── FormatterUtility.swift               # Currency and date formatting
├── SuscripTrack.xcdatamodeld/              # CoreData model file
└── Info.plist                              # App configuration
```

### Key Components

#### 1. Data Model (CoreData)
- **Subscription Entity** with attributes:
  - `id`: UUID (Primary Key)
  - `name`: String (Subscription name)
  - `monthlyPrice`: Double (Monthly cost)
  - `billingDate`: Date (Next billing date)
  - `category`: String (Subscription category)
  - `iconName`: String (SF Symbol name)

#### 2. Views Architecture
- **Modular SwiftUI Views**: Each screen is a separate, reusable component
- **State Management**: Uses `@State`, `@FetchRequest`, and `@Environment` for data flow
- **Navigation**: TabView-based navigation with three main tabs

#### 3. Notification System
- **Local Notifications**: No server dependency, works offline
- **Smart Scheduling**: Automatically calculates reminder dates
- **Permission Management**: Handles user permission states gracefully

#### 4. Utilities
- **FormatterUtility**: Centralized formatting for currency and dates
- **Extensions**: Convenient extensions for Double and Date types

## Design Philosophy

### UI/UX Design
- **Minimalistic Interface**: Clean, white background with blue/green accents
- **Native iOS Feel**: Uses system fonts (San Francisco) and standard UI patterns
- **Accessibility**: Follows iOS accessibility guidelines
- **Responsive Design**: Works on all iPhone screen sizes

### User Experience
- **Intuitive Navigation**: Standard tab-based navigation
- **Visual Feedback**: Color-coded alerts for upcoming bills
- **Error Handling**: Graceful error handling with user-friendly messages
- **Data Validation**: Real-time input validation with helpful error messages

## Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.7 or later

### Installation
1. Open the project in Xcode
2. Select your development team in project settings
3. Build and run on simulator or device

### CoreData Setup
The app automatically creates the CoreData stack on first launch. Sample data is provided for preview/testing purposes.

### Notification Permissions
The app requests notification permissions on first launch. Users can manage permissions in iOS Settings.

## Usage

### Adding a Subscription
1. Tap the "Add" tab
2. Fill in subscription details
3. Select a category and icon
4. Tap "Save Subscription"
5. Notification reminder is automatically scheduled

### Managing Subscriptions
- **View All**: Home tab shows all active subscriptions
- **Delete**: Swipe left on any subscription to delete
- **Edit**: Tap on a subscription to view details (future enhancement)

### Viewing Statistics
- **Pie Chart**: Visual breakdown by category
- **Category List**: Detailed spending breakdown with percentages
- **Total Overview**: Monthly spending summary

## Future Enhancements

### Planned Features
- [ ] Edit existing subscriptions
- [ ] Subscription history tracking
- [ ] Export data functionality
- [ ] Multiple billing cycles (weekly, yearly)
- [ ] Custom notification timing
- [ ] Dark mode optimization
- [ ] Widget support
- [ ] iCloud sync

### Technical Improvements
- [ ] Unit tests
- [ ] UI tests
- [ ] Performance optimizations
- [ ] Accessibility improvements
- [ ] Localization support

## Contributing

This is a sample project demonstrating iOS development best practices with SwiftUI and CoreData. Feel free to use it as a reference or starting point for your own subscription management app.

## License

This project is provided as-is for educational and reference purposes.

---

**SuscripTrack** - Take control of your subscriptions! 📱💰
