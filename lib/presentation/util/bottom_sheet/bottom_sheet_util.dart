import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/widget/dialog/multi_button_dialog_item_widget.dart';

void showTwoButtonBottomSheetCupertino({
  required BuildContext context,
  String? title,
  /// First button
  required IconData firstButtonIcon,
  required String firstButtonText,
  required Function() firstButtonListener,
  /// Second button
  IconData? secondButtonIcon,
  String? secondButtonText,
  Function()? secondButtonListener,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ],
                  ),

                  /// Title
                  if (title != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, top: 8, bottom: 8),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),

                  /// First button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      firstButtonListener();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(firstButtonIcon),
                          const SizedBox(width: 12),
                          Text(
                            firstButtonText,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  /// Second button
                  if (secondButtonText != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (secondButtonListener != null) secondButtonListener();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 44,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(secondButtonIcon),
                            const SizedBox(width: 12),
                            Text(
                              secondButtonText,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showMultiButtonBottomSheetCupertino({
  required BuildContext context,
  String? title,
  required List<MultiButtonDialogItemWidget> buttons,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ],
                  ),

                  /// Title
                  if (title != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, top: 8, bottom: 8),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: buttons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buttons[index];
                    }
                  ),

                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
