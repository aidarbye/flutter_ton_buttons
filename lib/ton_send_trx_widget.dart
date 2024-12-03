import 'package:flutter/material.dart';

class TonSendTrxWidget extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final Function onOpen;
  final String title;
  final String text;
  final String openText;
  final Function? onClose;

  const TonSendTrxWidget(
      {this.title = 'Confirm the transaction in Tonkeeper',
      this.text = 'It will only take a moment',
      this.openText = 'Open wallet',
      this.bgColor,
      this.textColor,
      this.onClose,
      required this.onOpen,
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
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.apply(color: Colors.white)),
                Text(
                  openText,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
              ],
            )));
  }

  @override
  Widget buildOld(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: CircleAvatar(
                    radius: 12,
                    backgroundColor: bgColor,
                    child: Icon(
                      Icons.close,
                      color: textColor,
                      size: 14,
                    ),
                  ),
                  onPressed: () {
                    if (onClose != null) {
                      onClose!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            Center(
                child: CircularProgressIndicator(
              color: Colors.grey.withAlpha(60),
            )),
            const SizedBox(height: 16),
            Center(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.apply(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.apply(color: textColor),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onOpen();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      openText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
