class ApiEndpoints {
  static const String _baseUrl =
      'https://api.beautilly.com/api'; // قم بتغيير هذا حسب الباك إند

  // Authentication
  static const String login = '$_baseUrl/auth/login';
  static const String register = '$_baseUrl/auth/register';
  static const String logout = '$_baseUrl/auth/logout';
  static const String forgotPassword = '$_baseUrl/auth/forgot-password';
  static const String resetPassword = '$_baseUrl/auth/reset-password';
  static const String verifyEmail = '$_baseUrl/auth/verify-email';

  // Profile
  static const String profile = '$_baseUrl/profile';
  static const String updateProfile = '$_baseUrl/profile/update';
  static const String changePassword = '$_baseUrl/profile/change-password';

  // Salons
  static const String salons = '$_baseUrl/salons';
  static const String salonDetails = '$_baseUrl/salons/'; // + salonId
  static const String nearbySalons =
      '$_baseUrl/salons/nearby'; // مع إرسال الموقع
  static const String salonServices = '$_baseUrl/salons/services/'; // + salonId
  static const String salonStaff = '$_baseUrl/salons/staff/'; // + salonId
  static const String salonReviews = '$_baseUrl/salons/reviews/'; // + salonId
  static const String salonGallery = '$_baseUrl/salons/gallery/'; // + salonId
  static const String salonSchedule = '$_baseUrl/salons/schedule/'; // + salonId

  // Fashion Houses
  static const String fashionHouses = '$_baseUrl/fashion-houses';
  static const String fashionHouseDetails = '$_baseUrl/fashion-houses/'; // + id
  static const String nearbyFashionHouses = '$_baseUrl/fashion-houses/nearby';
  static const String fashionHouseCollections =
      '$_baseUrl/fashion-houses/collections/'; // + id
  static const String fashionHouseMeasurements =
      '$_baseUrl/fashion-houses/measurements/'; // + id

  // Bookings
  static const String bookings = '$_baseUrl/bookings';
  static const String createBooking = '$_baseUrl/bookings/create';
  static const String cancelBooking =
      '$_baseUrl/bookings/cancel/'; // + bookingId
  static const String bookingHistory = '$_baseUrl/bookings/history';

  // Search & Filters
  static const String search = '$_baseUrl/search';
  static const String categories = '$_baseUrl/categories';
  static const String filters = '$_baseUrl/filters';

  // Social Features
  static const String posts = '$_baseUrl/posts';
  static const String comments = '$_baseUrl/comments';
  static const String likes = '$_baseUrl/likes';
  static const String follow = '$_baseUrl/follow';
  static const String unfollow = '$_baseUrl/unfollow';

  // Notifications
  static const String notifications = '$_baseUrl/notifications';
  static const String markNotificationRead =
      '$_baseUrl/notifications/read/'; // + notificationId

  // Packages & Subscriptions
  static const String packages = '$_baseUrl/packages';
  static const String subscribe = '$_baseUrl/subscribe';
  static const String subscriptionStatus = '$_baseUrl/subscription/status';

  // Reviews & Ratings
  static const String addReview = '$_baseUrl/reviews/add';
  static const String updateReview = '$_baseUrl/reviews/update/'; // + reviewId

  // Location Services
  static const String updateLocation = '$_baseUrl/location/update';
  static const String getNearbyVenues =
      '$_baseUrl/venues/nearby'; // سيتم إرسال الإحداثيات معها
}
