import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.sports, size: 64, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'QuickSlot',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Text(
                'Book your sports slot instantly',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              const Text(
                'Select User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...controller.users.map(
                    (user) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => controller.selectUser(
                      user['id']!,
                      user['name']!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.green),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        user['name']![0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user['name']!),
                    subtitle: Text(user['id']!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}