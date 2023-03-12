import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternalSnackbar {
 static void showSnackbar(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    showFlash(
      context: context,
      builder: (context, controller) => Flash(
        controller: controller,
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        brightness: Brightness.dark,
        enableVerticalDrag: true,
        useSafeArea: true,
        margin: const EdgeInsets.all(20).copyWith(top: kToolbarHeight),
        backgroundColor: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(10),
        child: FlashBar(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Text(subtitle),
          primaryAction: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.dismiss(),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                CupertinoIcons.xmark_circle,
                color: CupertinoColors.darkBackgroundGray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
