import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialmediaapp/res/numbers.dart';
import 'package:socialmediaapp/utils/colors.dart';

class AppStyles {
  static late double _deviceHeight, _deviceWidth;

  /// get device width
  static get deviceWidth => _deviceWidth;

  /// get device height
  static double get deviceHeight => _deviceHeight;

  static set deviceHeight(value) {
    _deviceHeight = value;
  }

  static set deviceWidth(value) {
    _deviceWidth = value;
  }

  /// common divider
  static divider() {
    return const Divider(
      color: AppColors.greyUltraLight,
      thickness: 0.8,
    );
  }

  static final _openSans = GoogleFonts.openSans();
  static final _roboto = GoogleFonts.roboto();

  /* Gradients */
  static LinearGradient blueBackgroundGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(16, 40, 76, 1.0),
      Color.fromRGBO(16, 40, 76, 0.9),
      Color.fromRGBO(16, 40, 76, 0.8),
      Color.fromRGBO(16, 40, 76, 0.9),
      Color.fromRGBO(16, 40, 76, 1.0),
    ],
  );

  static LinearGradient cardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(116, 140, 176, 1.0),
      const Color.fromRGBO(96, 120, 156, 1.0),
      const Color.fromRGBO(66, 90, 116, 1.0),
      Color.fromRGBO(36, 60, 96, 1.0),
      Color.fromRGBO(16, 40, 76, 1.0),
    ],
  );

  /* Text styles */
  static final semiBold14 = GoogleFonts.openSans(
      color: AppColors.nameHead, fontSize: d_14, fontWeight: FontWeight.w600);
  static final regularLightGrey10 = GoogleFonts.openSans(
      color: AppColors.cardTextColor,
      fontSize: d_10,
      fontWeight: FontWeight.w400);
  static final blackSemiBold10 = GoogleFonts.openSans(
      color: AppColors.black, fontSize: d_10, fontWeight: FontWeight.w600);
  static final greyTextRegular12 = GoogleFonts.openSans(
    color: AppColors.grey_text,
    fontSize: d_12,
  );
  static final hintStyle = GoogleFonts.openSans(
      fontSize: 12, color: AppColors.greyLight, fontWeight: FontWeight.w400);
  static final blackMed20 = GoogleFonts.poppins(
      fontSize: d_20, fontWeight: FontWeight.w500, color: Colors.black);
  static final mainBold30 = GoogleFonts.openSans(
      fontSize: d_30, fontWeight: FontWeight.bold, color: AppColors.mainColor);
  static final blackBold24 = GoogleFonts.roboto(
      fontSize: d_24, fontWeight: FontWeight.w800, color: Colors.black);
  static final whiteBold24 = GoogleFonts.roboto(
      fontSize: d_24, fontWeight: FontWeight.w800, color: Colors.white);

  static final blackMedium14 = GoogleFonts.roboto(
      fontSize: d_14, fontWeight: FontWeight.w500, color: Colors.black);
  static final whiteMedium14 = GoogleFonts.roboto(
      fontSize: d_14, fontWeight: FontWeight.w500, color: Colors.white);

  static final blackBold25 = GoogleFonts.openSans(
      fontSize: d_25, fontWeight: FontWeight.bold, color: Colors.black);

  static final darkGrayBold24 = GoogleFonts.openSans(
      color: AppColors.darkGray, fontSize: d_24, fontWeight: FontWeight.bold);

  static final darkGrayBold22 = GoogleFonts.openSans(
      color: AppColors.nameHead, fontSize: d_22, fontWeight: FontWeight.bold);
  static final semiBoldBlack16 = GoogleFonts.openSans(
      color: AppColors.nameHead, fontSize: d_16, fontWeight: FontWeight.w600);
  static final regularBlack16 =
  GoogleFonts.openSans(color: AppColors.nameHead, fontSize: d_16);
  static final regularSuccess16 =
  GoogleFonts.openSans(color: AppColors.success, fontSize: d_14);
  static final regularSuccess17 =
  GoogleFonts.openSans(color: AppColors.success, fontSize: d_14, fontWeight: FontWeight.w600);
  static final regularDanger17 =
  GoogleFonts.openSans(color: AppColors.danger, fontSize: d_14, fontWeight: FontWeight.w600);
  static final regularDanger16 =
  GoogleFonts.openSans(color: AppColors.danger, fontSize: d_14);
  static final regularWarning17 =
  GoogleFonts.openSans(color: AppColors.warning, fontSize: d_14,fontWeight: FontWeight.w600);
  static final regularWarning16 =
  GoogleFonts.openSans(color: AppColors.warning, fontSize: d_14);
  static final greyRegular12 =
  GoogleFonts.openSans(color: AppColors.grey_text, fontSize: d_12);

  static final darkGrayBold18 = GoogleFonts.openSans(
      color: AppColors.darkGray, fontSize: d_18, fontWeight: FontWeight.bold);

  static final azureLightBold18 = GoogleFonts.openSans(
      color: AppColors.azureColor, fontSize: d_18, fontWeight: FontWeight.w700);

  static final mainNormal14 = GoogleFonts.openSans(
      color: AppColors.mainColor,
      fontSize: d_14,
      fontWeight: FontWeight.normal);

  static final whiteRegular10 = GoogleFonts.openSans(
      color: Colors.white, fontSize: d_10, fontWeight: FontWeight.w400);
  static final mainSemiBold14 = GoogleFonts.openSans(
      color: AppColors.mainColor, fontSize: d_14, fontWeight: FontWeight.w600);
  static final greyBold14 = GoogleFonts.openSans(
      color: AppColors.grey_text, fontSize: d_14, fontWeight: FontWeight.bold);

  static final contactSupport = GoogleFonts.openSans(
    color: AppColors.cardTextColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static final openSansRegular16 = GoogleFonts.openSans(
    color: AppColors.cardTextColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static final openSansRegularMainColor16 = GoogleFonts.openSans(
    color: AppColors.loginColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static final orangeText = GoogleFonts.openSans(
    color: AppColors.radioButton,
    fontSize: 18.0,
    fontWeight: FontWeight.w800,
  );

  static final rechargeHint = GoogleFonts.openSans(
      color: AppColors.greyLight, fontSize: d_12, fontWeight: FontWeight.w400);

  static final whiteNormal15 = GoogleFonts.openSans(
      color: Colors.white, fontSize: d_15, fontWeight: FontWeight.normal);

  static final whiteLightBold20 = GoogleFonts.openSans(
      color: Colors.white, fontSize: d_20, fontWeight: FontWeight.w700);

  static final blackBold18 = GoogleFonts.openSans(
      color: AppColors.nameHead, fontSize: d_18, fontWeight: FontWeight.bold);

  static final lightBlueGaryBold18 = GoogleFonts.openSans(
      color: AppColors.lightBlueGrey,
      fontSize: d_18,
      fontWeight: FontWeight.bold);

  static final blueGrayNormal16 = GoogleFonts.openSans(
      color: AppColors.blueGrey, fontSize: d_16, fontWeight: FontWeight.normal);

  static final checkBox = GoogleFonts.openSans(
      color: AppColors.loginTextColor,
      fontSize: 12.0,
      fontWeight: FontWeight.w400);

  static final checkBox2 = GoogleFonts.openSans(
      color: AppColors.loginColor, fontSize: 12.0, fontWeight: FontWeight.w600);

  static final helpButton = GoogleFonts.openSans(
    color: AppColors.loginColor,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  static final logOutButton = GoogleFonts.openSans(
      color: AppColors.loginBoxColor,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  static final editScreenLabel = GoogleFonts.openSans(
      color: AppColors.cardTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  static final forgetScreenText = GoogleFonts.openSans(
      color: AppColors.cardTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w400);

  static final editScreenHint = GoogleFonts.openSans(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);

  static final orText = GoogleFonts.openSans(
      color: AppColors.loginBoxColor,
      fontSize: 12,
      fontWeight: FontWeight.w600);

  static final blackSemiBold18 = GoogleFonts.openSans(
    fontSize: 18,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static final greenBold18 = GoogleFonts.openSans(
    fontSize: 18,
    color: AppColors.greenColor,
    fontWeight: FontWeight.w800,
  );

  static final orangeBold18 = GoogleFonts.openSans(
    fontSize: 18,
    color: AppColors.radioButton,
    fontWeight: FontWeight.w800,
  );

  static final blueBold18 = GoogleFonts.openSans(
    fontSize: 18,
    color: AppColors.loginColor,
    fontWeight: FontWeight.w800,
  );

  static final underlinedBlueBold18 = GoogleFonts.openSans(
      fontSize: 17,
      color: AppColors.loginColor,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.underline
  );

  static final blackSemiBold16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static final greyDark12 = GoogleFonts.openSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.greyDark,
  );

  static final blueBold14 = GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.loginColor,
  );

  static final blackBold14 = GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final lightGrey13 = GoogleFonts.openSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.cardTextColor,
  );

  static final greyDark14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.greyDark,
  );
  static final greyInactive14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.greyLight,
  );

  static final greyDark16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.greyDark,
  );

  static final greyDarkSemiBold16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.greyDark,
    fontWeight: FontWeight.w600,
  );

  static final blueSemiBold12 = GoogleFonts.openSans(
    fontSize: 12,
    color: AppColors.blue,
    fontWeight: FontWeight.w600,
  );

  static final white16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.white,
    fontWeight: FontWeight.normal,
  );

  static final white12 = GoogleFonts.openSans(
    fontSize: 12,
    color: AppColors.white,
    fontWeight: FontWeight.normal,
  );

  static final blackSemiBold14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static final blackSBold32 = GoogleFonts.openSans(
    fontSize: 33,
    color: AppColors.black,
    fontWeight: FontWeight.w800,
  );

  static final blueSemiBold14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.blue,
    fontWeight: FontWeight.w600,
  );
  static final greyRegular16 =
  GoogleFonts.openSans(color: AppColors.grey_text, fontSize: d_16);
  static final greyMed16 = GoogleFonts.roboto(
      color: AppColors.lightBlueGrey,
      fontSize: d_16,
      fontWeight: FontWeight.w500);
  static final mainMed16 = GoogleFonts.roboto(
      color: AppColors.mainColor, fontSize: d_16, fontWeight: FontWeight.w500);

  static final orangeSemiBold12 = GoogleFonts.openSans(
    color: AppColors.orange,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final greyLightSemiBold12 = GoogleFonts.openSans(
    color: AppColors.inactiveBtnColor,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final whiteSemiBold14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );

  static final whiteBold32 = GoogleFonts.openSans(
    fontSize: 32,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
  );

  static final whiteSemiBold12 = GoogleFonts.openSans(
    fontSize: 12,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );

  static final black14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.black,
  );

  static final blueBold16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.blue,
    fontWeight: FontWeight.w700,
  );

  static final blueSemiBold16 = GoogleFonts.openSans(
    fontSize: 16,
    color: AppColors.blue,
    fontWeight: FontWeight.w600,
  );

  static final blueBold14New = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.blue,
    fontWeight: FontWeight.w700,
  );

  static final greyDarkSemiBold10 = GoogleFonts.openSans(
    fontSize: 10,
    color: AppColors.greyDark,
    fontWeight: FontWeight.w600,
  );

  static final black16 = GoogleFonts.openSans(
      fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w400);

  static final blackSemiBold12 = GoogleFonts.openSans(
    fontSize: 12,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static final greyDark18 = GoogleFonts.openSans(
    fontSize: 18,
    color: AppColors.greyDark,
  );

  static final blueBold20 = GoogleFonts.openSans(
    fontSize: 20,
    color: AppColors.blue,
    fontWeight: FontWeight.w700,
  );

  static final redMedium12 = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.redBright,
  );

  static final greySemiBold14 = GoogleFonts.openSans(
    fontSize: 14,
    color: AppColors.greyLight,
    fontWeight: FontWeight.w600,
  );

  static final blackBold32 = GoogleFonts.openSans(
    fontSize: 32,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
  );

  /// Padding
  EdgeInsetsGeometry pd_0 = const EdgeInsets.all(0.0);
  EdgeInsetsGeometry pd_2 = const EdgeInsets.all(2.0);
  EdgeInsetsGeometry pd_3 = const EdgeInsets.all(3.0);
  EdgeInsetsGeometry pd_4 = const EdgeInsets.all(4.0);
  EdgeInsetsGeometry pd_5 = const EdgeInsets.all(5.0);
  static EdgeInsetsGeometry pd8 = const EdgeInsets.all(8.0);
  static EdgeInsetsGeometry pd10 = const EdgeInsets.all(10.0);
  EdgeInsetsGeometry pd_15 = const EdgeInsets.all(15.0);
  EdgeInsetsGeometry pd_18 = const EdgeInsets.all(18.0);
  static EdgeInsetsGeometry pd20 = const EdgeInsets.all(20.0);
  EdgeInsetsGeometry pd_25 = const EdgeInsets.all(25.0);
  EdgeInsetsGeometry pd_30 = const EdgeInsets.all(30.0);
  EdgeInsetsGeometry pd_40 = const EdgeInsets.all(40.0);
  EdgeInsetsGeometry pd_50 = const EdgeInsets.all(50.0);

  static EdgeInsetsGeometry t202b76 =
  const EdgeInsets.only(top: 71.0, bottom: 76.0, left: 20, right: 20);
  static EdgeInsetsGeometry pdr20 = const EdgeInsets.only(right: 20);
  static EdgeInsetsGeometry t202b10 =
  const EdgeInsets.only(top: 71.0, bottom: 10.0, left: 20, right: 20);
  static EdgeInsetsGeometry pdl15r15t8b8 =
  const EdgeInsets.only(left: d_15, right: d_15, top: d_8, bottom: d_8);

  static EdgeInsetsGeometry pdb20 = const EdgeInsets.only(bottom: d_20);
  EdgeInsetsGeometry pd_5_0_5_0 = const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0);
  EdgeInsetsGeometry pd_0_10_0_10 =
  const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0);
  EdgeInsetsGeometry pd_0_10_10_10 =
  const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0);
  EdgeInsetsGeometry pd_10_10_0_10 =
  const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0);
  EdgeInsetsGeometry pd_10_0_10_0 =
  const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0);
  EdgeInsetsGeometry pd_20_0_20_0 =
  const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0);
  EdgeInsetsGeometry pd_30_0_30_0 =
  const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0);
  EdgeInsetsGeometry pd_30_30_30_10 =
  const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0);
  EdgeInsetsGeometry pd_40_40_40_0 =
  const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0);
  EdgeInsetsGeometry pd_10_22_22_10 =
  const EdgeInsets.fromLTRB(10.0, 22.0, 22.0, 10.0);
  EdgeInsetsGeometry pd_20_20_0_0 =
  const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0);
  EdgeInsetsGeometry pd_30_10_30_10 =
  const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0);
  static EdgeInsetsGeometry pd_20_10_20_10 =
  const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);
  EdgeInsetsGeometry pd_20_20_20_10 =
  const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0);
  EdgeInsetsGeometry pd_20_10_0_10 =
  const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0);
  EdgeInsetsGeometry pd_0_10_20_10 =
  const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0);
  EdgeInsetsGeometry pd_10_6_10_6 =
  const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0);
  EdgeInsetsGeometry pd_8Left = const EdgeInsets.only(left: 8.0);
  EdgeInsetsGeometry pd_20Left = const EdgeInsets.only(left: 20.0);
  EdgeInsetsGeometry pd_50Left = const EdgeInsets.only(left: 50.0);

  EdgeInsetsGeometry pd_20_10_30_10 =
  const EdgeInsets.fromLTRB(20.0, 10.0, 30.0, 10.0);
  EdgeInsetsGeometry pd_10_10_40_10 =
  const EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 10.0);
  static EdgeInsetsGeometry pd_20_25_20_40 =
  const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 40.0);
  static EdgeInsetsGeometry pd_20_15_20_40 =
  const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 40.0);

