import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/model/user/simple/item/simple_user_info_model.dart';
import '../../../../viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';
import '../../../screen/user/user_detail_screen.dart';

class UserSimpleProfileWidget extends StatelessWidget {
  const UserSimpleProfileWidget({Key? key, required this.simpleUserInfoModel})
      : super(key: key);

  final SimpleUserInfoModel simpleUserInfoModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final currentUserEmail = GetIt.instance<CurrentUserInfoViewModel>().myEmail;

        /// If it's not the current user, move to the user detail screen
        if (currentUserEmail != simpleUserInfoModel.getEmail) {
          context.pushNamed(
            UserDetailScreen.routeName,
            queryParameters: {
              'userEmail': simpleUserInfoModel.getEmail,
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User thumbnail
            Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.network(
                simpleUserInfoModel.getThumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Username
                    Text(
                      simpleUserInfoModel.getUserName,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                    /// Status message
                    Text(
                      simpleUserInfoModel.getStatusMessage,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
