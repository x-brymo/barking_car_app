import 'package:barking_car_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../presentation/blocs/auth/auth_event.dart';
import '../../../presentation/blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/image_cashe.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.pushReplacementNamed(context, '/login');
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(title:  Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            print("User Data: $user");

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                isLoading ? const CircularProgressIndicator() :
              Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: cacheImage(user.avatarUrl)
                      ),
                     ListTile(
                      title: Text(user.fullname),
                      subtitle: Text(user.email),
                     ),
                     ListTile(
                      title: Text(user.role),
                     ),
                     ListTile(
                      title: Text(user.phone),
                     ),
                     ListTile(
                      title: Text(user.createdAt),
                     ),
                     ListTile(
                      title: Text(user.updatedAt),
                     ),
                     ListTile(
                      title: Text(user.userId),
                     ),
                      
                    ],
                  ),
               
                  
                  CustomButton(
                      text: "Edit Profile", 
                      onPressed: () {
                       showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text("Edit Profile"),
                          content: EditProfile(users: user),
                        );
                       });
                      }),
                      const Spacer(),
                      CustomButton(
                        text: "Logout",
                        onPressed: () => _logout(context),
                        textColor: Colors.red,
                      ),
                ],
              ),
            );
          }

          return const Center(child: Text("No user data found."));
        },
      ),
    );
  }

}
class EditProfile extends StatefulWidget {
  final UserModel users;

  const EditProfile({super.key, required this.users});

  @override
  State<EditProfile > createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile > {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final phoneNameController = TextEditingController();
  final bioNameController = TextEditingController();
  final uidController = TextEditingController();
  final isblockedController = TextEditingController();
  final isvipController = TextEditingController();
  @override
  Widget build(BuildContext context) {

       return Column(
      children: [
       TextFormField(
        controller: fullNameController,
        decoration:  InputDecoration(labelText: widget.users.fullname,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
       ),
       TextFormField(
        controller: emailController,
        decoration:  InputDecoration(labelText: widget.users.email,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        readOnly: true,
       ),
       TextFormField(
        controller: roleController,
        decoration:  InputDecoration(labelText: widget.users.role,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        readOnly: true,
       ),
       TextFormField(
        controller: phoneNameController,
        decoration:  InputDecoration(labelText:widget.users.phone,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
       ),
       TextFormField(
        controller: isblockedController,
        decoration:  InputDecoration(labelText: widget.users.isblocked.toString(),
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        readOnly: true,
       ),
       TextFormField(
        controller: isvipController,
        decoration:  InputDecoration(labelText: widget.users.isvip.toString(),
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        readOnly: true,
       ),
       TextFormField(
        controller: bioNameController,
        decoration:  InputDecoration(labelText: widget.users.bio,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
       ),
       TextFormField(
        controller: uidController,
        decoration:  InputDecoration(labelText: widget.users.userId,
        enabled: true,
        enabledBorder: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        readOnly: true,
       ),
       
        CustomButton(text: "Save", onPressed: () {
          context.read<AuthBloc>().add(UpdateProfileRequested(
           userData: {
            'full_name' : fullNameController.text,
            'phone' : phoneNameController.text,
            'bio' : bioNameController.text, 
           }
          ));
        }),
      ],
    );
  }
}