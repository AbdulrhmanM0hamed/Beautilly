class ApiEndpoints {
  // المتغيرات الأساسية
  static const String baseUrl = 'https://dallik.com/api';
  static const String api_key = 'uYtG5w92uQfNkl47pT3MxRvA1zqZ8OjY';

  //================ المصادقة وإدارة الحساب ================//
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register?api_key=$api_key';
  static const String logout = '$baseUrl/logout';
  static const String forgotPassword = '$baseUrl/forgot-password?api_key=$api_key';
  static const String resetPassword = '$baseUrl/reset-password?api_key=$api_key';
  static const String refreshToken = '$baseUrl/auth/refresh';

  //================ الملف الشخصي ================//
  static const String profile = '$baseUrl/user/profile?api_key=$api_key';
  static const String updateProfile = '$baseUrl/profile';
  static const String changePassword = '$baseUrl/user/change-password?api_key=$api_key';
  static const String userStatistics = '$baseUrl/user/statistics?api_key=$api_key';

  //================ الطلبات والخدمات ================//
  static const String services = '$baseUrl/services?api_key=$api_key';
  static const String statistics = '$baseUrl/statistics?api_key=$api_key';
  static const String discounts = '$baseUrl/discounts?api_key=$api_key';

  //================ إدارة الطلبات ================//
  static const String myOrders = '$baseUrl/my-list-orders?api_key=$api_key';
  static const String allOrders = '$baseUrl/list-orders';
  static const String addMyOrder = '$baseUrl/add-my-orders?api_key=$api_key';
  static const String myReservations = '$baseUrl/my-reservations';
  
  static String deleteOrder(int id) => '$baseUrl/my-list-orders/$id?api_key=$api_key';
  static String orderDetails(int orderId) => '$baseUrl/orders/$orderId/details';

  //================ العروض والتفاعلات ================//
  static String acceptOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/accept-offer/$offerId?api_key=$api_key';
  static String cancelOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/cancel-offer/$offerId?api_key=$api_key';

  //================ المتاجر والصالونات ================//
  static const String premiumShops = '$baseUrl/shops/premium?api_key=$api_key';
  static String shopProfile(int shopId) => '$baseUrl/shops/$shopId/?api_key=$api_key';
  static String shopFullDetails(int shopId) => '$baseUrl/shops/$shopId/full-details?api_key=$api_key';

  //================ التقييمات والمفضلة ================//
  static String addShopRating(int shopId) => '$baseUrl/shops/$shopId/rate?api_key=$api_key';
  static String deleteShopRating(int shopId) => '$baseUrl/shops/$shopId/rate?api_key=$api_key';
  static const String myFavoriteShops = '$baseUrl/my-favorite-shops/?api_key=$api_key';
  static String addToFavorites(int shopId) => '$baseUrl/shops/$shopId/like?api_key=$api_key';
  static String removeFromFavorites(int shopId) => '$baseUrl/shops/$shopId/like?api_key=$api_key';

  //================ الحجوزات ================//
  static String bookService(int shopId) => '$baseUrl/shops/$shopId/book-service?api_key=$api_key';
  static String bookDiscount(int shopId) => '$baseUrl/shops/$shopId/book-discount?api_key=$api_key';
  static String cancelAppointment(int serviceId) => '$baseUrl/appointments/$serviceId/cancel?api_key=$api_key';

  //================ البحث والتصفية ================//
  static String searchServices(String query) => '$baseUrl/services/search?query=$query&api_key=$api_key';
  static String searchShops = '$baseUrl/shops/search';
  static String searchShopsByType({String? type, String? search}) =>
      '$baseUrl/shops/search?type=$type${search != null ? '&search=$search' : ''}&api_key=$api_key';

  //================ الإشعارات ================//
  static const String notifications = '$baseUrl/notifications?api_key=$api_key';
  static const String notificationsDelete = '$baseUrl/notifications/all?api_key=$api_key';
  static String getMarkNotificationReadPath(String id) => '$baseUrl/notifications/$id/read?api_key=$api_key';

  //================ دالة تصفية المتاجر ================//
  static String filterShops({String? type, String? search, int page = 1}) {
    final params = <String, String>{
      'api_key': api_key,
      'page': page.toString(),
    };

    if (type != null && type != 'all') {
      params['type'] = type;
    }

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$baseUrl/filter-shops?$queryString';
  }
}
