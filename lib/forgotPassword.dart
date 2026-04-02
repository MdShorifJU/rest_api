import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/resetPassword.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Reset via Gmail",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Username
                        _buildTextField(
                          controller: nameController,
                          hint: "Enter your username",
                          icon: Icons.person,
                        ),

                        const SizedBox(height: 15),

                        // Email
                        _buildTextField(
                          controller: emailController,
                          hint: "Enter your gmail",
                          icon: Icons.email,
                        ),

                        const SizedBox(height: 25),

                        // Send OTP button
                          _buildButton("Send OTP", () async {
                            String result = await forgotMethod(
                              nameController.text,
                              emailController.text,
                            );

                          if (result.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("OTP sent to email"),
                              ),
                            );
                            otpCode = result;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Enter valid info or try later"),
                              ),
                            );
                          }
                        }),

                        const SizedBox(height: 25),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter OTP",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        _buildTextField(
                          controller: confirmController,
                          hint: "4 digit OTP",
                          icon: Icons.lock,
                        ),

                        const SizedBox(height: 25),

                        // Verify button
                        _buildButton("Verify & Continue", () {
                          if (confirmController.text == otpCode) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invalid OTP"),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 🔹 Reusable Button
  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4facfe),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // 🔹 API CALL (unchanged logic)
  Future<String> forgotMethod(String name, String email) async {
    String url = "https://dhakashopping.xyz/forgot.php";

    final Map<String, dynamic> queryParams = {
      "name": name,
      "email": email
    };

    try {
      var response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParams),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"] == "success") {
          return data["otp"];
        } else {
          return "";
        }
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }
}


/*

<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$db = "dhakasho_UserInfoFlutter";
$userName = "dhakasho_user";
$dbPassword = "Bq5#Zp8!Lm2@Ks7";

$name = $_GET['name'] ?? "";
$email = $_GET['email'] ?? "";

$conn = new mysqli($host, $userName, $dbPassword, $db);

if ($conn->connect_error) {
    echo json_encode(["status"=>"fail","message"=>"DB error"]);
    exit;
}

// ✅ username + email match check
$sql = "SELECT * FROM users WHERE name='$name' AND email='$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {

    // ✅ 4 digit OTP
    $otp = rand(1000, 9999);

    // ================= EMAIL SEND (simple mail) =================
    $subject = "Your OTP Code";
    $message = "Your OTP is: $otp";
    $headers = "From: iitdepartmentofju340@gmail.com";

    mail($email, $subject, $message, $headers);

    // ================= RESPONSE =================
    echo json_encode([
        "status" => "success",
        "otp" => $otp,
        "message" => "OTP sent to email"
    ]);

} else {
    echo json_encode([
        "status" => "fail",
        "message" => "Username or Email not matched"
    ]);
}

$conn->close();
?>

 */