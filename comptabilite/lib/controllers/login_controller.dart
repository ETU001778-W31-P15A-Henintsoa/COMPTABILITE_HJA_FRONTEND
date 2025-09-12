import 'package:flutter/foundation.dart';

import '../services/login_service.dart';

class LoginController {
  final LoginService _loginService = LoginService();

  Future<int> login(String id, String mdp, int loginattempt) async {
    try {
      final response = await _loginService.login(id, mdp);
      if (response == 1) {
        return 0;
      } else {
        loginattempt = loginattempt + 1;
        return loginattempt;
      }
    } catch (e, stack) {
      debugPrint('Erreur: $e');
      debugPrint('Stack trace: $stack');
      return 0;
    }
  }

}