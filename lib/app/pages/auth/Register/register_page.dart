import 'package:campaign_coffee/app/pages/auth/Register/controller/register_controller.dart';
import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'PoppinsSemiBold',
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(8, 76, 172, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Create an account so you can explore all the existing jobs',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),

                // Form Fields
                _buildTextField(
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                  controller: registerController.usernameController,
                ),
                Obx(() => registerController.usernameError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        child: Text(
                          registerController.usernameError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),

                _buildTextField(
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  controller: registerController.emailController,
                ),
                Obx(() => registerController.emailError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        child: Text(
                          registerController.emailError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),

                _buildTextField(
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: registerController.passwordController,
                ),
                Obx(() => registerController.passwordError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        child: Text(
                          registerController.passwordError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),

                _buildTextField(
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: registerController.confirmPasswordController,
                ),
                Obx(() => registerController
                        .confirmPasswordError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        child: Text(
                          registerController.confirmPasswordError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),

                _buildTextField(
                  hintText: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  controller: registerController.phoneController,
                ),
                Obx(() => registerController.phoneError.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        child: Text(
                          registerController.phoneError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 60),

                // Next Button
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: registerController.isLoading.value
                          ? null
                          : () {
                              registerController.register();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(8, 76, 172, 1),
                        elevation: 20,
                        shadowColor: const Color.fromRGBO(8, 76, 172, 1)
                            .withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: registerController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Already have an account
                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.login),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color.fromRGBO(8, 76, 172, 1),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color.fromRGBO(8, 76, 172, 1),
            size: 22,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromRGBO(8, 76, 172, 1),
              width: 1.5,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
