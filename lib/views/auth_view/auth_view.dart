import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/auth_service/auth_service.dart';
import 'package:pregnancy_application/service/strings.dart';
import 'package:pregnancy_application/views/home_view/home_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool value = false;
  int type = 0;
  String? dropdownText;

  List<String> list = [doctor, patient];

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();

  void userRegister() {
    AuthService().register(
        email: _email.text,
        pass: _password.text,
        name: _username.text,
        type: dropdownText!).then((value){
          if(value.toString().contains(_email.text)){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
          }
    });
  }

  void userLogin() {
    AuthService().login(email: _email.text, pass: _password.text).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(appTitle,style: TextStyle(
                  fontSize: 25
              ),),
              Image.asset('assets/images/im4.jpeg'),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInQuad,
                        child: value ? loginWidget() : registerWidget()),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            setState(() {
                              value = !value;
                            });
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeInQuad,
                            child: value
                                ? const Text(
                              register,
                              style: TextStyle(fontSize: 18),
                              key: Key('1'),
                            )
                                : const Text(
                              login,
                              style: TextStyle(fontSize: 18),
                              key: Key('2'),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      key: const Key('1'),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: name),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: email),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: pass),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text('$choice: '),
                const SizedBox(
                  width: 8,
                ),
                DropdownButton(
                    value: dropdownText,
                    items: list.map((e){
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        dropdownText = val!;
                      });
                    }
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  onPressed: userRegister,
                  child: const Text(
                    register,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginWidget() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      key: const Key('2'),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: email),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: pass),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  onPressed: userLogin,
                  child: const Text(
                    login,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
