import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.avatarUrl,
    required super.role,
    required super.subscriptionPlan,
    required super.isEmailVerified,
    required super.createdAt,
    super.lastLoginAt,
    super.credits = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] != null
          ? UserRole.values.byName(json['role'] as String)
          : UserRole.seller,
      subscriptionPlan: json['subscription_plan'] != null
          ? SubscriptionPlan.values.byName(json['subscription_plan'] as String)
          : SubscriptionPlan.free,
      isEmailVerified: (json['email_verified'] ?? json['is_email_verified']) as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : null,
      credits: json['credits'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role.name,
      'subscription_plan': subscriptionPlan.name,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'credits': credits,
    };
  }
}
