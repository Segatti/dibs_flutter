import 'dart:math';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:chiclet/chiclet.dart';
import 'package:dibs_flutter/app_color.dart';
import 'package:dibs_flutter/models/feedback_model.dart';
import 'package:dibs_flutter/widgets/check_item_text.dart';
import 'package:dibs_flutter/widgets/custom_scroll_behavior.dart';
import 'package:dibs_flutter/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:styled_text/styled_text.dart' as styled;
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  debugRepaintRainbowEnabled = true;

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
  int cursoIndex = 0;
  int investTab = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int indexFeedback = 0;
  PageController pageController = PageController(initialPage: 0);

  GlobalKey dibsKey = GlobalKey();
  GlobalKey equipeKey = GlobalKey();
  GlobalKey cursesKey = GlobalKey();
  GlobalKey investKey = GlobalKey();
  GlobalKey feedbackKey = GlobalKey();

  var listLevels = [
    "        Ao final deste nível, você estará pronto para se comunicar de forma simples e prática em inglês! Imagine poder falar sobre sua família, compartilhar informações sobre seu trabalho, descrever suas experiências passadas e até conversar sobre suas preferências, como filmes, músicas ou hobbies. Você aprenderá frases úteis para situações do dia a dia, como apresentar-se, fazer perguntas e responder com confiança. \n\n        Venha dar o primeiro passo no aprendizado do inglês e descubra como é empolgante começar a se expressar no idioma!",
    "        Ao final deste nível, você terá a confiança necessária para dar suas opiniões sobre temas que domina, compartilhar experiências do passado e falar sobre seus desejos e objetivos. Estará preparado para viajar com fluência, sabendo pedir ajuda, dar e entender direções, além de conversar tranquilamente com falantes de inglês sem grandes preocupações. Imagine discutir filmes que assistiu, descrever viagens incríveis ou planejar suas próximas aventuras internacionais, tudo isso em inglês! \n\n        Este é o passo que conecta você ao mundo. Venha avançar e expandir seus horizontes!",
    "        Ao concluir este nível, você estará pronto para dominar conversas com nuances e falas implícitas, expressando suas opiniões com clareza e confiança em contextos acadêmicos e profissionais. Imagine participar de reuniões, debates ou apresentações, transmitindo suas ideias de forma segura e impactante. Este é o momento em que seu inglês alcança um novo patamar, permitindo que você se destaque em ambientes exigentes e esteja preparado para desafios globais. \n\n        Venha superar barreiras e mostrar todo o seu potencial!",
    "        Ao finalizar este nível, você terá completado todo o curso e se tornado um verdadeiro especialista na Língua Inglesa! Como um falante avançado, estará confiante em suas habilidades linguísticas e preparado para se comunicar com facilidade em qualquer situação, seja em contextos profissionais, acadêmicos ou sociais. Imagine participar de reuniões importantes, discutir temas complexos ou viajar pelo mundo com fluência e naturalidade. Este é o momento de celebrar sua conquista e abrir portas para novas oportunidades. \n        Você está prestes a dominar o inglês de forma definitiva!",
    "        Aprenda tudo o que você precisa para se comunicar com fluência em inglês durante suas aventuras. Este curso é totalmente focado em situações reais enfrentadas por viajantes, como no aeroporto, avião, imigração, hotel e muito mais!  \n        Domine o inglês de viagem e aproveite cada momento sem barreiras! 🌍✈️",
  ];

  var feedbacks = [
    const FeedbackModel(
      name: "Dennys",
      job: "Engenheiro de Materiais",
      message:
          "Há exatamente um mês atrás eu embarcava para uma das maiores aventuras de minha vida: conhecer a Disney e os EUA! E quem diria que eu conseguiria desenrolar conversando em inglês durante o período que passaria lá? Com certeza a @dibsinglesonline_ ! Obrigado por todo apoio, vocês foram essenciais e hoje com certeza eu posso afirmar: I speak English, very well!",
      photo: "assets/images/depoimento1.png",
    ),
    const FeedbackModel(
      name: "Érika Tallyta",
      job: "Doutora em Química",
      message:
          "Eu estudei inglês em diferentes escolas há 10 anos. Nunca consegui concluir nenhum curso, pois sempre me desmotivada por não ver meu progresso. Na DIBS a metodologia exige bastante o que me faz ter vontade de participar das aulas, e como é focado em conversação consegui ver uma grande evolução da minha parte.",
      photo: "assets/images/depoimento2.jpeg",
      alignment: Alignment.topCenter,
    ),
    const FeedbackModel(
      name: "Glauber Matheus Fonseca",
      job: "Professor de Ciências",
      message:
          "Achei maravilhoso, eu senti que evoluir demais na língua inglesa com vocês, hoje é muito mais fácil entender algo em inglês, antes tinha muita dificuldade, a didática é uma das que mais gosto, pois sai do tradicional onde é muito cansativo na minha opinião, a todas as pessoas que me perguntam, sempre indico vocês ❤️.",
      photo: "assets/images/depoimento3.jpeg",
      alignment: Alignment.centerRight,
    ),
    const FeedbackModel(
      name: "Giovanna Barbosa",
      job: "Advogada",
      message:
          "A Dibs é um escola muito especial, com didática impecável e diversa, transformando a aprendizagem em um processo prazeroso! Tive a melhor das experiências de ensino com vocês.",
      photo: "assets/images/depoimento4.jpeg",
      alignment: Alignment.topLeft,
    ),
    const FeedbackModel(
      name: "Mariley Wegner",
      job: "Estudante de Medicina",
      message:
          "Preciso agradecer essa experiência durante esse ano! Quando minha amiga me indicou a Dibs eu lembro que cancelei o contrato da outra escola porque ficamos super empolgadas com a proposta! E realmente a metodologia de ensino faz jus a todo o resultado obtido! E a ansiedade para dar continuidade é cada dia maior... para aumentar os aprendizados e minha fluência 🧡💛.",
      photo: "assets/images/depoimento5.jpeg",
    ),
  ];

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: Column(
          children: [
            const Gap(16),
            const Text("Menu").fontSize(18).fontWeight(FontWeight.bold),
            const Gap(16),
            const Divider(
              height: 2,
              thickness: 2,
              color: Colors.black12,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final contextKey = dibsKey.currentContext;
                        if (contextKey != null) {
                          Scrollable.ensureVisible(
                            contextKey,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Dibs")
                            .fontSize(16)
                            .fontWeight(FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final contextKey = equipeKey.currentContext;
                        if (contextKey != null) {
                          Scrollable.ensureVisible(
                            contextKey,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Equipe")
                            .fontSize(16)
                            .fontWeight(FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final contextKey = cursesKey.currentContext;
                        if (contextKey != null) {
                          Scrollable.ensureVisible(
                            contextKey,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Cursos")
                            .fontSize(16)
                            .fontWeight(FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final contextKey = investKey.currentContext;
                        if (contextKey != null) {
                          Scrollable.ensureVisible(
                            contextKey,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Investimento")
                            .fontSize(16)
                            .fontWeight(FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final contextKey = feedbackKey.currentContext;
                        if (contextKey != null) {
                          Scrollable.ensureVisible(
                            contextKey,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Estudantes")
                            .fontSize(16)
                            .fontWeight(FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black12,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: size.width - 32,
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
                  Visibility(
                    visible: responsiveValue(context, xs: true, md: false),
                    child: Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              _key.currentState!.openDrawer();
                            },
                            icon: const Icon(
                              LucideIcons.menu,
                              size: 35,
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: responsiveValue(context, xs: false, md: true),
                    child: MenuButton(
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
                  ),
                  Visibility(
                    visible: responsiveValue(context, xs: false, md: true),
                    child: MenuButton(
                      title: "Equipe",
                      onTap: () {
                        final context = equipeKey.currentContext;
                        if (context != null) {
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: responsiveValue(context, xs: false, md: true),
                    child: MenuButton(
                      title: "Cursos",
                      onTap: () {
                        final context = cursesKey.currentContext;
                        if (context != null) {
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: responsiveValue(context, xs: false, md: true),
                    child: MenuButton(
                      title: "Investimento",
                      onTap: () {
                        final context = investKey.currentContext;
                        if (context != null) {
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: responsiveValue(context, xs: false, lg: true),
                    child: MenuButton(
                      title: "Estudantes",
                      onTap: () {
                        final context = feedbackKey.currentContext;
                        if (context != null) {
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              RepaintBoundary(
                child: Container(
                  height: max(825, min(1000 - 110, size.height - 110)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: .9),
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 10,
                      ),
                    ),
                  ),
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
                                fontSize:
                                    responsiveValue(context, xs: 24, sm: 28),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Gap(32),
                                        const CheckItemText(
                                            title:
                                                "Aulas ao vivo (não são gravadas)"),
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
                                        Gap(
                                          responsiveValue(context,
                                              xs: 32, md: 64),
                                        ),
                                        const Gap(16),
                                        const Text(
                                          "* O Certificado é emitido ao finalizar o nivel de inglês avançado.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Gap(
                                          responsiveValue(context,
                                              xs: 16, md: 64),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  final context =
                                                      dibsKey.currentContext;
                                                  if (context != null) {
                                                    Scrollable.ensureVisible(
                                                      context,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    const Text("Saiba mais")
                                                        .fontSize(20)
                                                        .textColor(Colors.white)
                                                        .fontWeight(
                                                            FontWeight.bold),
                                                    const Icon(
                                                      LucideIcons.chevronDown,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(
                                          responsiveValue(context,
                                              xs: 16, md: 32),
                                        ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
              ),
              RepaintBoundary(
                child: Container(
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
                        width: size.width *
                            responsiveValue(context, xs: 1, sm: .8),
                        constraints: const BoxConstraints(maxWidth: 1024),
                        height: max(825, min(1000 - 110, size.height - 110)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(64),
                            styled.StyledText(
                              text:
                                  "A Dibs é uma escola on-line de inglês, com o objetivo de ensinar a Língua Inglesa de maneira <underline>acessível</underline> e <underline>eficiente</underline>, focado em <bold>CONVERSAÇÃO</bold>",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF082a72),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              tags: {
                                "underline": styled.StyledTextTag(
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: colorScheme.tertiary,
                                    decorationThickness: 3,
                                  ),
                                ),
                                "bold": styled.StyledTextTag(
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
                                "assets/images/mapaNew.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  key: equipeKey,
                  height: max(825, min(1000 - 110, size.height - 110)),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/mapaMundi.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Color(0xAF418dd5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          "assets/images/team.png",
                          height: max(825, min(1000 - 110, size.height - 110)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: .05),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            "assets/images/team.png",
                            height:
                                max(825, min(1000 - 110, size.height - 110)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: responsiveValue(context, xs: 8, sm: 16),
                          ),
                          width: size.width *
                              responsiveValue(context, xs: 1, sm: .8),
                          constraints: const BoxConstraints(maxWidth: 1024),
                          height: max(825, min(1000 - 110, size.height - 110)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Gap(64),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Um time de especialistas para guiar seu aprendizado",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 26,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Gap(32),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: .8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        "Nossos professores são especialistas no ensino da língua inglesa, com excelência comprovada. \n\nTodos possuem formação superior e fluência em inglês, prontos para ajudar você a alcançar seus objetivos.",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: responsiveValue(context,
                                        xs: false, md: true),
                                    child: const Spacer(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  key: cursesKey,
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
                        width: size.width *
                            responsiveValue(context, xs: 1, sm: .8),
                        constraints: const BoxConstraints(maxWidth: 1024),
                        height: max(825, min(1000 - 110, size.height - 110)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(64),
                            styled.StyledText(
                              text:
                                  "Cada nível possui <bold>20 aulas</bold> focadas em conversação",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF082a72),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              tags: {
                                "bold": styled.StyledTextTag(
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              },
                            ),
                            // const Gap(16),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: AppColor.primary,
                            //     borderRadius: BorderRadius.circular(50),
                            //   ),
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 16,
                            //     vertical: 8,
                            //   ),
                            //   child: Text(
                            //     "20 aulas em cada nível",
                            //     style: GoogleFonts.montserrat(
                            //       fontSize: 18,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                            const Gap(24),
                            Text(
                              "CASO VOCÊ NÃO TENHA CERTEZA QUAL SEU NÍVEL, OFERECEMOS GRATUITAMENTE UM TESTE DE NIVELAMENTO EM CONVERSAÇÂO EM INGLÊS. ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(24),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 0),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cursoIndex = 0;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  color: (cursoIndex == 0)
                                                      ? AppColor.primary
                                                      : AppColor
                                                          .backgroundColor,
                                                ),
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "Básico",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: (cursoIndex == 0)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cursoIndex = 1;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  color: (cursoIndex == 1)
                                                      ? AppColor.primary
                                                      : AppColor
                                                          .backgroundColor,
                                                ),
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "Intermediário",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: (cursoIndex == 1)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cursoIndex = 2;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  color: (cursoIndex == 2)
                                                      ? AppColor.primary
                                                      : AppColor
                                                          .backgroundColor,
                                                ),
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "Pré Avançado",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: (cursoIndex == 2)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cursoIndex = 3;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  color: (cursoIndex == 3)
                                                      ? AppColor.primary
                                                      : AppColor
                                                          .backgroundColor,
                                                ),
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "Avançado",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: (cursoIndex == 3)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cursoIndex = 4;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  color: (cursoIndex == 4)
                                                      ? AppColor.primary
                                                      : AppColor
                                                          .backgroundColor,
                                                ),
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    "Ingles para viagem",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: (cursoIndex == 4)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: AppColor.primary,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(32),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            listLevels[cursoIndex],
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(64),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: .9),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: responsiveValue(context, xs: 8, sm: 16),
                        ),
                        width: size.width *
                            responsiveValue(context, xs: 1, sm: .8),
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(64),
                            styled.StyledText(
                              text:
                                  "Oferecemos turmas reduzidas para garantir mais atenção e prática! ⏳✨",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const Gap(64),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: responsiveValue(context,
                                            xs: .5, xl: .1),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        styled.StyledText(
                                          text:
                                              "\n<bold>Aqui você só paga a mensalidade sem taxa escondida. Sem enrolação. Simples assim. ⏳✨ E recebe tudo isso incluso, online:</bold>",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: responsiveValue(context,
                                                xs: 14, sm: 16, md: 18),
                                          ),
                                          tags: {
                                            "bold": styled.StyledTextTag(
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsiveValue(
                                                    context,
                                                    xs: 16,
                                                    sm: 18,
                                                    md: 20),
                                                color: colorScheme.secondary,
                                              ),
                                            ),
                                            "icon": styled.StyledTextIconTag(
                                              LucideIcons.check,
                                            ),
                                          },
                                        ),
                                        const Gap(32),
                                        styled.StyledText(
                                          text:
                                              "<icon/> Aulas ao vivo dinâmicas e interativas.\n<icon/> Material completo.\n<icon/> Atividades extras + planner de estudos diário.\n<icon/> Correção personalizada e acompanhamento de perto.\n<icon/> Bônus exclusivos na sua sala de aula virtual.\n",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: responsiveValue(context,
                                                xs: 14, sm: 16, md: 18),
                                          ),
                                          tags: {
                                            "bold": styled.StyledTextTag(
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: responsiveValue(
                                                    context,
                                                    xs: 16,
                                                    sm: 18,
                                                    md: 20),
                                                color: colorScheme.secondary,
                                              ),
                                            ),
                                            "icon": styled.StyledTextIconTag(
                                              LucideIcons.check,
                                              color: colorScheme.secondary,
                                              size: 30,
                                            ),
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(64),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  key: investKey,
                  width: double.infinity,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minHeight: size.height - 110),
                  decoration: const BoxDecoration(
                    color: AppColor.backgroundColor,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsiveValue(context, xs: 8, sm: 16),
                    ),
                    width: size.width * responsiveValue(context, xs: 1, sm: .8),
                    constraints: const BoxConstraints(maxWidth: 1024),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(64),
                        styled.StyledText(
                          text:
                              "Aqui, você escolhe o formato que melhor encaixa na sua rotina! ⏳✨",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: AppColor.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          tags: {
                            "bold": styled.StyledTextTag(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: colorScheme.secondary,
                              ),
                            ),
                          },
                        ),
                        const Gap(32),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            "Todos os valores são individuais",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: AppColor.backgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(32),
                        Wrap(
                          spacing: min(
                            50,
                            MediaQuery.sizeOf(context).width * .1,
                          ),
                          runSpacing: 32,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                              ),
                              width: MediaQuery.sizeOf(context).width *
                                  responsiveValue(context,
                                      xs: 1, md: .4, lg: .3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2,
                                ),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    blurRadius: 20,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(16),
                                  styled.StyledText(
                                    text: "Plano Ouro <color>🟡</color>",
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    tags: {
                                      "color": styled.StyledTextTag(
                                        style: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                    },
                                  ),
                                  const Gap(16),
                                  const Divider(
                                    height: 2,
                                    color: Colors.amber,
                                    thickness: 2,
                                  ),
                                  const Gap(16),
                                  const Text("Aulas 1x na semana")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.w500)
                                      .bold(),
                                  const Gap(16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: styled.StyledText(
                                      text:
                                          "👥 <bold>Grupo (até 4 pessoas)</bold> – Mais interação e exposição a diferentes sotaques → <bold>R\$ 447,99/mês</bold>\n\n👫 <bold>Dupla</bold> – Ritmo intenso com troca de experiências → <bold>R\$ 897,99/mês</bold>\n\n👩🏽‍💻 <bold>Individual</bold> – Atendimento 100% exclusivo e individualizado para você → <bold>R\$ 1.797,99/mês</bold>",
                                      tags: {
                                        "bold": styled.StyledTextTag(
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 26,
                                            // color: colorScheme.secondary,
                                          ),
                                        ),
                                      },
                                    ),
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      const Gap(16),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.tertiary.darken(20),
                                            foregroundColor: Colors.white,
                                            fixedSize:
                                                const Size.fromHeight(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  "https://wa.me/5594984068284?text=Ol%C3%A1%2C%20Eu%20gostaria%20de%20contratar%20o%20plano%20ouro!"),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: const Text("Contratar")
                                              .fontWeight(FontWeight.bold)
                                              .fontSize(16),
                                        ),
                                      ),
                                      const Gap(16),
                                    ],
                                  ),
                                  const Gap(16),
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                              ),
                              width: MediaQuery.sizeOf(context).width *
                                  responsiveValue(context,
                                      xs: 1, md: .4, lg: .3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    blurRadius: 20,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(16),
                                  styled.StyledText(
                                    text: "Plano Rubi <color>♦️</color>",
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    tags: {
                                      "color": styled.StyledTextTag(
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    },
                                  ),
                                  const Gap(16),
                                  const Divider(
                                    height: 2,
                                    color: Colors.red,
                                    thickness: 2,
                                  ),
                                  const Gap(16),
                                  const Text("Aulas 2x na semana")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.w500)
                                      .bold(),
                                  const Gap(16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: styled.StyledText(
                                      text:
                                          "👥 <bold>Grupo (até 4 pessoas)</bold> – Mais interação e exposição a diferentes sotaques → <bold>R\$ 897,99/mês</bold>\n\n👫 <bold>Dupla</bold> – Ritmo intenso com troca de experiências → <bold>R\$ 1.797,99/mês</bold>\n\n👩🏽‍💻 <bold>Individual</bold> – Atendimento 100% exclusivo e individualizado para você → <bold>R\$ 3.595,98/mês</bold>",
                                      tags: {
                                        "bold": styled.StyledTextTag(
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 26,
                                            // color: colorScheme.secondary,
                                          ),
                                        ),
                                      },
                                    ),
                                  ),
                                  const Gap(16),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.orange,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    child: const Text("Plano mais vendido")
                                        .bold()
                                        .textColor(Colors.white),
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      const Gap(16),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.primary,
                                            foregroundColor: Colors.white,
                                            fixedSize:
                                                const Size.fromHeight(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  "https://wa.me/5594984068284?text=Ol%C3%A1%2C%20Eu%20gostaria%20de%20contratar%20o%20plano%rubi!"),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: const Text("Contratar")
                                              .fontWeight(FontWeight.bold)
                                              .fontSize(16),
                                        ),
                                      ),
                                      const Gap(16),
                                    ],
                                  ),
                                  const Gap(16),
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                              ),
                              width: MediaQuery.sizeOf(context).width *
                                  responsiveValue(context,
                                      xs: 1, md: .4, lg: .3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    blurRadius: 20,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(16),
                                  styled.StyledText(
                                    text: "Plano Diamante <color>💎</color>",
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Gap(16),
                                  const Divider(
                                    height: 2,
                                    color: Colors.blue,
                                    thickness: 2,
                                  ),
                                  const Gap(16),
                                  const Text("Aulas 5x na semana")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.w500)
                                      .bold(),
                                  const Gap(16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: styled.StyledText(
                                      text:
                                          "👥 <bold>Grupo (até 4 pessoas)</bold> – Mais interação e exposição a diferentes sotaques → <bold>R\$ 1.800,00/mês</bold>\n\n👫 <bold>Dupla</bold> – Ritmo intenso com troca de experiências → <bold>R\$ 3.600,00/mês</bold>\n\n👩🏽‍💻 <bold>Individual</bold> – Atendimento 100% exclusivo e individualizado para você → <bold>R\$ 7.200,00/mês</bold>",
                                      tags: {
                                        "bold": styled.StyledTextTag(
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 26,
                                            // color: colorScheme.secondary,
                                          ),
                                        ),
                                      },
                                    ),
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      const Gap(16),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.secondary,
                                            foregroundColor: Colors.white,
                                            fixedSize:
                                                const Size.fromHeight(50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  "https://wa.me/5594984068284?text=Ol%C3%A1%2C%20Eu%20gostaria%20de%20contratar%20o%20plano%diamante!"),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: const Text("Contratar")
                                              .fontWeight(FontWeight.bold)
                                              .fontSize(16),
                                        ),
                                      ),
                                      const Gap(16),
                                    ],
                                  ),
                                  const Gap(16),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(64),
                        const Text(
                          "Cartão de crédito (cobrança recorrente), boleto ou pix.",
                          textAlign: TextAlign.center,
                        ).fontWeight(FontWeight.w600).fontSize(18),
                        const Gap(32),
                        const Gap(64),
                      ],
                    ),
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  key: feedbackKey,
                  height: max(825, min(1000 - 110, size.height - 110)),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xAF418dd5),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsiveValue(context, xs: 8, sm: 16),
                    ),
                    width: size.width * responsiveValue(context, xs: 1, sm: .8),
                    constraints: const BoxConstraints(maxWidth: 1024),
                    child: Column(
                      children: [
                        const Gap(64),
                        styled.StyledText(
                          text:
                              "Veja o que nossos estudantes estão dizendo da Dibs",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: AppColor.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          tags: {
                            "bold": styled.StyledTextTag(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: colorScheme.secondary,
                              ),
                            ),
                          },
                        ),
                        const Gap(64),
                        Expanded(
                          child: SizedBox(
                            width: 900,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: responsiveValue(context,
                                      xs: false, xl: true),
                                  child: IconButton(
                                    onPressed: () {
                                      pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    icon: const Icon(
                                      LucideIcons.chevronLeft,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ScrollConfiguration(
                                    behavior: CustomScrollBehavior(),
                                    child: PageView.builder(
                                      controller: pageController,
                                      onPageChanged: (value) {
                                        setState(() {
                                          indexFeedback = value;
                                        });
                                      },
                                      itemCount: feedbacks.length,
                                      itemBuilder: (context, index) {
                                        var feedback = feedbacks[index];
                                        return Card(
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: responsiveValue(
                                                      context,
                                                      xs: 9 / 16,
                                                      md: 12 / 16,
                                                      xl: 1),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      feedback.photo,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          feedback.alignment,
                                                    ),
                                                  ),
                                                ),
                                                const Gap(16),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      children: [
                                                        Text(feedback.name)
                                                            .fontSize(20)
                                                            .fontWeight(
                                                                FontWeight.bold)
                                                            .textColor(
                                                                Colors.black),
                                                        const Gap(8),
                                                        Text(feedback.job)
                                                            .fontSize(18)
                                                            .fontWeight(
                                                                FontWeight.w600)
                                                            .textColor(AppColor
                                                                .secondary),
                                                        const Gap(16),
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            child: Text(
                                                              feedback.message,
                                                            )
                                                                .fontSize(16)
                                                                .fontWeight(
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: responsiveValue(context,
                                      xs: false, xl: true),
                                  child: IconButton(
                                    onPressed: () {
                                      pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    icon: const Icon(
                                      LucideIcons.chevronRight,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(16),
                        Visibility(
                          visible:
                              responsiveValue(context, xs: true, xl: false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const Icon(
                                  LucideIcons.chevronLeft,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              const Gap(32),
                              IconButton(
                                onPressed: () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const Icon(
                                  LucideIcons.chevronRight,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        AnimatedSmoothIndicator(
                          activeIndex: indexFeedback,
                          count: feedbacks.length,
                          effect: WormEffect(
                            activeDotColor: responsiveValue(context,
                                xs: AppColor.tertiary, xl: AppColor.primary),
                            dotColor: Colors.white,
                          ),
                        ),
                        const Gap(32),
                        ChicletOutlinedAnimatedButton(
                          backgroundColor: const Color(0xFF25d366),
                          borderColor: const Color(0xFF25d366).lighten(50),
                          buttonColor: const Color(0xFF25d366).darken(20),
                          buttonHeight: 10,
                          width: 400,
                          height: 60,
                          onPressed: () {
                            launchUrl(
                              Uri.parse("https://wa.me/5594984068284?text=Hey"),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                                size: 40,
                              ),
                              Gap(8),
                              Text(
                                "Entrar em contato",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        ChicletOutlinedAnimatedButton(
                          backgroundColor: const Color(0xFF24cf5f),
                          borderColor: const Color(0xFF24cf5f).darken(2),
                          buttonColor: const Color(0xFF24cf5f).darken(20),
                          buttonHeight: 10,
                          width: 400,
                          height: 60,
                          onPressed: () {
                            launchUrl(
                              Uri.parse(
                                  "https://open.spotify.com/playlist/591Anp20c5C2So0EY6dIJn?si=1Ig5xaiNRlCqy2bczKAZHg"),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.spotify,
                                color: Colors.white,
                                size: 30,
                              ),
                              Gap(16),
                              Text(
                                "Ouça nossa Playlist",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        ChicletOutlinedAnimatedButton(
                          backgroundColor: colorScheme.secondary,
                          borderColor: colorScheme.secondary.darken(2),
                          buttonColor: colorScheme.secondary.darken(20),
                          buttonHeight: 10,
                          width: 400,
                          height: 60,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    width:
                                        MediaQuery.sizeOf(context).width * .8,
                                    constraints: const BoxConstraints(
                                      maxWidth: 800,
                                      maxHeight: 800,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Gap(30),
                                            const Text("Loja Dibs")
                                                .fontSize(24),
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  LucideIcons.x,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(16),
                                        const Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        const Gap(16),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Wrap(
                                              spacing: 32,
                                              runSpacing: 32,
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  height: 300,
                                                  child: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        launchUrl(
                                                          Uri.parse(
                                                              "https://hotm.art/todolist2024"),
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        "assets/images/todolist.jpeg",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  height: 300,
                                                  child: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        launchUrl(
                                                          Uri.parse(
                                                              "https://hotm.art/plannerdeingles"),
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        "assets/images/planner.jpeg",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.store,
                                color: Colors.white,
                                size: 30,
                              ),
                              Gap(16),
                              Text(
                                "Loja Dibs",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(32),
                      ],
                    ),
                  ),
                ),
              ),
              RepaintBoundary(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColor.backgroundColor,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: responsiveValue(context, xs: 8, sm: 16),
                    ),
                    width: size.width * responsiveValue(context, xs: 1, sm: .8),
                    constraints: const BoxConstraints(maxWidth: 1024),
                    child: Column(
                      children: [
                        const Gap(32),
                        styled.StyledText(
                          text: "Ficou com alguma dúvida?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          tags: {
                            "bold": styled.StyledTextTag(
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: colorScheme.secondary,
                              ),
                            ),
                          },
                        ),
                        const Gap(32),
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title: const Text("A escola Dibs é para mim?")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.bold),
                                  children: const [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Gap(16),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "Se você está buscando fluência na Língua Inglesa, independente se já fez anos de curso ou nunca entrou em uma aula de inglês, a Dibs é para você, pois aqui você será estimulado a falar totalmente em inglês desde da primeira aula de maneira leve e didática. A transformação dos estudantes é surpreendente.",
                                      ),
                                    ),
                                    Gap(16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title: const Text(
                                          "Quem já fez curso de inglês pode ser estudante da Dibs?")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.bold),
                                  children: const [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Gap(16),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "Sim. Caso o estudante já tenha feito outros cursos de inglês, nós marcamos um teste de nível, que nada mais é que uma conversa em inglês para saber qual o melhor nível para tomar sequência. Se você não quer mais travar na hora de falar ou ter medo de se comunicar em inglês, as nossas aulas de conversação são elaboradas para você se soltar e falar com tranquilidade.",
                                      ),
                                    ),
                                    Gap(16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title: const Text(
                                          "Qual é o melhor módulo para mim?")
                                      .fontSize(16)
                                      .fontWeight(FontWeight.bold),
                                  children: const [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Gap(16),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "O módulo ideal para você depende de onde você quer chegar e quanto tempo quer levar para isso.\n\nSe você tem uma rotina corrida e precisa do inglês para avançar na sua carreira profissional, existem dois módulos que podem se encaixar perfeitamente para você. O primeiro é Mini intensivo, com duração de apenas 3 meses, você terá aulas duas vezes na semana com apenas 1 hora e 30 minutos de aula focado em conversação.\n\nO outro é Intensivão que ocorre nos meses de Janeiro e Julho. Nele você aprende todos os dias com apenas 1 hora e 30 minutos de aula, tem atividades todos os dias, para auxiliar no aprendizado. Ao final de um 1 mês, você terá o conhecimento equivalente a 5 meses de curso.\n\nSe você quer aprender inglês e não se preocupa tanto com o tempo que isso pode levar, ou até mesmo apenas manter o que você já aprendeu, ou apenas para praticar conversação, nós indicamos o módulo Regular. Nele você assistirá apenas uma aula por semana de 1 hora e 30 minutos, a duração de cada nível é de 5 meses.",
                                      ),
                                    ),
                                    Gap(16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title:
                                      const Text("Onde irei assistir as aulas?")
                                          .fontSize(16)
                                          .fontWeight(FontWeight.bold),
                                  children: const [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Gap(16),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "Nossas aulas são ao vivo, utilizamos o Google meet. Mas não se preocupe, sempre mostramos o passo a passo para ter acesso às aulas e as atividades antes de começar o curso, você não precisa mais gastar tempo e dinheiro se deslocando, porque a Dibs é 100% online. Podendo assistir as aulas do computador, tablet, e até mesmo no seu celular!",
                                      ),
                                    ),
                                    Gap(16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: Colors.white,
                                  title:
                                      const Text("Como funciona o pagamento?")
                                          .fontSize(16)
                                          .fontWeight(FontWeight.bold),
                                  children: const [
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                    Gap(16),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "Você pode realizar o pagamento via boleto ou pix (5% de desconto pagando até o vencimento escolhido) ou cartão de crédito na modalidade crédito parcelado recorrente (tipo: netflix e spotify, não compromete o limite do seu crédito).",
                                      ),
                                    ),
                                    Gap(16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(64),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColor.primary,
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Container(
                  width: size.width * responsiveValue(context, xs: 1, sm: .8),
                  constraints: const BoxConstraints(maxWidth: 1024),
                  child: Column(
                    children: [
                      const Text(
                        "Segunda a Sexta 8h às 20h • Horário de Brasília",
                        textAlign: TextAlign.center,
                      )
                          .textColor(Colors.white)
                          .fontSize(16)
                          .fontWeight(FontWeight.w600),
                      const Gap(16),
                      const Text(
                        "ceo@dibsinglesonline.com - CNPJ: 44.174.762/0001-80",
                        textAlign: TextAlign.center,
                      )
                          .textColor(Colors.white)
                          .fontSize(16)
                          .fontWeight(FontWeight.w600),
                      const Gap(16),
                      const Text(
                        "© 2025 Dibs. Todos direitos reservados.",
                        textAlign: TextAlign.center,
                      )
                          .textColor(Colors.white)
                          .fontSize(16)
                          .fontWeight(FontWeight.w600)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RepaintBoundary(
        child: FloatingActionButton(
          onPressed: scrollToTop,
          tooltip: 'Para o topo',
          child: const Icon(LucideIcons.arrowUpFromDot),
        ),
      ),
    );
  }
}
