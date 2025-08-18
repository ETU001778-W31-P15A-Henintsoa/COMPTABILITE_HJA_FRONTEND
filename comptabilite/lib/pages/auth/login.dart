import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/image.dart';
import '../../controllers/login_controller.dart';
import '../home/home.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [ _Logo(), _FormContent() ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(child: Center(child: _FormContent())),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final logoimage = Images.getLogo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoimage,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bienvenue dans le logiciel de compotabilite HJA",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final TextEditingController _IdentifiantController = TextEditingController();
  final TextEditingController _MotdepasseController = TextEditingController();

  final LoginController _controller = LoginController();
  int _loginAttempts = 0;
  
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isBlocked = false;
  DateTime _blockedUntil = DateTime(1000, 1, 1);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadBlockedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextFormField(
            controller: _IdentifiantController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Identifiant manquant';
              }
              return null;
            },
            decoration: const InputDecoration(
            labelText: 'Identifiant',
            hintText: 'Saisir identifiant...',
            focusColor: Color(0xFF268d7c),
            prefixIcon: Icon(Icons.person_outline_rounded),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF268d7c)),
            ),
            ),
          ),
          _gap(),
          TextFormField(
            controller: _MotdepasseController,
            validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Mot de passe manquant';
                  }
                  return null;
                },
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Saisir votre mot de passe...',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF268d7c)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
          _gap(),
          CheckboxListTile(
            value: _rememberMe,
            onChanged: (value) {
            if (value == null) return;
              setState(() {
                _rememberMe = value;
              });
            },
            title: const Text('Se souvenir de moi'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: const EdgeInsets.all(0),
          ),
          _gap(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                overlayColor: Color(0xFF78bd68),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Color(0xFF268d7c)),
                ),
              ),
              onPressed: _handleLogin,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF113320),
                  ),
                ),
              ),
            ),
          )
          ]
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Future<void> _loadBlockedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? blockedUntilString = prefs.getString('blocked_until');
    
    if (blockedUntilString != null) {
      _blockedUntil = DateTime.parse(blockedUntilString);
      if (_blockedUntil.isAfter(DateTime.now())) {
        setState(() {
          _isBlocked = true;
        });
      }else{
        setState(() {
          _isBlocked = false;
        });
      }
    }
  }

  Future<void> _saveBlockedStatus(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('blocked_until', time.toIso8601String());
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      String id = _IdentifiantController.text.trim();
      String mdp = _MotdepasseController.text.trim();

      int login = await _controller.login(id, mdp, _loginAttempts);
                  
      if (_blockedUntil.isBefore(DateTime.now()) && login == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (_blockedUntil.isBefore(DateTime.now()) && _loginAttempts >= 6) {
        setState(() {
          _isBlocked = true;
          _loginAttempts = 0;
          _blockedUntil = DateTime.now().add(Duration(hours: 1));
          _saveBlockedStatus(_blockedUntil);
          debugPrint('Vous êtes bloqué jusqu\'à: $_blockedUntil');
        });                                            

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous êtes bloqué pour 1 heure.')),
        );
      } else if (_blockedUntil!.isBefore(DateTime.now()) && _loginAttempts < 6 && login != 0) {
        setState(() {
          _loginAttempts = login;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text.rich(
              TextSpan(
                text: "Mot de passe ou identifiant invalide. ",
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: "Créer ce compte?",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 53, 56, 105),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Contact Administrateur"),
                              content: Text("Veuillez contacter l'administrateur pour créer un compte.\n +261 34 04 093 46 \n herinjanahary@gmail.com"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Fermer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                  ),
                ],
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez épuisé vos tentatives. Veuillez réessayer après 1 heure.')),
        );
      }
    }
  }


  
}
