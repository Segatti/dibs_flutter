import 'dart:math';

import 'package:awesome_extensions/awesome_extensions.dart' hide StyledText;
import 'package:chiclet/chiclet.dart';
import 'package:dibs_flutter/app_color.dart';
import 'package:dibs_flutter/widgets/check_item_text.dart';
import 'package:dibs_flutter/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dibs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          tertiary: AppColor.tertiary,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool showButton = false;

  GlobalKey dibsKey = GlobalKey();

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 50) {
        if (!showButton) {
          setState(() {
            showButton = true;
          });
        }
      } else {
        if (showButton) {
          setState(() {
            showButton = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.black,
        elevation: 10,
        bottom: AppBar(
          toolbarHeight: 10,
          backgroundColor: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: size.width * .8,
              constraints: const BoxConstraints(maxWidth: 1024),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(100),
                      ),
                      border: Border(
                        right: BorderSide(
                          color: Colors.white,
                          width: 10,
                        ),
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 10,
                        ),
                        top: BorderSide(
                          color: Colors.white,
                          width: 10,
                        ),
                      ),
                    ),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  const Gap(16),
                  MenuButton(
                    title: "Dibs",
                    onTap: () {
                      final context = dibsKey.currentContext;
                      if (context != null) {
                        Scrollable.ensureVisible(
                          context,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const Gap(16),
                  MenuButton(
                    title: "Equipe",
                    onTap: () {},
                  ),
                  const Gap(16),
                  MenuButton(
                    title: "Cursos",
                    onTap: () {},
                  ),
                  const Gap(16),
                  MenuButton(
                    title: "Investimento",
                    onTap: () {},
                  ),
                  const Gap(16),
                  MenuButton(
                    title: "Estudantes",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: [
            Container(
              height: max(825, min(1000 - 110, size.height - 110)),
              color: colorScheme.primary.withOpacity(.9),
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: size.width * .8,
                    constraints: const BoxConstraints(maxWidth: 1024),
                    height: max(825, min(1000 - 110, size.height - 110)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(responsiveValue(context, xs: 32, sm: 64)),
                        Text(
                          "Somos especializados em conversação em inglês",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsiveValue(context, xs: 24, sm: 28),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(responsiveValue(context, xs: 16, sm: 32)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Gap(32),
                                    const CheckItemText(title: "Aulas ao vivo"),
                                    const Gap(16),
                                    const CheckItemText(
                                      title: "Professores qualificados",
                                    ),
                                    const Gap(16),
                                    const CheckItemText(
                                        title: "Curso de Inglês geral"),
                                    const Gap(16),
                                    const CheckItemText(
                                      title: "Curso de Inglês p/ viagem",
                                    ),
                                    const Gap(16),
                                    const CheckItemText(
                                      title: "Certificado*",
                                    ),
                                    const Gap(64),
                                    Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: ChicletOutlinedAnimatedButton(
                                            backgroundColor:
                                                colorScheme.secondary,
                                            borderColor:
                                                colorScheme.secondary.darken(2),
                                            buttonColor: colorScheme.secondary
                                                .darken(20),
                                            buttonHeight: 10,
                                            width: 400,
                                            height: 60,
                                            onPressed: () {
                                              launchUrl(
                                                Uri.parse(
                                                    "https://wa.me/5594984068284?text=Hey"),
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            },
                                            child: const Text(
                                              "Quero me matricular",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(16),
                                    const Text(
                                      "* Só ganha o certificado se você finalizar todo o curso.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Gap(32),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: responsiveValue(context,
                                    xs: false, lg: true),
                                child: const Gap(32),
                              ),
                              Visibility(
                                visible: responsiveValue(context,
                                    xs: false, lg: true),
                                child: Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                          "assets/images/fundadora.png"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              key: dibsKey,
              height: max(825, min(1000 - 110, size.height - 110)),
              color: AppColor.backgroundColor,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsiveValue(context, xs: 8, sm: 16),
                    ),
                    width: size.width * responsiveValue(context, xs: 1, sm: .8),
                    constraints: const BoxConstraints(maxWidth: 1024),
                    height: max(825, min(1000 - 110, size.height - 110)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(64),
                        StyledText(
                          text:
                              "A Dibs é uma escola on-line de inglês, com o objetivo de ensinar a Língua Inglesa de maneira <underline>acessível</underline> e <underline>eficiente</underline>, focado em <bold>CONVERSAÇÃO</bold>",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF082a72),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          tags: {
                            "underline": StyledTextTag(
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: colorScheme.tertiary,
                                decorationThickness: 3,
                              ),
                            ),
                            "bold": StyledTextTag(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondary,
                              ),
                            ),
                          },
                        ),
                        const Gap(64),
                        Text(
                          "Temos estudantes pelo mundo todo ficando fluentes em inglês na nossa escola.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Image.asset(
                            "assets/images/mapa.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (showButton)
          ? FloatingActionButton(
              onPressed: scrollToTop,
              tooltip: 'Para o topo',
              child: const Icon(LucideIcons.arrowUpFromDot),
            )
          : null,
    );
  }
}
