import 'package:darttonconnect/models/wallet_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TonOpenWalletWidget extends StatefulWidget {
  final List<WalletApp> wallets;
  final Function onTap;
  final WalletApp? telegramWallet;
  final Widget? qrCode;
  final String title;
  final String description;

  const TonOpenWalletWidget(
      {required this.wallets,
      required this.onTap,
      this.telegramWallet,
      this.title = 'Connect your wallet',
      this.description =
          'Open Wallet on Telegram or select your wallet to connect',
      this.qrCode,
      super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TonOpenWalletWidget> {
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
            child: showQR ? _qrContainer() : _initial()),
        _tonConnect()
      ]),
    );
  }

  Widget _qrContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        Center(child: widget.qrCode!),
      ],
    );
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      mainAxisAlignment: (widget.qrCode != null)
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (widget.qrCode != null)
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              radius: 12,
              child: Icon(
                showQR ? Icons.arrow_back : Icons.qr_code,
                size: 14,
              ),
            ),
            onPressed: () {
              setState(() {
                showQR = !showQR;
              });
            },
          ),
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
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
