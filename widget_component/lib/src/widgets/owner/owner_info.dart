import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class InfoOwner extends StatefulWidget {
  final UserModel user;
  final SellerModel seller;
  final AddressModel address;
  final bool? isFavorite;
  final VoidCallback? opTap;
  const InfoOwner(
      {super.key,
      required this.user,
      required this.seller,
      required this.address,
      this.isFavorite,
      this.opTap});

  @override
  State<InfoOwner> createState() => _InfoOwnerState();
}

class _InfoOwnerState extends State<InfoOwner> {
  late bool? _isFavorite;
  final _logger = Logger();
  @override
  initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _logger.i(_isFavorite, error: '_isFavorite');
  }

  @override
  void didUpdateWidget(InfoOwner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        _isFavorite = widget.isFavorite;
      });
    }
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.user.name ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const LineIcon.envelope(),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.user.email ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            const LineIcon.mobilePhone(),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.user.phone ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.mapMarker(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.address.address ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.clock(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                '${widget.seller.startTime} - ${widget.seller.endTime}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyImage(
                  width: double.infinity,
                  height: 150,
                  src: widget.user.avatar ?? "",
                  radius: 12,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextField(),
              ],
            ),
            _isFavorite != null
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.opTap!();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: _isFavorite == true
                            ? const LineIcon.heartAlt(color: Colors.red)
                            : const LineIcon.heart(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
