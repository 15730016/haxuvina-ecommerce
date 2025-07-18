# Affiliate Feature Integration Guide

## Overview
This guide provides complete instructions for integrating the affiliate feature into your Flutter e-commerce application based on the Laravel backend.

## Backend Setup (Laravel)

### 1. API Endpoints Created
The following endpoints have been added to your Laravel backend:

- `GET /affiliate/dashboard` - Get affiliate dashboard data
- `GET /affiliate/earning-history` - Get earning history
- `GET /affiliate/payment-history` - Get payment history
- `GET /affiliate/withdraw-history` - Get withdrawal history
- `POST /affiliate/withdraw-request` - Create withdrawal request
- `GET /affiliate/payment-settings` - Get payment settings
- `POST /affiliate/payment-settings` - Update payment settings

### 2. Files Added/Modified
- `app/Http/Controllers/Api/V2/AffiliateApiController.php` - New API controller
- `routes/api.php` - Added affiliate routes

## Flutter Integration

### 1. Add Dependencies
Add these to your `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.0.5
  http: ^0.13.5
```

### 2. File Structure
```
lib/
├── screens/
│   └── affiliate/
│       ├── affiliate_screen.dart
│       └── payment_settings_screen.dart
├── providers/
│   └── affiliate_provider.dart
├── models/
│   └── affiliate_models.dart
├── services/
│   └── affiliate_service.dart
└── widgets/
    └── affiliate/
        ├── affiliate_dashboard_card.dart
        ├── affiliate_stats_card.dart
        └── affiliate_earning_item.dart
```

### 3. Provider Registration
Add the provider to your `main.dart`:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AffiliateProvider()),
    // ... other providers
  ],
  child: MyApp(),
)
```

### 4. Navigation Setup
Add routes to your navigation:
```dart
'/affiliate': (context) => const AffiliateScreen(),
'/affiliate-payment-settings': (context) => const PaymentSettingsScreen(),
```

### 5. Usage Example

#### Access Affiliate Screen
```dart
Navigator.pushNamed(context, '/affiliate');
```

#### Check if User is Affiliate
```dart
final isAffiliate = context.read<AffiliateProvider>().isAffiliate;
```

### 6. API Response Format

#### Dashboard Response
```json
{
  "success": true,
  "data": {
    "balance": 1250.50,
    "stats": {
      "count_click": 45,
      "count_item": 12,
      "count_delivered": 8,
      "count_cancel": 2
    },
    "referral_code": "ABC123XYZ",
    "referral_url": "https://yourapp.com/register?referral_code=ABC123XYZ"
  }
}
```

#### Earning History Response
```json
{
  "success": true,
  "data": {
    "logs": [...],
    "pagination": {...}
  }
}
```

### 7. Error Handling
The system handles:
- Non-affiliate users (404 response)
- Insufficient balance for withdrawals
- Invalid payment settings
- Network errors

### 8. Features Implemented

#### Dashboard View
- Real-time balance display
- Performance statistics
- Referral link sharing
- Quick actions (withdraw, settings)

#### Payment Settings
- PayPal configuration
- Bank account details
- Form validation
- Save functionality

#### Withdrawal System
- Balance validation
- Amount input with limits
- Request submission
- History tracking

### 9. UI Components

#### Custom Widgets
- `AffiliateDashboardCard` - Balance display with actions
- `AffiliateStatsCard` - Statistics display
- `AffiliateEarningItem` - Individual earning entries

#### Responsive Design
- Adapts to different screen sizes
- Material Design 3 compliant
- Dark mode support ready

### 10. Testing Checklist

- [ ] API endpoints return correct data
- [ ] Non-affiliate users see appropriate message
- [ ] Balance updates correctly
- [ ] Referral link copies to clipboard
- [ ] Withdrawal requests validate amount
- [ ] Payment settings save correctly
- [ ] Error messages display appropriately
- [ ] Loading states work correctly

### 11. Security Considerations

- All API calls require authentication token
- Input validation on both client and server
- Rate limiting on withdrawal requests
- Secure storage of payment information

### 12. Future Enhancements

- Add affiliate registration flow
- Implement referral tracking
- Add commission tiers
- Include analytics dashboard
- Add push notifications for earnings

## Troubleshooting

### Common Issues

1. **"User is not an affiliate" error**
   - User needs to apply for affiliate program first
   - Check user role in database

2. **API 404 errors**
   - Ensure routes are properly registered
   - Check base URL configuration

3. **Authentication failures**
   - Verify token is being sent in headers
   - Check token expiration

### Debug Mode
Enable debug logging by setting:
```dart
const bool debugMode = true;
```

## Support
For issues or questions, please check:
1. Laravel logs in `storage/logs/`
2. Flutter debug console
3. API response in network tab
