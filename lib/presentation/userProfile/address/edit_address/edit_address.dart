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
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Description',
                              style: 16.sp(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: _textFormField(
                                  notifier.imageDescCtrl, 'Image-Description'))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 15, 15),
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(0.2),
                              1: FlexColumnWidth(0.78),
                            },
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Label',
                                    style: 16.sp(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: _textFormField2(
                                      notifier.labelCtrl, 'Label'),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    'Street',
                                    style: 16.sp(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: _textFormField(
                                      notifier.streetCtrl, 'Street'),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    'City',
                                    style: 16.sp(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child:
                                      _textFormField(notifier.cityCtrl, 'City'),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'State',
                                    style: 16.sp(),
                                  ),
                                ),
                                _textFormField(notifier.stateCtrl, 'State')
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 19),
                                  child: Text(
                                    'Country',
                                    style: 16.sp(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: _textFormField(
                                      notifier.countryCtrl, 'Country'),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    'Postal',
                                    style: 16.sp(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: _textFormField(
                                      notifier.postalCtrl, 'Postal'),
                                )
                              ])
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(180, 35),
                              side: BorderSide(color: Colors.blue),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () {},
                          child: Text(
                            'UPDATE',
                            style: 17.sp(color: Colors.white),
                          )),
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

Widget _textFormField(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    style: 16.sp(),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      isDense: true,
      hintText: hint,
      hintStyle: 13.sp(color: Colors.grey),
      errorStyle: 12.sp(color: Colors.red),
      enabled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      errorBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    ),
  );
}

Widget _textFormField2(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    style: 16.sp(),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      hintText: hint,
      hintStyle: 13.sp(color: Colors.grey),
      errorStyle: 12.sp(color: Colors.red),
      enabled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
    ),
  );
}
