import 'package:darttonconnect_plus/models/wallet_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/link.dart';

class TonConnectButton extends StatelessWidget {
  TextStyle? textStyle;
  final String label;
  double? iconSize;

  TonConnectButton(
      {this.textStyle, this.label = 'Connect TON', this.iconSize, super.key});

  @override
  Widget build(BuildContext context) {
    textStyle ??=
        Theme.of(context).textTheme.bodyMedium?.apply(color: Colors.white);
    iconSize ??= 16;

    final Widget svg = SvgPicture.asset('assets/images/ton_icon.svg',
        height: iconSize, width: iconSize, package: 'flutter_ton_buttons');
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(36, 139, 218, 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          svg,
          Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                label,
                style: textStyle,
              ))
        ]));
  }
}

class TonConnectionPendingWidget extends StatefulWidget {
  final String walletName;
  final String universalLink;
  final Function? onPop;
  final String? description;
  final Widget? qrCode;
  final String retry;
  final String qrCodeText;
  final bool error;
  final String errorText;

  const TonConnectionPendingWidget(
      {required this.walletName,
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
  State<StatefulWidget> createState() => _TonConnectionPendingWState();
}

class _TonConnectionPendingWState extends State<TonConnectionPendingWidget> {
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
        _TonConnectTitle()
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
              : "Continue in ${widget.walletName}...",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.apply(color: Theme.of(context).hintColor),
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
        Text(widget.walletName, style: Theme.of(context).textTheme.titleMedium),
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
}

class TonOpenWalletWidget extends StatefulWidget {
  final List<WalletApp> wallets;
  final Function onTap;
  final WalletApp? telegramWallet;
  // final Widget? qrCode;
  final String title;
  final String description;

  const TonOpenWalletWidget(
      {required this.wallets,
      required this.onTap,
      this.telegramWallet,
      this.title = 'Connect your wallet',
      this.description =
          'Open Wallet on Telegram or select your wallet to connect',
      // this.qrCode,
      super.key});

  @override
  State<StatefulWidget> createState() => _TonOpenWalletState();
}

class _TonOpenWalletState extends State<TonOpenWalletWidget> {
  // bool showQR = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: _initial()),
        _TonConnectTitle()
      ]),
    );
  }

  // Widget _qrContainer() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _title(),
  //       Center(child: widget.qrCode!),
  //     ],
  //   );
  // }

  Widget _initial() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 16),
        Center(
          child: Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.telegramWallet != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              //_showWalletLoading(state);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const Text(
                    'Open wallet in Telegram',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.telegramWallet!.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        SizedBox(
            height: 100,
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: widget.wallets.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onTap(widget.wallets[index]);
                    },
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.wallets[index].image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(widget.wallets[index].name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  );
                })),
      ],
    );
  }

  Widget _title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(flex: 2),
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
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
}

class _TonConnectTitle extends StatelessWidget {
  const _TonConnectTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(children: [
        Container(
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/images/ton_icon.svg',
              height: 14,
              width: 14,
              package: 'flutter_ton_buttons',
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

class TonSendTrxWidget extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String title;
  final String text;
  final String openText;
  final Function? onClose;
  final String? walletName;

  const TonSendTrxWidget(
      {this.title = 'Confirm the transaction in',
      this.text = 'It will only take a moment',
      this.openText = 'Open wallet',
      this.bgColor,
      this.textColor,
      this.onClose,
      this.walletName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        radius: 12,
                        child: Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).highlightColor,
                    ))),
                Text((walletName != null) ? "${title} ${walletName}" : title,
                    style: Theme.of(context).textTheme.titleSmall),
                Text(
                  openText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
            )));
  }
}
