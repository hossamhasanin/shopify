import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopify/widgets/profile/components/defualt_pic.dart';

class ProfilePic extends StatelessWidget {
  final String image;
  final String name;
  final File? pickedImage;
  final bool uploading;

  final Function(File image) uploadImage;

  const ProfilePic(
      {required this.image,
      required this.name,
      required this.uploading,
      required this.uploadImage,
      this.pickedImage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          uploading ? CircularProgressIndicator() : SizedBox(),
          image == "none"
              ? DefualtPic(name: name)
              : uploading
                  ? CircleAvatar(
                      backgroundImage: FileImage(pickedImage!),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(image),
                    ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  var pickImage = await chooseFile();

                  if (pickImage != null) {
                    File image = File(pickImage.path);

                    uploadImage(image);
                  }
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<PickedFile?> chooseFile() async {
    var picker = ImagePicker();
    PickedFile? image = await picker.getImage(source: ImageSource.gallery);
    return Future.value(image);
  }
}
