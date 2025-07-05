import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';

class EditAddress extends StatelessWidget {
  const EditAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressNotifier>(
      builder: (context, notifier, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFFB8CFCE), borderRadius: BorderRadius.circular(8)),
          child: DraggableScrollableSheet(
            shouldCloseOnMinExtent: false,
            expand: false,
            initialChildSize: 0.8,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        width: 180,
                        decoration: BoxDecoration(
                            image: notifier.picked != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(notifier.imageUrl!)))
                                : notifier.editAddress!.addressImage.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(notifier
                                            .editAddress!
                                            .addressImage
                                            .first
                                            .url),
                                        fit: BoxFit.cover)
                                    : null,
                            color: Color(0xFF7F8CAA),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(80, 35),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                notifier.onPick(ImageSource.gallery);
                              },
                              child: Text(
                                'Gallery',
                                style: 14.sp(color: Colors.white),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(80, 35),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                notifier.onPick(ImageSource.camera);
                              },
                              child: Text(
                                'Camera',
                                style: 14.sp(color: Colors.white),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
