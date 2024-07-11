import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../auth/authorization/model/i_user.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';

class UserDrawer extends StatelessWidget {
  final IUser? user;

  const UserDrawer({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? 'Guest'),
              accountEmail: Text(user?.email ?? 'guest@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user != null
                    ? NetworkImage(user!.imageUrl)
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
            ),
            SizedBox(
              height: Adaptive.h(65),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
