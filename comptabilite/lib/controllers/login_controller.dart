import '../services/login_service.dart';
import 'package:flutter/foundation.dart';

class LoginController {
  final LoginService _loginService = LoginService();

  Future<int> login(String username, String password, int loginattempt) async {
    try {
      // final response = await _loginService.login(username, password);
      // if (!response) {
        loginattempt = loginattempt + 1;
      // } else {
        // return 0;
      // }
    } catch (e, stack) {
      debugPrint('Erreur: $e');
      debugPrint('Stack trace: $stack');
    } finally {
      // ignore: control_flow_in_finally
      return loginattempt;
    }
     
  }

}