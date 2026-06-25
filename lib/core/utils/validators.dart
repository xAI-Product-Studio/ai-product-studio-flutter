abstract class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi boş bırakılamaz.';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş bırakılamaz.';
    }
    if (value.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Şifre en az bir büyük harf içermelidir.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Şifre en az bir rakam içermelidir.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı boş bırakılamaz.';
    }
    if (value != originalPassword) {
      return 'Şifreler eşleşmiyor.';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ad soyad boş bırakılamaz.';
    }
    if (value.trim().length < 3) {
      return 'Ad soyad en az 3 karakter olmalıdır.';
    }
    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value.trim())) {
      return 'Ad soyad yalnızca harf içermelidir.';
    }
    return null;
  }

  static String? required(String? value, {String fieldName = 'Bu alan'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName boş bırakılamaz.';
    }
    return null;
  }

  static String? minLength(String? value, int min,
      {String fieldName = 'Bu alan'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName boş bırakılamaz.';
    }
    if (value.trim().length < min) {
      return '$fieldName en az $min karakter olmalıdır.';
    }
    return null;
  }
}
