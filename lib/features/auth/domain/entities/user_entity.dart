import 'package:equatable/equatable.dart';

enum UserRole { admin, seller, viewer }

enum SubscriptionPlan { free, starter, professional, enterprise }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final UserRole role;
  final SubscriptionPlan subscriptionPlan;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final int credits;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.subscriptionPlan,
    required this.isEmailVerified,
    required this.createdAt,
    this.lastLoginAt,
    this.credits = 0,
  });

  bool get isPro =>
      subscriptionPlan == SubscriptionPlan.professional ||
      subscriptionPlan == SubscriptionPlan.enterprise;

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        avatarUrl,
        role,
        subscriptionPlan,
        isEmailVerified,
        createdAt,
        lastLoginAt,
        credits,
      ];
}
