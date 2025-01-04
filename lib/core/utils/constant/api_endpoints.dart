class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'YOUR_BASE_URL';
  static const String apiVersion = '/api/v1';
  
  // Auth Endpoints
  static const String login = '$apiVersion/auth/login';
  static const String register = '$apiVersion/auth/register';
  static const String forgotPassword = '$apiVersion/auth/forgot-password';
  static const String resetPassword = '$apiVersion/auth/reset-password';
  static const String refreshToken = '$apiVersion/auth/refresh-token';
  
  // User Endpoints
  static const String userProfile = '$apiVersion/user/profile';
  static const String updateProfile = '$apiVersion/user/update';
  static const String changePassword = '$apiVersion/user/change-password';
  static const String userBookings = '$apiVersion/user/bookings';
  static const String userFavorites = '$apiVersion/user/favorites';
  
  // Salon Endpoints
  static const String salons = '$apiVersion/salons';
  static const String salonDetails = '$apiVersion/salons/'; // Append salon ID
  static const String salonServices = '$apiVersion/salons/services/'; // Append salon ID
  static const String salonReviews = '$apiVersion/salons/reviews/'; // Append salon ID
  static const String salonStaff = '$apiVersion/salons/staff/'; // Append salon ID
  static const String salonGallery = '$apiVersion/salons/gallery/'; // Append salon ID
  
  // Booking Endpoints
  static const String createBooking = '$apiVersion/bookings/create';
  static const String updateBooking = '$apiVersion/bookings/update/'; // Append booking ID
  static const String cancelBooking = '$apiVersion/bookings/cancel/'; // Append booking ID
  
  // Services Endpoints
  static const String services = '$apiVersion/services';
  static const String serviceCategories = '$apiVersion/services/categories';
  
  // Review Endpoints
  static const String addReview = '$apiVersion/reviews/add';
  static const String updateReview = '$apiVersion/reviews/update/'; // Append review ID
  
  // Search Endpoints
  static const String search = '$apiVersion/search';
  static const String filter = '$apiVersion/filter';
  
  // Location Endpoints
  static const String cities = '$apiVersion/locations/cities';
  static const String districts = '$apiVersion/locations/districts';
}
