import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/services/service_upload_image.dart';
import 'package:widget_component/widgets/my_image/my_image.dart';

class FormAvatar extends StatefulWidget {
  const FormAvatar({super.key});

  @override
  State<FormAvatar> createState() => _FormAvatarState();
}

class _FormAvatarState extends State<FormAvatar> {
  final _box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  final UploadImageService _uploadImageService = UploadImageService();
  String? avatar;
  XFile? _image;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    avatar = _box.read('currentAvatar') ?? _box.read('avatar');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _box.remove('currentAvatar');
    _box.remove('isAllowSave');
    super.dispose();
  }

  Future<void> uploadAvatar() async {
    try {
      if (mounted) {
        setState(() {
          _box.write('isAllowSave', false);
          _isUploading = true;
        });
      }
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        final String? imageUrl = await _uploadImageService.uploadImage(
            file: image, folder: 'avatar');
        _box.write('currentAvatar', imageUrl);
        avatar = imageUrl;
      }
      if (mounted) {
        setState(() {
          _box.write('isAllowSave', true);
          _isUploading = false;
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() {
          _box.write('isAllowSave', true);
          _isUploading = false;
        });
      }
      print('ERROR AVATAR UPLOAD: $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: _isUploading
              ? const SizedBox(
                  height: 150,
                  width: 150,
                  child: CircleAvatar(
                    child: Center(
                      child: SizedBox(
                          child: CircularProgressIndicator(
                        color: MyColor.secondary,
                      )),
                    ),
                  ),
                )
              : MyImage(
                  height: 150,
                  width: 150,
                  src: avatar.toString(),
                  isAvatar: true,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            padding: const EdgeInsets.all(10),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(MyColor.primary),
            ),
            onPressed: uploadAvatar,
            icon: const LineIcon.camera(
              size: 25,
              semanticLabel: 'camera',
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
