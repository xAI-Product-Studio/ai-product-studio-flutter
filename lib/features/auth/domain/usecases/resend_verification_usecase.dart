import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class ResendVerificationUseCase {
  final AuthRepository _repository;

  const ResendVerificationUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.resendVerification();
  }
}
