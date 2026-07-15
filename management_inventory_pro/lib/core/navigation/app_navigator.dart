import 'package:flutter/widgets.dart';

/// App-wide navigator key.
///
/// Deep links can arrive at any time — including while the user is deep
/// inside Home with no relation to auth on screen. Reacting to that needs
/// navigation that isn't scoped to any particular widget's [BuildContext],
/// which is exactly what a root-level [GlobalKey<NavigatorState>] gives us.
///
/// Wire this into your root `MaterialApp(navigatorKey: rootNavigatorKey)`.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
