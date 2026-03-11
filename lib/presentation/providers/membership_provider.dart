import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/services/membership_service.dart';

class MembershipProvider extends ChangeNotifier {
  MembershipProvider(this._membershipService);

  final MembershipService _membershipService;

  List<MembershipPlanModel> plans = const [];
  bool isLoading = false;
  String? error;

  Future<void> loadPlans() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      plans = await _membershipService.fetchPlans();
    } on ApiException catch (exception) {
      error = exception.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
