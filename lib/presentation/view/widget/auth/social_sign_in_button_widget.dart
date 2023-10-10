import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialSignInButtonWidget extends StatelessWidget {
  const SocialSignInButtonWidget({Key? key, required this.title, required this.image, required this.listener}) : super(key: key);

  final String title;
  final String image;
  final Function listener;

  @override
  Widget build(BuildContext context) {
    const double padding = 20;
    return Container(
      margin: const EdgeInsets.only(left: padding, right: padding, bottom: padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: InkWell(
        /// Click listener
        onTap: () {
          listener();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              /// Logo image
              SvgPicture.asset(
                width: 30,
                image,
              ),
              const SizedBox(width: 10),
              /// Title
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
