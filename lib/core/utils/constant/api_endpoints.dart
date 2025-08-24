import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  // المتغيرات الأساسية مع قيم افتراضية
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  //================ المصادقة وإدارة الحساب ================//
  static String get login => '$baseUrl/login?apiKey=$apiKey';
  static String get register => '$baseUrl/register?apiKey=$apiKey';
  static String get logout => '$baseUrl/logout';
  static String get forgotPassword =>
      '$baseUrl/forgot-password?apiKey=$apiKey';
  static String get resetPassword => '$baseUrl/reset-password?apiKey=$apiKey';
  static String get refreshToken => '$baseUrl/auth/refresh';

  //================ الملف الشخصي ================//
  static String get profile => '$baseUrl/user/profile?apiKey=$apiKey';
  static String get updateProfile => '$baseUrl/profile';
  static String get changePassword =>
      '$baseUrl/user/change-password?apiKey=$apiKey';
  static String get userStatistics =>
      '$baseUrl/user/statistics?apiKey=$apiKey';

  //================ الطلبات والخدمات ================//
  static String services = '$baseUrl/services?apiKey=$apiKey';
  static String statistics = '$baseUrl/statistics?apiKey=$apiKey';
  static String discounts = '$baseUrl/discounts?apiKey=$apiKey';

  //================ إدارة الطلبات ================//
  static String myOrders = '$baseUrl/my-list-orders?apiKey=$apiKey';
  static String allOrders = '$baseUrl/list-orders';
  static String addMyOrder = '$baseUrl/add-my-orders?apiKey=$apiKey';
  static String myReservations = '$baseUrl/my-reservations';

  static String deleteOrder(int id) =>
      '$baseUrl/my-list-orders/$id?apiKey=$apiKey';
  static String orderDetails(int orderId) => '$baseUrl/orders/$orderId/details';

  //================ العروض والتفاعلات ================//
  static String acceptOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/accept-offer/$offerId?apiKey=$apiKey';
  static String cancelOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/cancel-offer/$offerId?apiKey=$apiKey';

  //================ المتاجر والصالونات ================//
  static String premiumShops = '$baseUrl/shops/premium?apiKey=$apiKey';
  static String shopProfile(int shopId) =>
      '$baseUrl/shops/$shopId/?apiKey=$apiKey';
  static String shopFullDetails(int shopId) =>
      '$baseUrl/shops/$shopId/full-details?apiKey=$apiKey';

  //================ التقييمات والمفضلة ================//
  static String addShopRating(int shopId) =>
      '$baseUrl/shops/$shopId/rate?apiKey=$apiKey';
  static String deleteShopRating(int shopId) =>
      '$baseUrl/shops/$shopId/rate?apiKey=$apiKey';
  static String myFavoriteShops =
      '$baseUrl/my-favorite-shops/?apiKey=$apiKey';
  static String addToFavorites(int shopId) =>
      '$baseUrl/shops/$shopId/like?apiKey=$apiKey';
  static String removeFromFavorites(int shopId) =>
      '$baseUrl/shops/$shopId/like?apiKey=$apiKey';

  //================ الحجوزات ================//
  static String bookService(int shopId) =>
      '$baseUrl/shops/$shopId/book-service?apiKey=$apiKey';
  static String bookDiscount(int shopId) =>
      '$baseUrl/shops/$shopId/book-discount?apiKey=$apiKey';
  static String cancelAppointment(int serviceId) =>
      '$baseUrl/appointments/$serviceId/cancel?apiKey=$apiKey';

  //================ البحث والتصفية ================//
  static String searchServices(String query) =>
      '$baseUrl/services/search?query=$query&apiKey=$apiKey';
  static String searchShops = '$baseUrl/shops/search';
  static String searchShopsByType({String? type, String? search}) =>
      '$baseUrl/shops/search?type=$type${search != null ? '&search=$search' : ''}&apiKey=$apiKey';
      

  //================ الإشعارات ================//
  static String notifications = '$baseUrl/notifications?apiKey=$apiKey';
  static String notificationsDelete =
      '$baseUrl/notifications/all?apiKey=$apiKey';
  static String getMarkNotificationReadPath(String id) =>
      '$baseUrl/notifications/$id/read?apiKey=$apiKey';

  //================ دالة تصفية المتاجر ================//
  static String filterShops({String? type, String? search, int page = 1}) {
    final params = <String, String>{
      'apiKey': apiKey,
      'page': page.toString(),
    };

    if (type != null && type != 'all') {
      params['type'] = type;
    }

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    final queryString =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$baseUrl/filter-shops?$queryString';
  }
}
