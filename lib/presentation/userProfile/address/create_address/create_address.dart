// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:user_auth/common/helper/app_navigator.dart';
// import 'package:user_auth/core/theme/app_text_style.dart';
// import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';
// import 'package:user_auth/presentation/widgets/loading_show.dart';

// class CreateAddress extends StatelessWidget {
//   const CreateAddress({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final key = GlobalKey<FormState>();
//     return Consumer<AddressNotifier>(
//       builder: (context, provider, child) {
//         return Scaffold(
//             backgroundColor: Color(0xffB8CFCE),
//             body: provider.loading
//                 ? LoadingShow()
//                 : SingleChildScrollView(
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(left: 10, right: 10, top: 30),
//                       child: Form(
//                         key: key,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 350,
//                               width: 250,
//                               decoration: BoxDecoration(
//                                   color: Colors.teal,
//                                   border: Border.all(color: Colors.black38),
//                                   borderRadius: BorderRadius.circular(8),
//                                   image: provider.imageUrl!.isEmpty
//                                       ? null
//                                       : DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: FileImage(
//                                               File(provider.imageUrl!)))),
//                               child: provider.imageUrl!.isEmpty
//                                   ? Icon(
//                                       Icons.photo,
//                                       size: 60,
//                                     )
//                                   : null,
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor: const Color.fromARGB(
//                                             255, 240, 240, 240),
//                                         fixedSize: Size(80, 40),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 5),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         side: BorderSide(
//                                             color: Colors.tealAccent)),
//                                     onPressed: () {
//                                       provider.onPick(ImageSource.gallery);
//                                     },
//                                     child: Text(
//                                       'Gallery',
//                                       style: 12.sp(),
//                                     )),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor: const Color.fromARGB(
//                                             255, 240, 240, 240),
//                                         fixedSize: Size(80, 40),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 5),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         side: BorderSide(
//                                             color: Colors.tealAccent)),
//                                     onPressed: () {
//                                       provider.onPick(ImageSource.camera);
//                                     },
//                                     child: Text(
//                                       'Open Camear',
//                                       style: 12.sp(),
//                                     )),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 15),
//                               child: _textFormField(provider,
//                                   'Image Description', provider.imageDescCtrl),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             provider.loading
//                                 ? Card(
//                                     color: Colors.blueAccent.shade100,
//                                     child: LoadingShow(),
//                                   )
//                                 : Card(
//                                     child: Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           12, 20, 12, 20),
//                                       child: Column(
//                                         children: [
//                                           _labelTextFormField(provider,
//                                               'Title ', provider.labelCtrl),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           _textFormFieldV(provider, 'Street',
//                                               'Street', provider.streetCtrl),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: _textFormField(provider,
//                                                     'City', provider.cityCtrl),
//                                               ),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: _textFormField(
//                                                     provider,
//                                                     'State',
//                                                     provider.stateCtrl),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: _textFormFieldV(
//                                                     provider,
//                                                     'Country',
//                                                     'Country',
//                                                     provider.countryCtrl),
//                                               ),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: _textFormField2(
//                                                     provider,
//                                                     'Postal Code',
//                                                     provider.postalCtrl),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 OutlinedButton(
//                                     style: OutlinedButton.styleFrom(
//                                         backgroundColor: const Color.fromARGB(
//                                             255, 240, 240, 240),
//                                         // fixedSize: Size(80, 32),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 5),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         side: BorderSide(color: Colors.grey)),
//                                     onPressed: () {
//                                       AppNavigator.pop(context);
//                                     },
//                                     child: Text(
//                                       'Back',
//                                       style: 12.sp(),
//                                     )),
//                                 SizedBox(
//                                   width: 25,
//                                 ),
//                                 OutlinedButton(
//                                     style: OutlinedButton.styleFrom(
//                                         backgroundColor: const Color.fromARGB(
//                                             255, 240, 240, 240),
//                                         // fixedSize: Size(80, 32),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 5),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         side: BorderSide(
//                                             color: Colors.tealAccent)),
//                                     onPressed: provider.loading
//                                         ? null
//                                         : () async {
//                                             if (!key.currentState!.validate())
//                                               return;

//                                             final success =
//                                                 await provider.createAddress();

//                                             if (success) {
//                                               AppNavigator.pop(
//                                                   context, success);
//                                             } else {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           'Failed to add address')));
//                                             }
//                                           },
//                                     child: Text(
//                                       'ADD',
//                                       style: 12.sp(),
//                                     )),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ));
//       },
//     );
//   }
// }

// Widget _labelTextFormField(
//     AddressNotifier provider, String hint, TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.transparent,
//         hintText: hint,
//         hintStyle: 14.sp(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//         errorStyle: 11.sp(color: Colors.red),
//         border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black12),
//             borderRadius: BorderRadius.circular(10)),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.green),
//             borderRadius: BorderRadius.circular(10)),
//         enabled: true,
//         enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue),
//             borderRadius: BorderRadius.circular(10)),
//         errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.red),
//             borderRadius: BorderRadius.circular(10))),
//     validator: (value) {
//       if (value == null || value.isEmpty) return 'Label must not be empth';
//       return null;
//     },
//   );
// }

// Widget _textFormField(
//     AddressNotifier provider, String hint, TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.transparent,
//         hintText: hint,
//         hintStyle: 14.sp(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//         errorStyle: 11.sp(color: Colors.red),
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.black12),
//         ),
//         focusedBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
//         enabled: true,
//         enabledBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//         errorBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
//   );
// }

// Widget _textFormField2(
//     AddressNotifier provider, String hint, TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     keyboardType: TextInputType.number,
//     decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.transparent,
//         hintText: hint,
//         hintStyle: 14.sp(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//         errorStyle: 11.sp(color: Colors.red),
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.black12),
//         ),
//         focusedBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
//         enabled: true,
//         enabledBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//         errorBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
//   );
// }

