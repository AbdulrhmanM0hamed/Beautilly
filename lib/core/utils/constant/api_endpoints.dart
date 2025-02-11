class ApiEndpoints {
  static const String baseUrl = 'https://dallik.com/api';
  static const String api_key = 'uYtG5w92uQfNkl47pT3MxRvA1zqZ8OjY';

  // المصادقة والتسجيل
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register?api_key=$api_key';
  static const String logout = '$baseUrl/logout';
  static const String forgotPassword =
      '$baseUrl/forgot-password?api_key=$api_key';
  static const String resetPassword =
      '$baseUrl/reset-password?api_key=$api_key';
  static const String verifyEmail =
      '$baseUrl/auth/verify-email?api_key=$api_key';

  // الملف الشخصي
  static const String profile = '$baseUrl/user/profile?api_key=$api_key';
  static const String updateProfile = '$baseUrl/profile';
  static const String changePassword =
      '$baseUrl/profile/change-password?api_key=$api_key';

  // الحجوزات
  static const String bookings =
      '$baseUrl/bookings?api_key=$api_key'; // قائمة الحجوزات
  static const String createBooking =
      '$baseUrl/bookings/create?api_key=$api_key'; // إنشاء حجز جديد
  static const String cancelBooking =
      '$baseUrl/bookings/cancel/?api_key=$api_key'; // إلغاء حجز محدد
  static const String bookingHistory =
      '$baseUrl/bookings/history?api_key=$api_key'; // سجل الحجوزات

  // البحث والتصفية
  static const String search = '$baseUrl/search?api_key=$api_key';
  static const String categories = '$baseUrl/categories?api_key=$api_key';
  static const String filters = '$baseUrl/filters?api_key=$api_key';
  static const String statistics = '$baseUrl/statistics?api_key=$api_key';
  static const String services = '$baseUrl/services?api_key=$api_key';

  // المزايا الاجتماعية
  static const String posts = '$baseUrl/posts?api_key=$api_key';
  static const String comments = '$baseUrl/comments?api_key=$api_key';
  static const String likes = '$baseUrl/likes?api_key=$api_key';
  static const String follow = '$baseUrl/follow?api_key=$api_key';
  static const String unfollow = '$baseUrl/unfollow?api_key=$api_key';

  // الإشعارات
  static const String notifications =
      '$baseUrl/notifications?api_key=$api_key'; // قائمة الإشعارات
  static const String markNotificationRead =
      '$baseUrl/notifications/read/?api_key=$api_key'; // تحديد إشعار كمقروء

  // الباقات والاشتراكات
  static const String packages =
      '$baseUrl/packages?api_key=$api_key'; // الباقات المتاحة

  // التقييمات
  static const String addReview =
      '$baseUrl/reviews/add?api_key=$api_key'; // إضافة تقييم جديد
  static const String updateReview =
      '$baseUrl/reviews/update/?api_key=$api_key';
  // تحديث تقييم موجود
  static const String myFavoriteShops =
      '$baseUrl/my-favorite-shops/?api_key=$api_key';

  // خدمات الموقع
  static const String updateLocation =
      '$baseUrl/location/update?api_key=$api_key'; // تحديث الموقع الحالي
  static const String getNearbyVenues =
      '$baseUrl/venues/nearby?api_key=$api_key'; // الأماكن القريبة

  // الصالونات - تفاصيل كاملة
  static const String discounts = '$baseUrl/discounts?api_key=$api_key';
  static const String salonFullDetails =
      '$baseUrl/salons/full?api_key=$api_key'; // جلب كل بيانات الصالون مرة واحدة (معلومات + خدمات + طاقم + تقييمات + صور + مواعيد)
  static const String salonsByCategory =
      '$baseUrl/salons/category?api_key=$api_key'; // صالونات حسب التصنيف
  static const String topRatedSalons =
      '$baseUrl/salons/top-rated?api_key=$api_key'; // أعلى الصالونات تقييماً
  static const String featuredSalons =
      '$baseUrl/salons/featured?api_key=$api_key'; // الصالونات المميزة
  static const String premiumShops =
      '$baseUrl/shops/premium?api_key=$api_key'; // الصالونات الأكثر شعبية
  static String shopProfile(int shopId) =>
      '$baseUrl/shops/$shopId/?api_key=$api_key'; // الصالونات الأكثر شعبية

  // دور الأزياء - تفاصيل كاملة
  static const String fashionHouseFullDetails =
      '$baseUrl/fashion-houses/full?api_key=$api_key'; // جلب كل بيانات دار الأزياء مرة واحدة (معلومات + تصاميم + قياسات + تقييمات + صور)
  static const String fashionHousesByStyle =
      '$baseUrl/fashion-houses/style?api_key=$api_key'; // دور أزياء حسب النمط
  static const String topRatedFashionHouses =
      '$baseUrl/fashion-houses/top-rated?api_key=$api_key'; // أعلى دور الأزياء تقييماً
  static const String featuredFashionHouses =
      '$baseUrl/fashion-houses/featured?api_key=$api_key'; // دور الأزياء المميزة
  static const String popularFashionHouses =
      '$baseUrl/fashion-houses/popular?api_key=$api_key'; // دور الأزياء الأكثر شعبية

  // طلبات التفصيل
  static const String tailoringRequests =
      '$baseUrl/tailoring-requests?api_key=$api_key'; // عرض كل طلبات التفصيل
  static const String addMyOrder =
      '$baseUrl/add-my-orders?api_key=$api_key'; // إنشاء طلب تفصيل جديد
  static const String myTailoringRequests =
      '$baseUrl/tailoring-requests/my-requests?api_key=$api_key'; // طلبات التفصيل الخاصة بي
  static const String tailoringRequestDetails =
      '$baseUrl/tailoring-requests/?api_key=$api_key'; // تفاصيل طلب تفصيل محدد
  static const String updateTailoringRequest =
      '$baseUrl/tailoring-requests/update/?api_key=$api_key';
  // تحديث طلب تفصيل

  static String deleteOrder(int id) =>
      '$baseUrl/my-list-orders/$id?api_key=$api_key';

  // عروض التفصيل
  static const String tailoringOffers =
      '$baseUrl/tailoring-offers?api_key=$api_key'; // عرض كل العروض المقدمة على طلب تفصيل
  static const String createTailoringOffer =
      '$baseUrl/tailoring-offers/create?api_key=$api_key'; // تقديم عرض على طلب تفصيل
  static const String myTailoringOffers =
      '$baseUrl/tailoring-offers/my-offers?api_key=$api_key'; // العروض التي قدمتها (لدور الأزياء)
  static const String updateTailoringOffer =
      '$baseUrl/tailoring-offers/update/?api_key=$api_key'; // تحديث عرض مقدم
  static const String acceptTailoringOffer =
      '$baseUrl/tailoring-offers/accept/?api_key=$api_key'; // قبول عرض تفصيل
  static const String rejectTailoringOffer =
      '$baseUrl/tailoring-offers/reject/?api_key=$api_key'; // رفض عرض تفصيل

  // Orders
  static const String myOrders = '$baseUrl/my-list-orders';
  static const String myReservations =
      '$baseUrl/my-reservations?api_key=$api_key';

  static String orderDetails(int orderId) => '$baseUrl/orders/$orderId/details';
  static String acceptOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/accept-offer/$offerId?api_key=$api_key';
  static String cancelOffer(int orderId, int offerId) =>
      '$baseUrl/orders/$orderId/cancel-offer/$offerId?api_key=$api_key';

  // Ratings & Reviews
  static String addShopRating(int shopId) => 
    '$baseUrl/shops/$shopId/rate?api_key=$api_key';
  
  static String deleteShopRating(int shopId) => 
    '$baseUrl/shops/$shopId/rate?api_key=$api_key';

  // Favorites
  static String addToFavorites(int shopId) => 
    '$baseUrl/shops/$shopId/like?api_key=$api_key';
  
  static String removeFromFavorites(int shopId) => 
    '$baseUrl/shops/$shopId/like?api_key=$api_key';
}