/* Margin */
  EdgeInsetsGeometry marg_10 = const EdgeInsets.only(left: 10.0);

/* BorderRadius */
  BorderRadius br_20 = BorderRadius.circular(20.0);
  BorderRadius br_10 = BorderRadius.circular(10.0);
  BorderRadius brAll_4 = const BorderRadius.all(Radius.circular(4.0));

/* Shape */
  RoundedRectangleBorder btnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  );

  /* Text Field Decoration for Login - SignUp */

  /*static InputDecoration textFieldDecoration(String text, bool signUp) {
    return InputDecoration(
      hintText: text,
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(
          color: AppColors.textFieldHintTextColor,
          fontWeight: FontWeight.w400,
          fontSize: d_16),
      focusColor: Colors.white,
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: d_2)),
    );
  }*/

  static void setStatusBarTheme() {
    /* Set the status bar color to the widget */
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainColor, //top bar color
      statusBarIconBrightness: Brightness.light, //top bar icons
      systemNavigationBarColor: AppColors.loginBoxColor, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
  }

  static void setDeviceOrientationOfApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static ThemeData getAppTheme() {
    InputBorder _border({Color? color}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? AppColors.greyDark, width: 1),
      );
    }

    return ThemeData(
      primaryColor: AppColors.mainColor,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      // colorScheme:
      //     ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch)
      //         .copyWith(secondary: AppColors.mainColor),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: AppColors.blue,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 18,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.openSans(
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: GoogleFonts.openSans(
          fontSize: 12,
          color: AppColors.greyLight,
        ),
        errorMaxLines: 2,
        errorStyle: GoogleFonts.openSans(
          color: AppColors.red,
          fontSize: 12,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
        errorBorder: _border(),
      ),
      textTheme: TextTheme(
        headline6: GoogleFonts.openSans(
          fontSize: 18,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        headline1: GoogleFonts.openSans(
          fontSize: 22.0,
          color: AppColors.loginTextColor,
          fontWeight: FontWeight.bold,
        ),
        headline2: GoogleFonts.openSans(
          fontSize: 12.0,
          color: AppColors.loginTextColor,
          fontWeight: FontWeight.w400,
        ),
        headline3: GoogleFonts.openSans(
          fontSize: 12.0,
          color: AppColors.loginColor,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
        ),
        headline4: GoogleFonts.openSans(
          fontSize: 14.0,
          color: AppColors.radioButtonTextInActive,
          fontWeight: FontWeight.w400,
        ),
        bodyText2: GoogleFonts.openSans(
          fontSize: 14.0,
          color: AppColors.loginTextColor,
          fontWeight: FontWeight.w400,
        ),
        headline5: GoogleFonts.openSans(
          fontSize: 14,
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
        subtitle1: GoogleFonts.openSans(
          fontSize: 17,
          color: AppColors.cardTextColor,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.openSans(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyText1: GoogleFonts.openSans(
          color: AppColors.black,
          fontSize: 14,
        ),
        caption: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.orange,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.orange),
          textStyle: MaterialStateProperty.all(GoogleFonts.openSans(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          )),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, 54),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(AppColors.black),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.openSans(
              fontSize: 18,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, 54),
          ),
        ),
      ),
    );
  }

  static BoxDecoration whiteColorWithAzureBorderCurve20Decoration =
  BoxDecoration(
      border: Border.all(color: AppColors.azureColor),
      color: Colors.white, // border color
      borderRadius: const BorderRadius.all(const Radius.circular(d_20)));

  static BoxDecoration whiteWithCurve20Decoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(d_20)),
  );

  static BoxDecoration userTournamentDataDecoration(int type) => BoxDecoration(
      borderRadius: type == 1
          ? const BorderRadius.only(
          topLeft: const Radius.circular(d_20), bottomLeft: Radius.circular(d_20))
          : type == 3
          ? const BorderRadius.only(
          topRight: Radius.circular(d_20),
          bottomRight: Radius.circular(d_20))
          : const BorderRadius.only(topLeft: const Radius.circular(d_0)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: type == 1
            ? GradientColors.orange.reversed.toList()
            : type == 2
            ? GradientColors.purple.reversed.toList()
            : GradientColors.darkPink,
      ));
}
