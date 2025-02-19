class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    // }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    return null;
  }


  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    // Saudi Arabia phone number format
    // final phoneRegex = RegExp(r'^(05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$');
    // if (!phoneRegex.hasMatch(value)) {
    //   return 'رقم الهاتف غير صالح';
    // }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الطول';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'الرجاء إدخال رقم صحيح';
    }

    if (height < 100 || height > 220) {
      return 'الرجاء إدخال طول منطقي (100-220 سم)';
    }

    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الوزن';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'الرجاء إدخال رقم صحيح';
    }

    if (weight < 30 || weight > 200) {
      return 'الرجاء إدخال وزن منطقي (30-200 كجم)';
    }

    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الوصف';
    }

    if (value.length < 10) {
      return 'الوصف قصير جداً (10 أحرف على الأقل)';
    }

    if (value.length > 500) {
      return 'الوصف طويل جداً (500 حرف كحد أقصى)';
    }

    return null;
  }

  static String? validateExecutionTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال وقت التنفيذ';
    }

    final days = int.tryParse(value);
    if (days == null) {
      return 'الرجاء إدخال رقم صحيح';
    }

    if (days < 1) {
      return 'وقت التنفيذ لا يمكن أن يكون أقل من يوم';
    }

    if (days > 90) {
      return 'وقت التنفيذ لا يمكن أن يتجاوز 90 يوم';
    }

    return null;
  }
}
