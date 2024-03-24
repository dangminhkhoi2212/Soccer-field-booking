import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});
  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _feedbackService = FeedbackService();
  final _logger = Logger();
  int _lengthContent = 0;
  String? _userID;
  final _box = GetStorage();
  late String? _orderID;
  OrderModel? _order;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderID = Get.parameters['orderID']!;
    _userID = _box.read('id');
    _getOrder();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response? response = await OrderService()
          .getOneOrder(orderID: _orderID!, userID: _userID!);
      if (response!.statusCode == 200) {
        _order = OrderModel.fromJson(response.data);
      }
    } catch (e) {
      _logger.e(error: e, '_getOrder');
    }
    setState(() {
      _isLoading = false;
    });
  }

  TableRow _buildTableRow({required String label, required String value}) {
    return TableRow(children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    ]);
  }

  Widget _buildInfoField() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: MyImage(
                width: double.infinity,
                height: 100,
                src: _order!.field!.coverImage!,
                radius: 12,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 3,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  _buildTableRow(
                      label: 'Field name', value: _order!.field!.name!),
                  _buildTableRow(
                      label: 'Owner name', value: _order!.seller!.name!),
                  _buildTableRow(
                      label: 'Ordered date',
                      value: FormatUtil.formatISOtoDate(_order!.date!)),
                  _buildTableRow(
                    label: 'Ordered time',
                    value:
                        '${FormatUtil.formatISOtoTime(_order!.startTime!)} - ${FormatUtil.formatISOtoTime(_order!.endTime!)}',
                  ),
                  _buildTableRow(
                    label: 'Total date',
                    value: FormatUtil.formatNumber(_order!.total!) + ' VND',
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildStar() {
    return Container(
      width: ScreenUtil.getWidth(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: FormBuilderField(
        name: 'star',
        initialValue: 5,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        builder: (FormFieldState field) => InputDecorator(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            labelText: 'Quality of this field',
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            enabledBorder: InputBorder.none,
          ),
          child: RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.zero,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              field.didChange(rating.toInt());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormPickPhotos() {
    return FormBuilderImagePicker(
      name: 'photos',
      maxImages: 5,
      decoration: const InputDecoration(
        labelText: 'Quality of this field',
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        enabledBorder: InputBorder.none,
      ),
      previewAutoSizeWidth: true,
      fit: BoxFit.cover,
      previewHeight: 100,
      backgroundColor: MyColor.litePrimary,
      previewMargin: const EdgeInsets.symmetric(horizontal: 5),
      loadingWidget: (context) {
        return MyLoading.spinkit();
      },
      showDecoration: true,
      validator: FormBuilderValidators.compose(
        [FormBuilderValidators.maxLength(5)],
      ),
    );
  }

  Widget _buildFormContent() {
    const int maxLengthContent = 300;
    return FormBuilderTextField(
      name: 'content',
      minLines: 4,
      maxLines: 4,
      showCursor: true,
      onChanged: (value) {
        setState(() {
          _lengthContent = value!.length;
        });
      },
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Content',
          counterText: '$_lengthContent/$maxLengthContent',
          errorMaxLines: 2,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.required(),
          FormBuilderValidators.maxLength(maxLengthContent),
        ],
      ),
    );
  }

  Future _handelSubmit() async {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Center(
          child: MyLoading.spinkit(),
        );
      },
    );
    try {
      _formKey.currentState!.saveAndValidate();
      final data = _formKey.currentState!.value;
      final error = _formKey.currentState!.errors;
      if (error.isEmpty) {
        List<dynamic>? files = data['photos'];
        int star = data['star'];
        String content = data['content'];
        List<String?> imagesUrl = [];
        if (files != null) {
          imagesUrl = await Future.wait((files.map(
            (file) => UploadImageService()
                .uploadImage(file: file, folder: 'feedback'),
          )));
        }
        _logger.i(imagesUrl.toString());
        Response? response = await _feedbackService.createFeedback(
            orderID: _orderID!,
            userID: _order!.user!.sId!,
            star: star,
            content: content.trim(),
            images: imagesUrl ?? []);
        if (response!.statusCode == 200) {
          SnackbarUtil.getSnackBar(
              title: 'Feedback',
              message: 'You have sent your feedback successfully');
          await Get.offNamed(RoutePaths.fieldBooking, parameters: {
            'fieldID': _order!.field!.sId!,
            'sellerID': _order!.seller!.sId!
          });
        }
        _logger.d(data['star']);
      } else {
        _logger.e(error: error, '_handelSubmit');
      }
    } catch (e) {
      _logger.e(error: e, '_handelSubmit');
    }
    Navigator.of(context).pop();
  }

  Widget _buildButton() {
    return ElevatedButton(
        onPressed: () {
          _handelSubmit();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.litePrimary,
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Submit',
                style: TextStyle(
                    color: MyColor.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }

  Widget _buildBody() {
    if (_orderID == null) {
      return EmptyWidget(
        hideBackgroundAnimation: true,
        packageImage: PackageImage.Image_2,
      );
    }
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(18),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Wrap(
            runSpacing: 20,
            children: [
              _buildInfoField(),
              const Divider(height: 0, thickness: 2),
              _buildStar(),
              _buildFormPickPhotos(),
              _buildFormContent(),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Feedback')),
      body: _buildBody(),
    );
  }
}
