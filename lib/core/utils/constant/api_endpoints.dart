class ApiEndpoints {
  static const String _baseUrl =
      'https://api.beautilly.com/api'; // قم بتغيير هذا حسب الباك إند
//https://dallik.com/api/users?api_key=uYtG5w92uQfNkl47pT3MxRvA1zqZ8OjY
  // المصادقة والتسجيل
  static const String login = '$_baseUrl/auth/login'; // تسجيل الدخول
  static const String register = '$_baseUrl/auth/register'; // إنشاء حساب جديد
  static const String logout = '$_baseUrl/auth/logout'; // تسجيل الخروج
  static const String forgotPassword =
      '$_baseUrl/auth/forgot-password'; // نسيت كلمة المرور
  static const String resetPassword =
      '$_baseUrl/auth/reset-password'; // إعادة تعيين كلمة المرور
  static const String verifyEmail =
      '$_baseUrl/auth/verify-email'; // تأكيد البريد الإلكتروني

  // الملف الشخصي
  static const String profile = '$_baseUrl/profile'; // عرض الملف الشخصي
  static const String updateProfile =
      '$_baseUrl/profile/update'; // تحديث الملف الشخصي
  static const String changePassword =
      '$_baseUrl/profile/change-password'; // تغيير كلمة المرور

  // الحجوزات
  static const String bookings = '$_baseUrl/bookings'; // قائمة الحجوزات
  static const String createBooking =
      '$_baseUrl/bookings/create'; // إنشاء حجز جديد
  static const String cancelBooking =
      '$_baseUrl/bookings/cancel/'; // إلغاء حجز محدد
  static const String bookingHistory =
      '$_baseUrl/bookings/history'; // سجل الحجوزات

  // البحث والتصفية
  static const String search = '$_baseUrl/search'; // البحث العام
  static const String categories = '$_baseUrl/categories'; // التصنيفات
  static const String filters = '$_baseUrl/filters'; // خيارات التصفية

  // المزايا الاجتماعية
  static const String posts = '$_baseUrl/posts'; // المنشورات
  static const String comments = '$_baseUrl/comments'; // التعليقات
  static const String likes = '$_baseUrl/likes'; // الإعجابات
  static const String follow = '$_baseUrl/follow'; // المتابعة
  static const String unfollow = '$_baseUrl/unfollow'; // إلغاء المتابعة

  // الإشعارات
  static const String notifications =
      '$_baseUrl/notifications'; // قائمة الإشعارات
  static const String markNotificationRead =
      '$_baseUrl/notifications/read/'; // تحديد إشعار كمقروء

  // الباقات والاشتراكات
  static const String packages = '$_baseUrl/packages'; // الباقات المتاحة

  // التقييمات
  static const String addReview = '$_baseUrl/reviews/add'; // إضافة تقييم جديد
  static const String updateReview =
      '$_baseUrl/reviews/update/'; // تحديث تقييم موجود

  // خدمات الموقع
  static const String updateLocation =
      '$_baseUrl/location/update'; // تحديث الموقع الحالي
  static const String getNearbyVenues =
      '$_baseUrl/venues/nearby'; // الأماكن القريبة

  // الصالونات - تفاصيل كاملة
  static const String salonFullDetails =
      '$_baseUrl/salons/full/'; // جلب كل بيانات الصالون مرة واحدة (معلومات + خدمات + طاقم + تقييمات + صور + مواعيد)
  static const String salonsByCategory =
      '$_baseUrl/salons/category/'; // صالونات حسب التصنيف
  static const String topRatedSalons =
      '$_baseUrl/salons/top-rated'; // أعلى الصالونات تقييماً
  static const String featuredSalons =
      '$_baseUrl/salons/featured'; // الصالونات المميزة
  static const String popularSalons =
      '$_baseUrl/salons/popular'; // الصالونات الأكثر شعبية

  // دور الأزياء - تفاصيل كاملة
  static const String fashionHouseFullDetails =
      '$_baseUrl/fashion-houses/full/'; // جلب كل بيانات دار الأزياء مرة واحدة (معلومات + تصاميم + قياسات + تقييمات + صور)
  static const String fashionHousesByStyle =
      '$_baseUrl/fashion-houses/style/'; // دور أزياء حسب النمط
  static const String topRatedFashionHouses =
      '$_baseUrl/fashion-houses/top-rated'; // أعلى دور الأزياء تقييماً
  static const String featuredFashionHouses =
      '$_baseUrl/fashion-houses/featured'; // دور الأزياء المميزة
  static const String popularFashionHouses =
      '$_baseUrl/fashion-houses/popular'; // دور الأزياء الأكثر شعبية

  // طلبات التفصيل
  static const String tailoringRequests =
      '$_baseUrl/tailoring-requests'; // عرض كل طلبات التفصيل

  static const String createTailoringRequest =
      '$_baseUrl/tailoring-requests/create'; // إنشاء طلب تفصيل جديد

  static const String myTailoringRequests =
      '$_baseUrl/tailoring-requests/my-requests'; // طلبات التفصيل الخاصة بي

  static const String tailoringRequestDetails =
      '$_baseUrl/tailoring-requests/'; // تفاصيل طلب تفصيل محدد

  static const String updateTailoringRequest =
      '$_baseUrl/tailoring-requests/update/'; // تحديث طلب تفصيل

  static const String deleteTailoringRequest =
      '$_baseUrl/tailoring-requests/delete/'; // حذف طلب تفصيل

  // عروض التفصيل
  static const String tailoringOffers =
      '$_baseUrl/tailoring-offers'; // عرض كل العروض المقدمة على طلب تفصيل

  static const String createTailoringOffer =
      '$_baseUrl/tailoring-offers/create'; // تقديم عرض على طلب تفصيل

  static const String myTailoringOffers =
      '$_baseUrl/tailoring-offers/my-offers'; // العروض التي قدمتها (لدور الأزياء)

  static const String updateTailoringOffer =
      '$_baseUrl/tailoring-offers/update/'; // تحديث عرض مقدم

  static const String acceptTailoringOffer =
      '$_baseUrl/tailoring-offers/accept/'; // قبول عرض تفصيل

  static const String rejectTailoringOffer =
      '$_baseUrl/tailoring-offers/reject/'; // رفض عرض تفصيل
}
