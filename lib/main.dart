import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'image_Controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final controller = Get.put(ImageController());
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:  [

          InkWell(
            onTap: (){
              _settingModalBottomSheet(context);
            },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Icon(
                        Icons.document_scanner,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 10),
                          child: Text(
                            'Choose file',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ),
                        // Obx(() {
                        //   return controller.imageView.isTrue
                        //       ? SizedBox(
                        //     height: 300,
                        //     width: 200,
                        //     child: Image.file(File(imageFile!.path,),
                        //     ),
                        //   )
                        //       : SizedBox();
                        // })
                      ],
                    ),
                  ],
                ),
              )),


        ],
      ),
    );
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":

      /// GALLERY IMAGE PICKER
        imageFile = (await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = (await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90))!;
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile!.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
        final bytes = Io.File(imageFile!.path).readAsBytesSync();
        controller.base64ImageStr.value = base64Encode(bytes);
        print('base64--->' + controller.base64ImageStr.value);
        controller.imageView.value = true;
      });
    } else {
      print("You have not taken image");
    }
  }
  // Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title: const Text('Gallery'),
                    onTap: () => {
                      imageSelector(context, "gallery"), Navigator.pop(context),
                    }),
                ListTile(
                  title: const Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }
}


