import 'package:darttonconnect/models/wallet_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/link.dart';

class TonConnectionPendingWidget extends StatefulWidget {
  final WalletApp wallet;
  final String universalLink;
  final Function? onPop;
  final String? description;
  final Widget? qrCode;
  final String retry;
  final String qrCodeText;
  final bool error;
  final String errorText;

  const TonConnectionPendingWidget(
      {required this.wallet,
      required this.universalLink,
      this.description,
      this.qrCode,
      this.onPop,
      this.retry = 'Retry',
      this.qrCodeText = 'Show QR Code',
      this.error = false,
      this.errorText = 'Connection declined',
      super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TonConnectionPendingWidget> {
  bool showQR = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: widget.error
                ? _error()
                : (showQR ? _qrContainer() : _initial())),
        _tonConnect()
      ]),
    );
  }

  Widget _qrContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _title(),
        Center(child: widget.qrCode!),
      ],
    );
  }

  Widget _initial() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _title(),
        const SizedBox(height: 16),
        SizedBox(
            height: 50,
            width: 50,
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).highlightColor,
            ))),
        Text(
          (widget.description != null)
              ? widget.description!
              : "Continue in ${widget.wallet.name}...",
          style: Theme.of(context).textTheme.titleSmall?.apply(
              color: Theme.of(context).hintColor, fontWeightDelta: -100),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _openButton(),
          if (widget.qrCode != null) _showQRButton()
        ]),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _error() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _title(),
        const SizedBox(height: 16),
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            height: 40,
            width: 40,
            child: const Center(
                child: Icon(
              Icons.close,
              size: 25,
              color: Colors.white,
            ))),
        Text(
          widget.errorText,
          style: Theme.of(context).textTheme.titleSmall?.apply(
              color: Theme.of(context).hintColor, fontWeightDelta: -100),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _openButton(),
          if (widget.qrCode != null) _showQRButton()
        ]),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _openButton() {
    return Link(
        target: LinkTarget.blank,
        uri: Uri.parse(widget.universalLink),
        builder: (BuildContext context, FollowLink? followLink) => InkWell(
            onTap: () {
              if (followLink != null) {
                followLink();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.all(8),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(widget.retry,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.apply(color: Colors.blue))
                ]))));
  }

  Widget _showQRButton() {
    return InkWell(
        onTap: () {
          setState(() {
            showQR = !showQR;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(
                Icons.qr_code,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 4),
              Text(widget.qrCodeText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.apply(color: Colors.blue))
            ])));
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if ((widget.onPop != null) || showQR)
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              radius: 12,
              child: const Icon(
                Icons.arrow_back,
                size: 14,
              ),
            ),
            onPressed: () {
              if (showQR) {
                setState(() {
                  showQR = !showQR;
                });
                return;
              }
              widget.onPop!();
            },
          ),
        Text(widget.wallet.name,
            style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Theme.of(context).highlightColor,
            radius: 12,
            child: const Icon(
              Icons.close,
              size: 14,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _tonConnect() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(children: [
        Container(
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'images/ton_icon.svg',
              height: 14,
              width: 14,
            )),
        const SizedBox(width: 4),
        Text(
          'TON',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.apply(fontWeightDelta: 300),
        ),
        Text(' Connect', style: Theme.of(context).textTheme.bodyMedium)
      ]),
    );
  }
}
