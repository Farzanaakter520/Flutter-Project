import 'package:flutter/material.dart';
import 'package:hospital_app/screens/SignUpScreen.dart';
import 'package:hospital_app/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(
                  //     builder: (context) =>
                  // ));
                },
                child: Text(
                  "SKIP",
                  style: TextStyle(color: Color(0xFF7165D6), fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 60, width: 90),
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset("images/hospital.JPEG"),
            ),
            SizedBox(height: 50),
            Text(
              "Hospital Management",
              style: TextStyle(
                color: Color(0xFF3626BC),
                fontSize: 37,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your Complete Hospital Companion",
              // "Make sure Your Admission & Doctor's Appointment",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Color(0xFF3626BC),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => LoginScreen()
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 40,
                      ),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Color(0xFF3626BC),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 40,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
