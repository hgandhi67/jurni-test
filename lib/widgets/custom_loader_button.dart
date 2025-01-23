import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jurni_test/utils/size_utils.dart';
import 'package:jurni_test/utils/theme_helper.dart';

/// Common button widget which provides the button with a loader
class CustomLoadingButton extends StatelessWidget {
  final Function? onPressed;
  final String title;
  final BuildContext context;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? isBusy;
  final double? width;
  final double? height;
  final double? loaderSize;
  final Color? loaderColor;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final bool? isEnable;
  final double? borderRadius;

  const CustomLoadingButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.context,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.isBusy,
    this.width,
    this.height,
    this.loaderSize,
    this.loaderColor,
    this.focusNode,
    this.prefixIcon,
    this.isEnable,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 50.fSize,
      child: TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? appTheme.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 15)),
          )),
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? appTheme.primaryColor,
          ),
        ),
        focusNode: focusNode,
        onPressed: !(isBusy ?? false)
            ? () {
                onPressed!();
              }
            : null,
        child: (isBusy ?? false)
            ? SpinKitThreeBounce(
                size: loaderSize ?? 40.fSize,
                color: loaderColor ?? appTheme.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefixIcon ?? Container(),
                  Text(
                    title,
                    style: textStyle ??
                        theme.textTheme.titleMedium
                            ?.copyWith(fontSize: AppFontSizes.subHeadingFontSize, color: appTheme.white),
                  ),
                ],
              ),
      ),
    );
  }
}
