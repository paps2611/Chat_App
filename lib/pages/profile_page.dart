import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;
    final user = authService.currentUser;
    TextEditingController phoneController = TextEditingController();
    TextEditingController genderController = TextEditingController();

    void saveProfileDetails() async {
      // Retrieve phone number and gender from text form fields
      String phoneNumber = phoneController.text;
      String gender = genderController.text;

      try {
        // Update user's profile details
        await authService.updateProfileDetails(phoneNumber, gender);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile details updated successfully'),
          ),
        );
      } catch (e) {
        // Show error message if update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile details: $e'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Basic Details:',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(color: CupertinoColors.activeBlue),
                ),
                const SizedBox(height: 20),
                Text(
                  'Name: ${user?.displayName ?? ''}',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${user?.email ?? ''}',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 40),
                Divider(),
                const SizedBox(height: 40),
                Text(
                  'Add More Details:',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(color: CupertinoColors.activeBlue),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement logic to upload profile picture
                  },
                  child: Text('Upload Profile Picture'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController, // Connect phone controller
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: genderController, // Connect gender controller
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Enter your gender',
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: saveProfileDetails,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
}