// Widget _textFormFieldV(AddressNotifier provider, String hint, String label,
//     TextEditingController controller) {
//   return TextFormField(
//     controller: controller,
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.transparent,
//         hintText: hint,
//         hintStyle: 14.sp(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//         errorStyle: 11.sp(color: Colors.red),
//         border: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.black12),
//         ),
//         focusedBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
//         enabled: true,
//         enabledBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//         errorBorder:
//             UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
//     validator: (value) {
//       if (value == null || value.isEmpty) return '$label must not be empty';
//       return null;
//     },
//   );
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/theme/app_text_style.dart';
import 'package:user_auth/presentation/userProfile/address/notifier/address_notifier.dart';
import 'package:user_auth/presentation/widgets/loading_show.dart';

class CreateAddress extends StatelessWidget {
  const CreateAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Consumer<AddressNotifier>(
      builder: (context, provider, child) {
        return Scaffold(
            backgroundColor: Color(0xffB8CFCE),
            body: provider.loading
                ? LoadingShow()
                : SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 30),
                      child: Form(
                        key: key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            provider.loading
                                ? Card(
                                    color: Colors.blueAccent.shade100,
                                    child: LoadingShow(),
                                  )
                                : SizedBox(
                                    height: 10,
                                  ),
                            for (var i = 0; i < provider.count; i++)
                              _addressCard(provider, i),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 240, 240, 240),
                                        // fixedSize: Size(80, 32),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: BorderSide(color: Colors.grey)),
                                    onPressed: () {
                                      AppNavigator.pop(context);
                                    },
                                    child: Text(
                                      'Back',
                                      style: 12.sp(),
                                    )),
                                SizedBox(
                                  width: 25,
                                ),
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 240, 240, 240),
                                        // fixedSize: Size(80, 32),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: BorderSide(
                                            color: Colors.tealAccent)),
                                    onPressed: provider.loading
                                        ? null
                                        : () async {
                                            if (!key.currentState!.validate())
                                              return;

                                            final success =
                                                await provider.createMany();

                                            if (success) {
                                              AppNavigator.pop(
                                                  context, success);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Failed to add address')));
                                            }
                                          },
                                    child: Text(
                                      'ADD',
                                      style: 12.sp(),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
      },
    );
  }
}

Widget _addressCard(AddressNotifier provider, int i) {
  final prev = i < provider.count - 1;
  final last = i == provider.count - 1;

  bool hasImage =
      provider.imageUrlList[i] != null && provider.imageUrlList[i]!.isNotEmpty;

  DecorationImage? bg;

  hasImage
      ? bg = DecorationImage(
          image: FileImage(File(provider.imageUrlList[i]!)), fit: BoxFit.cover)
      : null;

  return Column(
    children: [
      Container(
        width: 230,
        height: 250,
        decoration: BoxDecoration(
            image: bg,
            color: Color(0xff333446),
            borderRadius: BorderRadius.circular(8)),
        child: bg == null
            ? Icon(
                Icons.photo,
                size: 35,
                color: Colors.white,
              )
            : null,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // fixedSize: Size(width, height)
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.transparent),
              onPressed: () {
                provider.onPick(ImageSource.gallery, i);
              },
              child: Text(
                'Gallery',
                style: 15.sp(color: Colors.white),
              )),
          SizedBox(
            width: 25,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // fixedSize: Size(width, height)
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.transparent),
              onPressed: () {
                provider.onPick(ImageSource.camera, i);
              },
              child: Text(
                'Camera',
                style: 15.sp(color: Colors.white),
              ))
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _textFormField(
            provider, 'Image-Description', provider.imageDesc[i]),
      ),
      SizedBox(
        height: 15,
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            children: [
              _labelTextFormField(provider, 'Title ', provider.label[i]),
              SizedBox(
                height: 10,
              ),
              _textFormFieldV(provider, 'Street', 'Street', provider.street[i]),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: _textFormField(provider, 'City', provider.city[i]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _textFormField(provider, 'State', provider.state[i]),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: _textFormFieldV(
                        provider, 'Country', 'Country', provider.country[i]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _textFormField2(
                        provider, 'Postal Code', provider.postal[i]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Center(
          child: provider.count == 1
              ? Center(
                  child: IconButton(
                      onPressed: () {
                        provider.callNew();
                      },
                      icon: Icon(Icons.add)),
                )
              : last
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              provider.undo();
                            },
                            icon: Icon(Icons.remove)),
                        IconButton(
                            onPressed: () {
                              provider.callNew();
                            },
                            icon: Icon(Icons.add))
                      ],
                    )
                  : SizedBox.shrink()),
      prev
          ? SizedBox(
              height: 30,
            )
          : SizedBox.shrink()
    ],
  );
}

Widget _labelTextFormField(
    AddressNotifier provider, String hint, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        errorStyle: 11.sp(color: Colors.red),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10)),
        enabled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10))),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Label must not be empty';
      return null;
    },
  );
}

Widget _textFormField(
    AddressNotifier provider, String hint, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        errorStyle: 11.sp(color: Colors.red),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabled: true,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
  );
}

Widget _textFormField2(
    AddressNotifier provider, String hint, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        errorStyle: 11.sp(color: Colors.red),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabled: true,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
  );
}

Widget _textFormFieldV(AddressNotifier provider, String hint, String label,
    TextEditingController controller) {
  return TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        errorStyle: 11.sp(color: Colors.red),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabled: true,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red))),
    validator: (value) {
      if (value == null || value.isEmpty) return '$label must not be empty';
      return null;
    },
  );
}
