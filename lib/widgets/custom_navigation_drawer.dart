import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthenticationService>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: Icon(Icons.menu, size: 96),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              _clearAllPages(context);
              context.pushReplacement('/home');
            },
          ),
          ListTile(
            title: Text('Statistics'),
            leading: Icon(Icons.auto_graph),
            onTap: () {
              _clearAllPages(context);
              context.pushReplacement('/statistics');
            },
          ),
          ListTile(
            title: Text('Sets'),
            leading: Icon(Icons.rectangle_rounded),
            onTap: () {
              _clearAllPages(context);
              context.pushReplacement('/sets');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async => await _handleLogout(context, authService),
          )
        ],
      ),
    );
  }
}

void _clearAllPages(BuildContext context) {
  while (context.canPop()) {
    context.pop();
  }
}

Future<void> _handleLogout(
  BuildContext context,
  AuthenticationService authService,
) async {
  await authService.logout();
  if (context.mounted) {
    _clearAllPages(context);
    context.pushReplacement('/');
  }
}
