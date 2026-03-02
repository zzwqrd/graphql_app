import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonWidget/custom_image.dart';
import '../../../../commonWidget/custom_text.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'image': 'https://flagcdn.com/w320/gb.png',
    },
    {
      'code': 'ar',
      'name': 'العربية',
      'image': 'https://flagcdn.com/w320/sa.png',
    },
  ];

  String? _currentLanguageCode;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCurrentLanguage();
  }

  void _loadCurrentLanguage() {
    setState(() {
      _currentLanguageCode = _prefs.getString('languageCode') ?? 'en';
    });
  }

  Future<void> _changeLanguage(String code, String name) async {
    try {
      final locale = code == 'ar' ? const Locale('ar') : const Locale('en');

      await context.setLocale(locale);
      await _prefs.setString('languageCode', code);
      await _prefs.setString('languageName', name);

      setState(() {
        _currentLanguageCode = code;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('language changed to'.tr(args: [name])),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error changing language: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('language change failed'.tr()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("change language")),
        body: Padding(
          padding: EdgeInsets.only(top: 16.h, left: 16.w),
          child: _currentLanguageCode == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _languages.length,
                  itemBuilder: (BuildContext context, index) {
                    final language = _languages[index];
                    final isSelected = _currentLanguageCode == language['code'];

                    return InkWell(
                      onTap: () {
                        _changeLanguage(language['code']!, language['name']!);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 16.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: context.black.withOpacity(0.10),
                                offset: const Offset(0, 0.1),
                                blurRadius: 1.r,
                              ),
                            ],
                            color: isSelected
                                ? context.primaryColor.withOpacity(0.08)
                                : Colors.white,
                            border: isSelected
                                ? Border.all(color: context.primaryColor)
                                : Border.all(color: Colors.white),
                          ),
                          height: 56.h,
                          child: Row(
                            children: [
                              SizedBox(width: 16.w),
                              SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: language['image']!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[400]!,
                                          child: Container(
                                            width: 24.w,
                                            height: 24.h,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.language,
                                            size: 18.r,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              CustomText(
                                text: language['name']!,
                                size: 16.sp,
                                weight: FontWeight.w500,
                                color: context.textColor,
                              ),
                              const Spacer(),
                              if (isSelected)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 18.w,
                                    left: 18.w,
                                  ),
                                  child: SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CustomImage(
                                      MyAssets.icons.tickCircle.path,
                                      color: context.primaryColor,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
