enum ShopType {
  all,
  salon,
  tailor;

  String get apiValue {
    switch (this) {
      case ShopType.all:
        return '';
      case ShopType.salon:
        return 'salon';
      case ShopType.tailor:
        return 'tailor';
    }
  }

  String get arabicName {
    switch (this) {
      case ShopType.all:
        return 'الكل';
      case ShopType.salon:
        return 'صالونات';
      case ShopType.tailor:
        return 'دور أزياء';
    }
  }
} 