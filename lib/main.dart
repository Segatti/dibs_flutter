import 'package:confetti/confetti.dart';
import 'package:dibs_flutter/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/lotties_asset.dart';

// Sistema de responsividade
class ResponsiveBreakpoints {
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1200;
}

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
        MediaQuery.of(context).size.width < ResponsiveBreakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0);
    }
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double mobile = 16,
    double tablet = 18,
    double desktop = 20,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getResponsiveTitleFontSize(
    BuildContext context, {
    double mobile = 32,
    double tablet = 40,
    double desktop = 48,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // debugRepaintRainbowEnabled = true;

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
      home: const DibsSite(),
    );
  }
}

class DibsSite extends StatefulWidget {
  const DibsSite({super.key});

  @override
  State<DibsSite> createState() => _DibsSiteState();
}

class _DibsSiteState extends State<DibsSite> {
  final CadastroDibs cadastro = CadastroDibs();
  int _pageIndex = 0;

  void nextPage() {
    if (_pageIndex < 10) {
      setState(() => _pageIndex++);
    }
  }

  void previousPage() {
    if (_pageIndex > 0) {
      setState(() => _pageIndex--);
    }
  }

  Widget getPage() {
    switch (_pageIndex) {
      case 0:
        return _TelaNome(
          cadastro: cadastro,
          onNext: () {
            cadastro.nome = cadastro.nome.trim();
            nextPage();
          },
        );
      case 1:
        return _TelaMetodologia(
          onNext: nextPage,
          onBack: previousPage,
        );
      case 2:
        return _TelaEstrutura(
          onNext: nextPage,
          onBack: previousPage,
        );
      case 3:
        return _TelaMotivacao(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 4:
        return _TelaExperiencia(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 5:
        return _TelaNivel(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 6:
        return _TelaDificuldade(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 7:
        return _TelaModalidade(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 8:
        return _TelaPlano(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 9:
        return _TelaDisponibilidade(
          cadastro: cadastro,
          onNext: nextPage,
          onBack: previousPage,
        );
      case 10:
        return _TelaFinal(
          cadastro: cadastro,
          onBack: previousPage,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: getPage(),
        ),
      ),
    );
  }
}

// Widget de botão de voltar responsivo
class TopLeftBackButton extends StatelessWidget {
  final VoidCallback onBack;
  const TopLeftBackButton({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Positioned(
      top: isMobile ? 16 : 24,
      left: isMobile ? 16 : 24,
      child: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Colors.white, size: isMobile ? 32 : (isTablet ? 36 : 40)),
        onPressed: onBack,
        tooltip: 'Voltar',
      ),
    );
  }
}

class _TelaNome extends StatefulWidget {
  final CadastroDibs cadastro;
  final void Function() onNext;
  const _TelaNome({required this.cadastro, required this.onNext});

  @override
  State<_TelaNome> createState() => _TelaNomeState();
}

class _TelaNomeState extends State<_TelaNome> {
  late TextEditingController _controller;
  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.cadastro.nome);
    _isFilled = widget.cadastro.nome.isNotEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ResponsiveUtils.isMobile(context)) {
        showDialog(
          context: context,
          builder: (_) {
            return Dialog.fullscreen(
              backgroundColor: AppColor.primary,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: SvgPicture.asset(
                            "assets/icons/dibs.svg",
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Dibs Online English School',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inglês ao vivo para quem quer falar de verdade',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 36),
                        _DialogButton('Aula de inglês ao vivo', () {
                          Navigator.pop(context);
                        }),
                        const SizedBox(height: 16),
                        _DialogButton('Curso de inglês para viagem', () {
                          Navigator.pop(context);
                        }),
                        const SizedBox(height: 16),
                        _DialogButton('Planner de inglês online', () {
                          launchUrlString(
                            "https://hotm.art/plannerdeingles",
                            mode: LaunchMode.externalApplication,
                          );
                        }),
                        const SizedBox(height: 16),
                        _DialogButton('Spotify Dibs', () {
                          launchUrlString(
                            "https://open.spotify.com/playlist/591Anp20c5C2So0EY6dIJn?si=1Ig5xaiNRlCqy2bczKAZHg",
                            mode: LaunchMode.externalApplication,
                          );
                        }),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Container(
          margin: padding,
          child:
              isMobile ? _buildMobileLayout() : _buildDesktopLayout(isTablet),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 180,
              child: SvgPicture.asset(
                "assets/icons/dibs.svg",
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Sua fluência em inglês começa aqui.',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 36, tablet: 40, desktop: 60),
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              height: 1,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: .4),
                  offset: const Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nos diga como prefere aprender e nós te conectamos com a turma certa para você.',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                  mobile: 16, tablet: 17, desktop: 18),
              color: AppColor.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          Text('Qual é o seu nome?',
              style: GoogleFonts.montserrat(fontSize: 16)),
          const SizedBox(height: 8),
          Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFa6b5c7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) {
                    setState(() => _isFilled = v.trim().isNotEmpty);
                    widget.cadastro.nome = v;
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (_isFilled) widget.onNext();
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    fixedSize: const Size.fromHeight(60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isFilled ? widget.onNext : null,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Encontrar turma ideal',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Icon(Icons.arrow_forward, size: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sua fluência em inglês\ncomeça aqui.',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 36, tablet: 40, desktop: 60),
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: .4),
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nos diga como prefere aprender e nós te conectamos com a turma certa para você.',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 16, tablet: 17, desktop: 18),
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              Text('Qual é o seu nome?',
                  style: GoogleFonts.montserrat(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFa6b5c7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controller,
                        onChanged: (v) {
                          setState(() => _isFilled = v.trim().isNotEmpty);
                          widget.cadastro.nome = v;
                        },
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) {
                          if (_isFilled) widget.onNext();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      fixedSize: const Size.fromHeight(60),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isFilled ? widget.onNext : null,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Encontrar turma ideal',
                            style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.arrow_forward, size: isTablet ? 22 : 25),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(64),
        SizedBox(
          width: 200,
          child: SvgPicture.asset(
            "assets/icons/dibs.svg",
          ),
        ),
      ],
    );
  }
}

// Segunda tela: metodologia
class _TelaMetodologia extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaMetodologia({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              margin: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    isMobile
                        ? 'Na Dibs, aprender inglês não é sobre decorar regras ou repetir frases prontas.'
                        : 'Na Dibs, aprender inglês não é sobre\ndecorar regras ou repetir frases prontas.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.montserrat(
                      height: 1,
                      fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 36,
                        desktop: 48,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  StyledText(
                    text: isMobile
                        ? 'É sobre conversar de verdade, entender o outro e se expressar sem medo. Nossa metodologia foge do ensino tradicional e ajuda você a se comunicar com segurança. Por isso, nossas aulas são <b>ONLINE</b> e <b>AO VIVO</b>.'
                        : 'É sobre conversar de verdade, entender o outro e se expressar sem medo.\nNossa metodologia foge do ensino tradicional e ajuda você a se comunicar com segurança.\nPor isso, nossas aulas são <b>ONLINE</b> e <b>AO VIVO</b>.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.montserrat(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                          mobile: 18, tablet: 24, desktop: 30),
                      height: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    tags: {
                      'b': StyledTextTag(
                        style: GoogleFonts.montserrat(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              mobile: 16,
                              tablet: 20,
                              desktop: 24),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    },
                  ),
                  SizedBox(height: isMobile ? 40 : 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isMobile
                          ? Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF9845),
                                  fixedSize: Size(
                                      isMobile
                                          ? double.infinity
                                          : (isTablet ? 350 : 400),
                                      60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: onNext,
                                child: Text(
                                  'CONTINUAR',
                                  style: GoogleFonts.montserrat(
                                    fontSize:
                                        ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            mobile: 18,
                                            tablet: 19,
                                            desktop: 20),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9845),
                                fixedSize: Size(
                                    isMobile
                                        ? double.infinity
                                        : (isTablet ? 350 : 400),
                                    60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: onNext,
                              child: Text(
                                'CONTINUAR',
                                style: GoogleFonts.montserrat(
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                          context,
                                          mobile: 18,
                                          tablet: 19,
                                          desktop: 20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        TopLeftBackButton(onBack: onBack),
      ],
    );
  }
}

// Terceira tela: estrutura completa
class _TelaEstrutura extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaEstrutura({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              margin: padding,
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Aqui você conta com uma estrutura completa',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              LottiesAsset.lottie1,
              fit: BoxFit.fill,
              addRepaintBoundary: true,
            ),
          ),
          // const SizedBox(height: 32),
          Text(
            'Você terá acesso a:',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 26, desktop: 30),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _beneficio(
            '📚 20 aulas por nível',
            'Estrutura clara para evoluir com segurança.',
          ),
          _beneficio(
            '🗂️ Materiais em PDF',
            'Conteúdo prático para estudar onde quiser.',
          ),
          _beneficio(
            '📅 Planner de estudos online',
            'Organização simples e eficaz para sua rotina.',
          ),
          _beneficio(
            '🌐 Atividades extras na sala virtual',
            'Exercícios para reforçar seu aprendizado.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9845),
                fixedSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onNext,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Aqui você conta com uma estrutura completa',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 40),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: isTablet ? 350 : 400,
                  height: isTablet ? 350 : 400,
                  child: Lottie.asset(
                    LottiesAsset.lottie1,
                    fit: BoxFit.fill,
                    addRepaintBoundary: true,
                  ),
                ),
              ],
            ),
          ),
          Gap(isTablet ? 48 : 64),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(isTablet ? 24 : 32),
                Text(
                  'Você terá acesso a:',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 26,
                        desktop: 30),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                _beneficio(
                  '📚 20 aulas por nível',
                  'Estrutura clara para evoluir com segurança.',
                ),
                _beneficio(
                  '🗂️ Materiais em PDF',
                  'Conteúdo prático para estudar onde quiser.',
                ),
                _beneficio(
                  '📅 Planner de estudos online',
                  'Organização simples e eficaz para sua rotina.',
                ),
                _beneficio(
                  '🌐 Atividades extras na sala virtual',
                  'Exercícios para reforçar seu aprendizado.',
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9845),
                          fixedSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: onNext,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _beneficio(String titulo, String subtitulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitulo,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Quarta tela: motivação responsiva
class _TelaMotivacao extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaMotivacao(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaMotivacao> createState() => _TelaMotivacaoState();
}

class _TelaMotivacaoState extends State<_TelaMotivacao> {
  int? _selected;
  final List<String> opcoes = [
    'Viagem',
    'Hobby',
    'Carreira e Negócios',
    'Exame de proficiência',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.motivacao?.isNotEmpty ?? false) {
      _selected = opcoes.indexOf(widget.cadastro.motivacao!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Você tem um motivo, nós temos o caminho',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 36, desktop: 48),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie5,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          const Gap(16),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 1 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Qual é a sua motivação?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(opcoes.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.motivacao = opcoes[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustração
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Você tem um motivo, nós temos o caminho',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 32,
                        tablet: 36,
                        desktop: 48),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 64),
                Center(
                  child: SizedBox(
                    width: isTablet ? 350 : 400,
                    height: isTablet ? 350 : 400,
                    child: Lottie.asset(
                      LottiesAsset.lottie5,
                      fit: BoxFit.fill,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 32 : 48),
          // Formulário
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progresso
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var width = constraints.maxWidth;
                            return Container(
                              width: width * 1 / 7,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFFF9845),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Qual é a sua motivação?',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(opcoes.length, (i) => _opcao(i)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFFF9845),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _selected != null
                            ? () {
                                widget.cadastro.motivacao = opcoes[_selected!];
                                widget.onNext();
                              }
                            : null,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 16.0),
      child: InkWell(
        onTap: () => setState(() => _selected = i),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isMobile ? 8 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  opcoes[i],
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 18 : 24,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quinta tela: experiência prévia responsiva
class _TelaExperiencia extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaExperiencia(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaExperiencia> createState() => _TelaExperienciaState();
}

class _TelaExperienciaState extends State<_TelaExperiencia> {
  int? _selected;
  final List<String> opcoes = [
    'Nunca estudei',
    'Sim, mas parei',
    'Estou estudando no momento',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.experiencia?.isNotEmpty ?? false) {
      _selected = opcoes.indexOf(widget.cadastro.experiencia!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            'Toda experiência conta, e a gente respeita a sua',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie6,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 2 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Já estudou inglês antes?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(opcoes.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.experiencia = opcoes[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustração
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Toda experiência conta, e a gente respeita a sua',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 40),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: isTablet ? 350 : 400,
                    height: isTablet ? 350 : 400,
                    child: Lottie.asset(
                      LottiesAsset.lottie6,
                      fit: BoxFit.fill,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 32 : 48),
          // Formulário
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progresso
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var width = constraints.maxWidth;
                            return Container(
                              width: width * 2 / 7,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFFF9845),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Já estudou inglês antes?',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(opcoes.length, (i) => _opcao(i)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFFF9845),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _selected != null
                            ? () {
                                widget.cadastro.experiencia =
                                    opcoes[_selected!];
                                widget.onNext();
                              }
                            : null,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 16.0),
      child: InkWell(
        onTap: () => setState(() => _selected = i),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isMobile ? 8 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  opcoes[i],
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 18 : 24,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sexta tela: nível de conversação responsiva
class _TelaNivel extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaNivel(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaNivel> createState() => _TelaNivelState();
}

class _TelaNivelState extends State<_TelaNivel> {
  int? _selected;
  final List<String> opcoes = [
    'Básico',
    'Intermediário',
    'Avançado',
    'Não sei meu nível',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.nivel?.isNotEmpty ?? false) {
      _selected = opcoes.indexOf(widget.cadastro.nivel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Qual é o seu nível de conversação?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie3,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 3 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Qual é o seu nível de conversação?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(opcoes.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.nivel = opcoes[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustração
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Qual é o seu nível de conversação?',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 40),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: isTablet ? 350 : 400,
                    height: isTablet ? 350 : 400,
                    child: Lottie.asset(
                      LottiesAsset.lottie3,
                      fit: BoxFit.fill,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 32 : 48),
          // Formulário
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progresso
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var width = constraints.maxWidth;
                            return Container(
                              width: width * 3 / 7,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFFF9845),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Qual é o seu nível de conversação?',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(opcoes.length, (i) => _opcao(i)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFFF9845),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _selected != null
                            ? () {
                                widget.cadastro.nivel = opcoes[_selected!];
                                widget.onNext();
                              }
                            : null,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 16.0),
      child: InkWell(
        onTap: () {
          setState(() => _selected = i);
          if ("Não sei meu nível" == opcoes[i]) {
            showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: isMobile ? double.infinity : 600,
                      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Vamos marcar seu teste de nível?',
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'É uma conversa de 30 minutos com um dos nossos teachers — 100% ao vivo e online — só para avaliarmos seu nível de conversação.',
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '🔹 O teste é gratuito após a matrícula.\n🔹 Quer fazer antes? Sem problema! A taxa é de R\$60,00.\nMas se você se matricular em até 7 dias, devolvemos esse valor.',
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'FECHAR',
                                style: GoogleFonts.montserrat(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isMobile ? 8 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  opcoes[i],
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 18 : 24,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sétima tela: dificuldade responsiva
class _TelaDificuldade extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaDificuldade(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaDificuldade> createState() => _TelaDificuldadeState();
}

class _TelaDificuldadeState extends State<_TelaDificuldade> {
  int? _selected;
  final List<String> opcoes = [
    'Fico inseguro com a pronúncia',
    'Tenho vergonha de errar',
    'Faltam palavras na hora de falar',
    'Não tenho dificuldade',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.dificuldade?.isNotEmpty ?? false) {
      _selected = opcoes.indexOf(widget.cadastro.dificuldade!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Falar em inglês é difícil para você? A gente facilita',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie2,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 4 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Qual é a sua dificuldade?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(opcoes.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.dificuldade = opcoes[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustração
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Falar em inglês é difícil para você? A gente facilita',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 40),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    height: 400,
                    child: Lottie.asset(
                      LottiesAsset.lottie2,
                      fit: BoxFit.fill,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 32 : 48),
          // Formulário
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progresso
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var width = constraints.maxWidth;
                            return Container(
                              width: width * 4 / 7,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFFF9845),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Qual é a sua dificuldade?',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(opcoes.length, (i) => _opcao(i)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFFF9845),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _selected != null
                            ? () {
                                widget.cadastro.dificuldade =
                                    opcoes[_selected!];
                                widget.onNext();
                              }
                            : null,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 8 : 16.0),
      child: InkWell(
        onTap: () => setState(() => _selected = i),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isMobile ? 8 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  opcoes[i],
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 18 : 24,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Oitava tela: escolha a modalidade responsiva
class _TelaModalidade extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaModalidade(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaModalidade> createState() => _TelaModalidadeState();
}

class _TelaModalidadeState extends State<_TelaModalidade> {
  int? _selected;
  final List<String> titulos = [
    'Aula em Grupo (máx. 4 pessoas)',
    'Aula em Dupla',
    'Aula Individual',
  ];
  final List<String> valores = [
    'A partir de R\$ 447,99',
    'A partir de R\$ 895,98',
    'A partir de R\$ 1.791,96',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.modalidade?.isNotEmpty ?? false) {
      _selected = titulos.indexOf(widget.cadastro.modalidade!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Aqui, o inglês se adapta a sua vida, e não o contrário',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 36),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie7,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 5 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Escolha a modalidade',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 26, desktop: 28),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(titulos.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.modalidade = titulos[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aqui, o inglês se adapta a sua vida, e não o contrário',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 28, tablet: 32, desktop: 36),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  height: 400,
                  child: Lottie.asset(
                    LottiesAsset.lottie7,
                    fit: BoxFit.fill,
                    addRepaintBoundary: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isTablet ? 32 : 48),
        // Formulário
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra de progresso
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          var width = constraints.maxWidth;
                          return Container(
                            width: width * 5 / 7,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFFF9845),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Escolha a modalidade',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 24, tablet: 26, desktop: 28),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(titulos.length, (i) => _opcao(i)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9845),
                        fixedSize: const Size.fromHeight(60),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _selected != null
                          ? () {
                              widget.cadastro.modalidade = titulos[_selected!];
                              widget.onNext();
                            }
                          : null,
                      child: Text(
                        'CONTINUAR',
                        style: GoogleFonts.montserrat(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              mobile: 18,
                              tablet: 19,
                              desktop: 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _opcao(int i) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => setState(() => _selected = i),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 8, vertical: isMobile ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMobile
                        ? titulos[i].replaceFirst("máx. ", "")
                        : titulos[i],
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    valores[i],
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nona tela: escolha o plano responsiva
class _TelaPlano extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaPlano(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaPlano> createState() => _TelaPlanoState();
}

class _TelaPlanoState extends State<_TelaPlano> {
  int? _selected;
  // Por enquanto, valores fixos. Depois, tornar dinâmico conforme modalidade.
  final List<String> titulos = [
    'Aulas 1x na semana',
    'Aulas 2x na semana',
    'Aulas 5x na semana',
  ];
  final List<String> legendas = [
    'Você conclui o nível em 5 meses',
    'Você conclui o nível em 3 meses',
    'Você conclui o nível em 1 mês',
  ];
  final List<List<String>> valores = [
    [
      'Parcelas de R\$ 447,99',
      'Parcelas de R\$ 746,65',
      'R\$ 2.239,95 ou 5x de R\$ 447,99',
    ],
    [
      'Parcelas de R\$ 895,98',
      'Parcelas de R\$ 1.493,30',
      'R\$ 4.479,90 ou 5x de R\$ 895,98',
    ],
    [
      'Parcelas de R\$ 1.791,96',
      'Parcelas de R\$ 2.986,60',
      'R\$ 8.959,80 ou 5x de R\$ 1.791,96',
    ],
  ];

  final List<String> modalidades = [
    'Aula em Grupo (máx. 4 pessoas)',
    'Aula em Dupla',
    'Aula Individual',
  ];

  int get modalidadeIndex => modalidades.indexOf(widget.cadastro.modalidade!);

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.plano?.isNotEmpty ?? false) {
      _selected = titulos.indexOf(widget.cadastro.plano!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cada formato tem seu valor. E todos funcionam',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 40),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie8,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 6 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Escolha o plano',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(titulos.length, (i) => _opcao(i)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _selected != null
                  ? () {
                      widget.cadastro.plano = titulos[_selected!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ilustração
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cada formato tem seu valor. E todos funcionam',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 40),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: isTablet ? 350 : 400,
                    height: isTablet ? 350 : 400,
                    child: Lottie.asset(
                      LottiesAsset.lottie8,
                      fit: BoxFit.fill,
                      addRepaintBoundary: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 32 : 48),
          // Formulário
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progresso
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var width = constraints.maxWidth;
                            return Container(
                              width: width * 6 / 7,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFFF9845),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Escolha o plano',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(titulos.length, (i) => _opcao(i)),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(60),
                          backgroundColor: const Color(0xFFFF9845),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _selected != null
                            ? () {
                                widget.cadastro.plano = titulos[_selected!];
                                widget.onNext();
                              }
                            : null,
                        child: Text(
                          'CONTINUAR',
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 18,
                                tablet: 19,
                                desktop: 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => setState(() => _selected = i),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: _selected == i
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          titulos[i],
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          legendas[i],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            valores[modalidadeIndex][i],
                            style: GoogleFonts.montserrat(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                _selected == i
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Décima tela: disponibilidade responsiva
class _TelaDisponibilidade extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TelaDisponibilidade(
      {required this.cadastro, required this.onNext, required this.onBack});

  @override
  State<_TelaDisponibilidade> createState() => _TelaDisponibilidadeState();
}

class _TelaDisponibilidadeState extends State<_TelaDisponibilidade> {
  final List<String> dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
  final List<String> periodos = ['Manhã', 'Tarde', 'Noite'];
  final List<String> localizacoes = ['Brasil', 'Exterior'];

  final Set<int> diasSelecionados = {};
  int? periodoSelecionado;
  int? localSelecionado;

  bool get podeContinuar {
    switch (widget.cadastro.plano) {
      case "Aulas 1x na semana":
        return diasSelecionados.isNotEmpty &&
            periodoSelecionado != null &&
            localSelecionado != null;
      case "Aulas 2x na semana":
        return diasSelecionados.length == 2 &&
            periodoSelecionado != null &&
            localSelecionado != null;
      case "Aulas 5x na semana":
        return diasSelecionados.length == 5 &&
            periodoSelecionado != null &&
            localSelecionado != null;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.cadastro.dias.isNotEmpty) {
      diasSelecionados.addAll(widget.cadastro.dias.map((e) => dias.indexOf(e)));
    }
    if (widget.cadastro.periodo?.isNotEmpty ?? false) {
      periodoSelecionado = periodos.indexOf(widget.cadastro.periodo!);
    }
    if (widget.cadastro.localizacao?.isNotEmpty ?? false) {
      localSelecionado = localizacoes.indexOf(widget.cadastro.localizacao!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nos diga o que funciona melhor pra você',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 28, tablet: 32, desktop: 36),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                LottiesAsset.lottie9,
                fit: BoxFit.fill,
                addRepaintBoundary: true,
              ),
            ),
          ),
          // Barra de progresso
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var width = constraints.maxWidth;
                      return Container(
                        width: width * 7 / 7,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFF9845),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Quando você pode?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                  mobile: 24, tablet: 28, desktop: 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nossas aulas têm duração de 1h30 e seguem o fuso horário de Brasília (Brasil).',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                  mobile: 12, tablet: 13, desktop: 14),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dias',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                  mobile: 16, tablet: 17, desktop: 18),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(dias.length, (i) => _chipDia(i)),
          ),
          const SizedBox(height: 16),
          Text(
            'Períodos',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                  mobile: 16, tablet: 17, desktop: 18),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(periodos.length, (i) => _chipPeriodo(i)),
          ),
          const SizedBox(height: 16),
          Text(
            'Onde você está no momento?',
            style: GoogleFonts.montserrat(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                  mobile: 16, tablet: 17, desktop: 18),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(localizacoes.length, (i) => _chipLocal(i)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(40),
                backgroundColor: const Color(0xFFFF9845),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: podeContinuar
                  ? () {
                      widget.cadastro.dias =
                          diasSelecionados.map((i) => dias[i]).toList();
                      widget.cadastro.periodo = periodos[periodoSelecionado!];
                      widget.cadastro.localizacao =
                          localizacoes[localSelecionado!];
                      widget.onNext();
                    }
                  : null,
              child: Text(
                'CONTINUAR',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 18, tablet: 19, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ilustração
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nos diga o que funciona melhor pra você',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 28, tablet: 32, desktop: 36),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: isTablet ? 350 : 400,
                  height: isTablet ? 350 : 400,
                  child: Lottie.asset(
                    LottiesAsset.lottie9,
                    fit: BoxFit.fill,
                    addRepaintBoundary: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isTablet ? 32 : 48),
        // Formulário
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de progresso
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          var width = constraints.maxWidth;
                          return Container(
                            width: width * 7 / 7,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFFF9845),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Quando você pode?',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 24, tablet: 28, desktop: 32),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nossas aulas têm duração de 1h30 e seguem o fuso horário de Brasília (Brasil).',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 12, tablet: 13, desktop: 14),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Dias',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 16, tablet: 17, desktop: 18),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(dias.length, (i) => _chipDia(i)),
              ),
              const SizedBox(height: 20),
              Text(
                'Períodos',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 16, tablet: 17, desktop: 18),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List.generate(periodos.length, (i) => _chipPeriodo(i)),
              ),
              const SizedBox(height: 20),
              Text(
                'Onde você está no momento?',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 16, tablet: 17, desktop: 18),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List.generate(localizacoes.length, (i) => _chipLocal(i)),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9845),
                        fixedSize: const Size.fromHeight(60),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: podeContinuar
                          ? () {
                              widget.cadastro.dias =
                                  diasSelecionados.map((i) => dias[i]).toList();
                              widget.cadastro.periodo =
                                  periodos[periodoSelecionado!];
                              widget.cadastro.localizacao =
                                  localizacoes[localSelecionado!];
                              widget.onNext();
                            }
                          : null,
                      child: Text(
                        'CONTINUAR',
                        style: GoogleFonts.montserrat(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              mobile: 18,
                              tablet: 19,
                              desktop: 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chipDia(int i) {
    final selecionado = diasSelecionados.contains(i);
    return ChoiceChip(
      label: Text(
        dias[i],
        style: GoogleFonts.montserrat(
          color: selecionado ? AppColor.primary : Colors.white,
          fontSize: 20,
        ),
      ),
      selected: selecionado,
      selectedColor: Colors.white,
      backgroundColor: AppColor.primary,
      side: const BorderSide(color: Colors.white, width: 2),
      onSelected: (v) => setState(() {
        if (v) {
          switch (widget.cadastro.plano) {
            case "Aulas 1x na semana":
              if (diasSelecionados.isEmpty) {
                diasSelecionados.add(i);
              }
              break;
            case "Aulas 2x na semana":
              if (diasSelecionados.length <= 1) {
                diasSelecionados.add(i);
              }
              break;
            case "Aulas 5x na semana":
              if (diasSelecionados.length <= 4) {
                diasSelecionados.add(i);
              }
              break;
            default:
          }
        } else {
          diasSelecionados.remove(i);
        }
      }),
    );
  }

  Widget _chipPeriodo(int i) {
    final selecionado = periodoSelecionado == i;
    return ChoiceChip(
      label: Text(
        periodos[i],
        style: GoogleFonts.montserrat(
          color: selecionado ? AppColor.primary : Colors.white,
          fontSize: 20,
        ),
      ),
      selected: selecionado,
      selectedColor: Colors.white,
      backgroundColor: AppColor.primary,
      side: const BorderSide(color: Colors.white, width: 2),
      onSelected: (v) => setState(() => periodoSelecionado = v ? i : null),
    );
  }

  Widget _chipLocal(int i) {
    final selecionado = localSelecionado == i;
    return ChoiceChip(
      label: Text(
        localizacoes[i],
        style: GoogleFonts.montserrat(
          color: selecionado ? AppColor.primary : Colors.white,
          fontSize: 20,
        ),
      ),
      selected: selecionado,
      selectedColor: Colors.white,
      backgroundColor: AppColor.primary,
      side: const BorderSide(color: Colors.white, width: 2),
      onSelected: (v) => setState(() => localSelecionado = v ? i : null),
    );
  }
}

// Tela final: plano ideal e finalizar matrícula responsiva
class _TelaFinal extends StatefulWidget {
  final CadastroDibs cadastro;
  final VoidCallback onBack;
  const _TelaFinal({required this.cadastro, required this.onBack});

  @override
  State<_TelaFinal> createState() => _TelaFinalState();
}

class _TelaFinalState extends State<_TelaFinal> {
  late ConfettiController _controllerConfetti;

  void _abrirWhatsapp(BuildContext context) async {
    final mensagem = Uri.encodeComponent(widget.cadastro.toWhatsappMessage());
    final url = 'https://wa.me/5594984068284?text=$mensagem';
    await launchUrl(Uri.parse(url));
  }

  @override
  void initState() {
    super.initState();
    _controllerConfetti = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _controllerConfetti.play();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return Stack(
      children: [
        Container(
          color: AppColor.primary,
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: isMobile ? double.infinity : 660,
              ),
              height: double.infinity,
              margin: padding,
              padding: EdgeInsets.only(top: isMobile ? 32 : 0),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context, isTablet),
            ),
          ),
        ),
        TopLeftBackButton(onBack: widget.onBack),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerConfetti,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: .01,
            gravity: .5,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pronto, encontramos o seu plano ideal',
              style: GoogleFonts.montserrat(
                fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                    mobile: 32, tablet: 40, desktop: 52),
                height: 1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "${widget.cadastro.modalidade?.split('(').firstOrNull ?? ''} - ${widget.cadastro.plano?.toLowerCase().replaceFirst("aulas ", "")}",
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                        mobile: 16, tablet: 18, desktop: 22),
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Agora é só dar o próximo passo. O nosso time já está pronto para receber você! ✨',
              style: GoogleFonts.montserrat(
                fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                    mobile: 20, tablet: 24, desktop: 32),
                height: 1.3,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9845),
                  fixedSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _abrirWhatsapp(context),
                child: Text(
                  'FINALIZAR MATRÍCULA',
                  style: GoogleFonts.montserrat(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                        mobile: 18, tablet: 20, desktop: 24),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  LottiesAsset.lottie4,
                  fit: BoxFit.fill,
                  addRepaintBoundary: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pronto, encontramos o seu plano ideal',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 32, tablet: 40, desktop: 52),
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.cadastro.modalidade?.split('(').firstOrNull ?? ''} - ${widget.cadastro.plano?.toLowerCase().replaceFirst("aulas ", "")}",
                          style: GoogleFonts.montserrat(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 22),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text(
                'Agora é só dar o próximo passo. O nosso time já está pronto para receber você! ✨',
                style: GoogleFonts.montserrat(
                  fontSize: ResponsiveUtils.getResponsiveTitleFontSize(context,
                      mobile: 20, tablet: 24, desktop: 32),
                  height: 1.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9845),
                        fixedSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _abrirWhatsapp(context),
                      child: Text(
                        'FINALIZAR MATRÍCULA',
                        style: GoogleFonts.montserrat(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              mobile: 18,
                              tablet: 20,
                              desktop: 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Gap(isTablet ? 24 : 32),
        Expanded(
          child: Lottie.asset(
            LottiesAsset.lottie4,
            fit: BoxFit.fill,
            addRepaintBoundary: true,
          ),
        )
      ],
    );
  }
}

// Classe para armazenar todas as respostas do funil
class CadastroDibs {
  String nome = '';
  String? motivacao;
  String? experiencia;
  String? nivel;
  String? dificuldade;
  String? modalidade;
  String? plano;
  List<String> dias = [];
  String? periodo;
  String? localizacao;

  CadastroDibs();

  String toWhatsappMessage() {
    return '''
Nome: $nome
Motivação: $motivacao
Experiência: $experiencia
Nível: $nivel
Dificuldade: $dificuldade
Modalidade: $modalidade
Plano: $plano
Dias disponíveis: ${dias.join(", ")}
Período: $periodo
Localização: $localizacao
''';
  }
}

// Adicionar widget auxiliar para os botões do dialog
class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _DialogButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 1.5),
          foregroundColor: Colors.white,
          textStyle:
              GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
