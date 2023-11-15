import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

///Main Widgets
class MainWidgets {
  //Context
  final BuildContext context;

  ///Initialize MainWidgets
  MainWidgets({required this.context});

  ///AppBar
  PreferredSizeWidget appBar({
    Widget? title,
    bool? allowBack = true,
    bool? centerTitle = true,
    Widget? leading,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) {
    //Default Leading
    final defaultLeading = IconButton(
      onPressed: onBack ?? () => Navigator.pop(context),
      icon: const Icon(Ionicons.ios_chevron_back),
    );

    //Leading Widget
    final finalLeading = leading ?? (allowBack ?? true ? defaultLeading : null);

    //AppBar
    return AppBar(
      title: title,
      automaticallyImplyLeading: allowBack ?? true,
      leading: finalLeading,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  ///Page Title
  Widget pageTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24.0, letterSpacing: 1.2),
      ),
    );
  }
}
