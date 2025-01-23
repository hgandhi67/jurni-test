import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jurni_test/utils/size_utils.dart';
import 'package:jurni_test/utils/theme_helper.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? labelText;
  final bool? isTitleField;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final double? borderRadius;
  final double? textFieldHeight;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Color? borderColor;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormats;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final EdgeInsets? contentPadding;
  final EdgeInsets? padding;
  final bool? readOnly;
  final bool? canReadOnly;
  final bool? obscureText;
  final bool? isRequired;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function? onClick;
  final Function(String?)? onChange;
  final Function(String?)? onEditingComplete;
  final Function(void)? changeScrollController;
  final bool? isFilled;
  final Color? fillColor;

  const CustomTextField(
      {Key? key,
      this.title,
      this.isTitleField,
      this.textEditingController,
      this.focusNode,
      this.titleStyle,
      this.hintStyle,
      this.textStyle,
      this.borderRadius,
      this.borderColor,
      this.validator,
      this.hintText,
      this.labelText,
      this.labelStyle,
      this.textFieldHeight,
      this.maxLines,
      this.isFilled,
      this.minLines,
      this.maxLength,
      this.textInputAction,
      this.textInputType,
      this.textCapitalization,
      this.contentPadding,
      this.padding,
      this.readOnly,
      this.canReadOnly,
      this.obscureText,
      this.isRequired,
      this.suffixIcon,
      this.inputFormats,
      this.onClick,
      this.onChange,
      this.prefixIcon,
      this.changeScrollController,
      this.onEditingComplete,
      this.fillColor})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 5.fSize),
                child: Text(
                  widget.labelText ?? '',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontSize: AppFontSizes.subHeadingFontSize, color: appTheme.primaryBlack),
                ),
              )
            : Container(),
        Padding(
          padding: widget.padding ?? const EdgeInsets.all(0),
          child: SizedBox(
            height: widget.textFieldHeight,
            child: InkWell(
              onTap: () {
                if ((widget.readOnly ?? false) && widget.onClick != null) {
                  widget.onClick!();
                }
              },
              focusColor: appTheme.transparentColor,
              child: TextFormField(
                controller: widget.textEditingController,
                focusNode: widget.focusNode,
                validator: widget.validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: widget.onChange,
                cursorColor: appTheme.primaryColor,
                obscureText: widget.obscureText ?? false,
                style: widget.textStyle ??
                    theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: AppFontSizes.bodyFontSize, color: appTheme.primaryBlack),
                onTap: () {
                  if (widget.changeScrollController != null) {
                    widget.changeScrollController!(true);
                  }
                },
                onFieldSubmitted: (value) {
                  if (widget.onEditingComplete != null) {
                    widget.onEditingComplete!(value);
                  }
                },
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  isDense: true,
                  contentPadding: widget.contentPadding ??
                      EdgeInsets.only(
                        left: 15.fSize,
                        right: 15.fSize,
                        top: 15.fSize,
                        bottom: 15.fSize,
                      ),
                  hintText: widget.hintText,
                  enabled: !(widget.readOnly ?? false),
                  hintStyle: widget.hintStyle ??
                      theme.textTheme.bodyMedium
                          ?.copyWith(fontSize: AppFontSizes.bodyFontSize, color: appTheme.darkGrey),
                  labelStyle: widget.hintStyle ??
                      theme.textTheme.bodyMedium
                          ?.copyWith(fontSize: AppFontSizes.bodyFontSize, color: appTheme.darkGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                      borderSide: BorderSide(color: appTheme.redColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                      borderSide: BorderSide(color: widget.borderColor ?? appTheme.mediumGrey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                      borderSide: BorderSide(color: widget.borderColor ?? appTheme.mediumGrey)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                      borderSide: BorderSide(color: widget.borderColor ?? appTheme.mediumGrey)),
                  counterText: "",
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.fSize),
                      borderSide: BorderSide(color: appTheme.redColor)),
                  errorStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: AppFontSizes.bodySmallFontSize, height: 1, color: appTheme.redColor),
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                  filled: widget.isFilled ?? true,

                  fillColor: widget.fillColor ??
                      ((widget.canReadOnly ?? false) ? appTheme.mediumGrey : appTheme.lighterGrey),
                ),
                maxLength: widget.maxLength,
                textInputAction: widget.textInputAction ?? TextInputAction.next,
                keyboardType: widget.textInputType ?? TextInputType.text,
                textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
                maxLines: widget.maxLines ?? 1,
                minLines: widget.minLines,
                inputFormatters: widget.inputFormats,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
