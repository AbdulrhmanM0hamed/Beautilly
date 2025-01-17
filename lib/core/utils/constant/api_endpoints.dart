class ApiEndpoints {
  static const String _baseUrl = 'https://dallik.com/api';
  static const String api_key = 'uYtG5w92uQfNkl47pT3MxRvA1zqZ8OjY';

  // المصادقة والتسجيل
  static const String login =
      '$_baseUrl/login?api_key=$api_key'; // تسجيل الدخول
  static const String register =
      '$_baseUrl/register?$api_key'; // إنشاء حساب جديد
  static const String logout =
      '$_baseUrl/logout?api_key=$api_key'; // تسجيل الخروج
  static const String forgotPassword =
      '$_baseUrl/auth/forgot-password?api_key=$api_key';
  static const String resetPassword =
      '$_baseUrl/auth/reset-password?api_key=$api_key';
  static const String verifyEmail =
      '$_baseUrl/auth/verify-email?api_key=$api_key';

  // الملف الشخصي
  static const String profile = '$_baseUrl/profile?api_key=$api_key';
  static const String updateProfile =
      '$_baseUrl/profile/update?api_key=$api_key';
  static const String changePassword =
      '$_baseUrl/profile/change-password?api_key=$api_key';

  // الحجوزات
  static const String bookings =
      '$_baseUrl/bookings?api_key=$api_key'; // قائمة الحجوزات
  static const String createBooking =
      '$_baseUrl/bookings/create?api_key=$api_key'; // إنشاء حجز جديد
  static const String cancelBooking =
      '$_baseUrl/bookings/cancel/?api_key=$api_key'; // إلغاء حجز محدد
  static const String bookingHistory =
      '$_baseUrl/bookings/history?api_key=$api_key'; // سجل الحجوزات

  // البحث والتصفية
  static const String search = '$_baseUrl/search?api_key=$api_key';
  static const String categories = '$_baseUrl/categories?api_key=$api_key';
  static const String filters = '$_baseUrl/filters?api_key=$api_key';
  static const String statistics = '$_baseUrl/statistics?api_key=$api_key';

  // المزايا الاجتماعية
  static const String posts = '$_baseUrl/posts?api_key=$api_key';
  static const String comments = '$_baseUrl/comments?api_key=$api_key';
  static const String likes = '$_baseUrl/likes?api_key=$api_key';
  static const String follow = '$_baseUrl/follow?api_key=$api_key';
  static const String unfollow = '$_baseUrl/unfollow?api_key=$api_key';

  // الإشعارات
  static const String notifications =
      '$_baseUrl/notifications?api_key=$api_key'; // قائمة الإشعارات
  static const String markNotificationRead =
      '$_baseUrl/notifications/read/?api_key=$api_key'; // تحديد إشعار كمقروء

  // الباقات والاشتراكات
  static const String packages =
      '$_baseUrl/packages?api_key=$api_key'; // الباقات المتاحة

  // التقييمات
  static const String addReview =
      '$_baseUrl/reviews/add?api_key=$api_key'; // إضافة تقييم جديد
  static const String updateReview =
      '$_baseUrl/reviews/update/?api_key=$api_key'; // تحديث تقييم موجود

  // خدمات الموقع
  static const String updateLocation =
      '$_baseUrl/location/update?api_key=$api_key'; // تحديث الموقع الحالي
  static const String getNearbyVenues =
      '$_baseUrl/venues/nearby?api_key=$api_key'; // الأماكن القريبة

  // الصالونات - تفاصيل كاملة
  static const String special_offers =
      '$_baseUrl/salons/special_offers?api_key=$api_key';
  static const String salonFullDetails =
      '$_baseUrl/salons/full?api_key=$api_key'; // جلب كل بيانات الصالون مرة واحدة (معلومات + خدمات + طاقم + تقييمات + صور + مواعيد)
  static const String salonsByCategory =
      '$_baseUrl/salons/category?api_key=$api_key'; // صالونات حسب التصنيف
  static const String topRatedSalons =
      '$_baseUrl/salons/top-rated?api_key=$api_key'; // أعلى الصالونات تقييماً
  static const String featuredSalons =
      '$_baseUrl/salons/featured?api_key=$api_key'; // الصالونات المميزة
  static const String popularSalons =
      '$_baseUrl/salons/popular?api_key=$api_key'; // الصالونات الأكثر شعبية

  // دور الأزياء - تفاصيل كاملة
  static const String fashionHouseFullDetails =
      '$_baseUrl/fashion-houses/full?api_key=$api_key'; // جلب كل بيانات دار الأزياء مرة واحدة (معلومات + تصاميم + قياسات + تقييمات + صور)
  static const String fashionHousesByStyle =
      '$_baseUrl/fashion-houses/style?api_key=$api_key'; // دور أزياء حسب النمط
  static const String topRatedFashionHouses =
      '$_baseUrl/fashion-houses/top-rated?api_key=$api_key'; // أعلى دور الأزياء تقييماً
  static const String featuredFashionHouses =
      '$_baseUrl/fashion-houses/featured?api_key=$api_key'; // دور الأزياء المميزة
  static const String popularFashionHouses =
      '$_baseUrl/fashion-houses/popular?api_key=$api_key'; // دور الأزياء الأكثر شعبية

  // طلبات التفصيل
  static const String tailoringRequests =
      '$_baseUrl/tailoring-requests?api_key=$api_key'; // عرض كل طلبات التفصيل
  static const String createTailoringRequest =
      '$_baseUrl/tailoring-requests/create?api_key=$api_key'; // إنشاء طلب تفصيل جديد
  static const String myTailoringRequests =
      '$_baseUrl/tailoring-requests/my-requests?api_key=$api_key'; // طلبات التفصيل الخاصة بي
  static const String tailoringRequestDetails =
      '$_baseUrl/tailoring-requests/?api_key=$api_key'; // تفاصيل طلب تفصيل محدد
  static const String updateTailoringRequest =
      '$_baseUrl/tailoring-requests/update/?api_key=$api_key'; // تحديث طلب تفصيل
  static const String deleteTailoringRequest =
      '$_baseUrl/tailoring-requests/delete/?api_key=$api_key'; // حذف طلب تفصيل

  // عروض التفصيل
  static const String tailoringOffers =
      '$_baseUrl/tailoring-offers?api_key=$api_key'; // عرض كل العروض المقدمة على طلب تفصيل
  static const String createTailoringOffer =
      '$_baseUrl/tailoring-offers/create?api_key=$api_key'; // تقديم عرض على طلب تفصيل
  static const String myTailoringOffers =
      '$_baseUrl/tailoring-offers/my-offers?api_key=$api_key'; // العروض التي قدمتها (لدور الأزياء)
  static const String updateTailoringOffer =
      '$_baseUrl/tailoring-offers/update/?api_key=$api_key'; // تحديث عرض مقدم
  static const String acceptTailoringOffer =
      '$_baseUrl/tailoring-offers/accept/?api_key=$api_key'; // قبول عرض تفصيل
  static const String rejectTailoringOffer =
      '$_baseUrl/tailoring-offers/reject/?api_key=$api_key'; // رفض عرض تفصيل
}
