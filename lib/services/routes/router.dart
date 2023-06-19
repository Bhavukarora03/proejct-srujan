import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/screens/auth/sign_in.dart';
import 'package:srujan/screens/document/documents.dart';
import 'package:srujan/screens/home/home.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: SignInPage()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});
