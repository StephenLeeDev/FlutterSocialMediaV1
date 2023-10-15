import 'package:flutter/material.dart';

import '../../../../../data/model/dm/room/item/dm_room_model.dart';
import '../../../../util/date/date_util.dart';

class DmRoomItemWidget extends StatelessWidget {
  const DmRoomItemWidget({Key? key, required this.dmRoomModel}) : super(key: key);

  final DmRoomModel dmRoomModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO : Move to the DM room screen
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Chat partner's thumbnail
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.network(
                dmRoomModel.getPartnerThumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        /// Room's name (It's basically the chat partner's username)
                        Expanded(
                          child: Text(
                            dmRoomModel.getPartnerName,
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        /// Updated date
                        Text(
                          DateUtil().getDateString(dmRoomModel.updatedAt),
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    /// The DM room's latest message
                    Text(
                      dmRoomModel.getLatestMessage,
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
