import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FormAddField extends StatefulWidget {
  const FormAddField({Key? key}) : super(key: key);

  @override
  State<FormAddField> createState() => _FormAddFieldState();
}

class _FormAddFieldState extends State<FormAddField> {
  final _logger = Logger();
  late bool isUpdate = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final GetStorage _box = GetStorage();
  late String _userID;
  late String? _fieldID;
  late FieldService _fieldService;
  final ApiConfig _apiConfig = ApiConfig();

  final TextStyle _labelStyle = const TextStyle();
  late Map<String, dynamic> _initValue = {
    'name': '',
    'type': '',
    'width': '',
    'length': '',
    'price': '',
    'description': '',
    'coverImage': '',
    'isLock': false,
    'isRepair': false,
  };
  bool _loadingSelectCover = false;
  String _coverUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fieldID = Get.parameters['fieldID'];
    _userID = _box.read('id');
    _fieldService = FieldService(_apiConfig.dio);
    if (_fieldID != null) {
      _getFieldUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getFieldUpdate() async {
    try {
      if (!mounted) return;
      setState(() {
        _loadingSelectCover = true;
        _isLoading = true;
      });
      final Response response = await _fieldService.getOneSoccerField(
        fieldID: _fieldID!,
      );
      debugPrint(response.toString());

      if (response.statusCode == 200) {
        final data = response.data;
        _initValue = {
          'name': data['name'],
          'type': data['type'].toString(),
          'width': FormatUtil.formatNumber(data['width']).toString(),
          'length': FormatUtil.formatNumber(data['length']).toString(),
          'price': FormatUtil.formatNumber(data['price']).toString(),
          'description': data['description'],
          'coverImage': data['coverImage'],
          'isLock': data['isLock'],
          'isRepair': data['isRepair'],
        };
        _formKey.currentState?.fields['name']
            ?.didChange(data['name'].toString());
        _formKey.currentState?.fields['type']
            ?.didChange(data['type'].toString());
        _formKey.currentState?.fields['width']
            ?.didChange(FormatUtil.formatNumber(data['width']).toString());
        _formKey.currentState?.fields['length']
            ?.didChange(FormatUtil.formatNumber(data['length']).toString());
        _formKey.currentState?.fields['price']
            ?.didChange(FormatUtil.formatNumber(data['price']).toString());
        _formKey.currentState?.fields['description']
            ?.didChange(data['description'].toString());
        _formKey.currentState?.fields['coverImage']
            ?.didChange(data['coverImage']);

        _coverUrl = data['coverImage'];
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getFieldUpdate',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      debugPrint('ERROR GET FIELD UPDATE: ${e.toString()}');
    }
    setState(() {
      _isLoading = false;
      _loadingSelectCover = false;
    });
  }

  Future<void> _selectImage() async {
    try {
      if (!mounted) return;
      setState(() {
        _loadingSelectCover = true;
      });
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        String? coverUrl = await UploadImageService()
            .uploadImage(file: file, folder: 'cover_field');
        _formKey.currentState!.fields['coverImage']!.didChange(coverUrl);
        setState(() {
          _coverUrl = coverUrl!;
          _loadingSelectCover = false;
        });
      } else {
        setState(() {
          _loadingSelectCover = false;
        });
      }
    } catch (e) {
      setState(() {
        _loadingSelectCover = false;
      });
      debugPrint('ERROR: ${e.toString()}');
      SnackbarUtil.getSnackBar(
          title: 'Upload cover image',
          message: 'Upload error. Please try again.');
    }
  }

  Future<void> _handleAddField() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.saveAndValidate();
      FocusScope.of(context).unfocus();
      final Map<String, dynamic> data = _formKey.currentState!.value;
      final Map<String, dynamic> errors = _formKey.currentState!.errors;

      if (errors.isNotEmpty) return;

      final num price = num.parse(data['price'].split(',').join(''));
      final num width = num.parse(data['width'].split(',').join(''));
      final num length = num.parse(data['length'].split(',').join(''));
      final num type = num.parse(data['type']);
      final String name = data['name'];
      final bool isLock = data['isLock'];
      final bool isRepair = data['isRepair'];
      final String description = data['description'];
      final String coverImage = data['coverImage'];

      debugPrint('price: $price');
      debugPrint('width: $width');
      debugPrint('length: $length');
      debugPrint('type: $type');
      debugPrint('name: $name');
      debugPrint('isLock: $isLock');
      debugPrint('isRepair: $isRepair');
      debugPrint('description: $description');
      debugPrint('coverImage: $coverImage');
      final Response response = await _fieldService.addSoccerField(
          userID: _box.read('id'),
          price: price,
          width: width,
          length: length,
          type: type,
          name: name,
          isLock: isLock,
          isRepair: isRepair,
          description: description,
          coverImage: coverImage);
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        SnackbarUtil.getSnackBar(
            title: 'Add new soccer field',
            message: 'You were added a new field successfully');
        return Get.offAndToNamed(RoutePaths.mainScreen,
            arguments: {'index': 3});
      } else {
        throw 'Cannot add a new field. Please try again.';
      }
    } catch (e) {
      _logger.e(error: e, 'Error');
      SnackbarUtil.getSnackBar(
          title: 'Add new soccer field',
          message: 'Cannot add a new field. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleUpdateField() async {
    try {
      if (!mounted && _fieldID == null) return;
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.saveAndValidate();

      FocusScope.of(context).unfocus();
      final Map<String, dynamic> data = _formKey.currentState!.value;
      final Map<String, dynamic> errors = _formKey.currentState!.errors;

      if (errors.isEmpty) {
        final num price = num.parse(data['price'].split(',').join(''));
        final num width = num.parse(data['width'].split(',').join(''));
        final num length = num.parse(data['length'].split(',').join(''));
        final num type = num.parse(data['type']);
        final String name = data['name'];
        final bool isLock = data['isLock'];
        final bool isRepair = data['isRepair'];
        final String description = data['description'];
        final String coverImage = data['coverImage'];

        debugPrint('price: $price');
        debugPrint('width: $width');
        debugPrint('length: $length');
        debugPrint('type: $type');
        debugPrint('name: $name');
        debugPrint('isLock: $isLock');
        debugPrint('isRepair: $isRepair');
        debugPrint('description: $description');
        debugPrint('coverImage: $coverImage');
        final result = await _fieldService.updateSoccerField(
            userID: _box.read('id'),
            fieldID: _fieldID ?? '',
            price: price,
            width: width,
            length: length,
            type: type,
            name: name,
            isLock: isLock,
            isRepair: isRepair,
            description: description,
            coverImage: coverImage);
        _logger.i(result.toString());
        if (result != null) {
          SnackbarUtil.getSnackBar(
              title: "Update field", message: "Update field successfully");
          return;
        } else {
          throw 'Cannot add a new field. Please try again.';
        }
      }
    } catch (e) {
      _logger.e(error: e, 'Error update field');
      SnackbarUtil.getSnackBar(
          title: 'Add new soccer field',
          message: 'Cannot add a new field. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContentCoverContainer() {
    if (_loadingSelectCover == true) {
      return const Center(
        child: CircularProgressIndicator(
          color: MyColor.primary,
        ),
      );
    }
    if (_coverUrl.isNotEmpty) {
      return MyImage(
          width: double.infinity, height: double.infinity, src: _coverUrl);
    }
    return const LineIcon.camera();
  }

  Widget _buildFieldCoverImage() {
    return FormBuilderField(
      name: 'coverImage',
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      focusNode: FocusNode(),
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: field.errorText ?? '',
            border: InputBorder.none,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _loadingSelectCover ? null : _selectImage();
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 180,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildContentCoverContainer(),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cover image',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Text('File format: PNG/JPEG'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  FormBuilderTextField _buildFieldName() {
    return FormBuilderTextField(
      name: 'name',
      decoration: InputDecoration(
        label: const Text('Field name'),
        prefixIcon: const LineIcon.futbol(),
        labelStyle: _labelStyle,
      ),
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(2),
          FormBuilderValidators.maxLength(20)
        ],
      ),
    );
  }

  FormBuilderTextField _buildFieldType() {
    return FormBuilderTextField(
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.max(11),
        FormBuilderValidators.min(5),
      ]),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Field type',
        labelStyle: _labelStyle,
        hintText: 'Value from 5 to 11',
        prefixIcon: const LineIcon.tag(),
        suffixText: 'persons',
        hintStyle: const TextStyle(fontSize: 14),
      ),
      name: 'type',
    );
  }

  Widget _buildWidthLengthFields() {
    return Row(
      children: [
        Expanded(
          child: FormBuilderTextField(
            name: 'width',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FormatUtil.numberFormatter(),
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            decoration: InputDecoration(
              label: const Text('Width'),
              prefixIcon: const LineIcon.alternateArrowsHorizontal(),
              suffixText: 'm',
              labelStyle: _labelStyle,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: FormBuilderTextField(
            name: 'length',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FormatUtil.numberFormatter(),
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            decoration: InputDecoration(
              label: const Text('Length'),
              prefixIcon: const LineIcon.alternateArrowsVertical(),
              suffixText: 'm',
              labelStyle: _labelStyle,
            ),
          ),
        ),
      ],
    );
  }

  FormBuilderSwitch _buildFieldIsRepair() {
    return FormBuilderSwitch(
      activeColor: MyColor.primary,
      decoration: const InputDecoration(border: InputBorder.none),
      name: 'isRepair',
      title: const Text(
        'Repair',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  FormBuilderSwitch _buildFieldIsLock() {
    return FormBuilderSwitch(
      activeColor: MyColor.primary,
      subtitle: const Text('This field will not show for everyone'),
      name: 'isLock',
      title: const Text(
        'Lock',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  FormBuilderTextField _buildFieldPrice() {
    return FormBuilderTextField(
      name: 'price',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FormatUtil.numberFormatter(),
      ],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      decoration: InputDecoration(
        label: const Text('Price'),
        prefixIcon: const LineIcon.moneyBill(),
        suffixText: ' VND',
        hintText: 'Price per hour',
        labelStyle: _labelStyle,
      ),
    );
  }

  Widget _buildDescriptionField() {
    return FormBuilderTextField(
      name: 'description',
      maxLines: 4,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelStyle: _labelStyle,
        label: const Text('Description'),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: MyColor.primary),
      onPressed: () {
        if (_loadingSelectCover || _isLoading) return;
        _fieldID != null ? _handleUpdateField() : _handleAddField();
      },
      child: Center(
          child: _isLoading
              ? MyLoading.spinkit()
              : Text(
                  _fieldID != null ? 'Save' : 'Add',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: _initValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _isLoading
          ? Center(
              child: MyLoading.spinkit(size: 50),
            )
          : Column(
              children: [
                _buildFieldCoverImage(),
                const SizedBox(height: 10),
                _buildFieldName(),
                const SizedBox(height: 10),
                _buildFieldType(),
                const SizedBox(height: 10),
                _buildWidthLengthFields(),
                const SizedBox(height: 10),
                _buildFieldPrice(),
                const SizedBox(height: 10),
                _buildFieldIsLock(),
                const SizedBox(height: 10),
                _buildFieldIsRepair(),
                const SizedBox(height: 10),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                _buildAddButton(),
              ],
            ),
    );
  }
}
