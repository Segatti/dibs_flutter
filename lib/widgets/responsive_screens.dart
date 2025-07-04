import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:styled_text/styled_text.dart';

import '../app_color.dart';
import '../models/lotties_asset.dart';

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

// Tela de metodologia responsiva
class ResponsiveMetodologiaScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResponsiveMetodologiaScreen({
    required this.onNext,
    required this.onBack,
    super.key,
  });

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
                    'Na Dibs, aprender inglês não é sobre\ndecorar regras ou repetir frases prontas.',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.montserrat(
                      height: 1,
                      fontSize: ResponsiveUtils.getResponsiveTitleFontSize(
                          context,
                          mobile: 28,
                          tablet: 36,
                          desktop: 48),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  StyledText(
                    text:
                        'É sobre conversar de verdade, entender o outro e se expressar sem medo.\nNossa metodologia foge do ensino tradicional e ajuda você a se comunicar com segurança.\nPor isso, nossas aulas são <b>ONLINE</b> e <b>AO VIVO</b>.',
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
                      ElevatedButton(
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

// Tela de estrutura responsiva
class ResponsiveEstruturaScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResponsiveEstruturaScreen({
    required this.onNext,
    required this.onBack,
    super.key,
  });

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
    return Column(
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
        const SizedBox(height: 32),
        SizedBox(
          width: 300,
          height: 300,
          child: Lottie.asset(
            LottiesAsset.lottie1,
            fit: BoxFit.fill,
            addRepaintBoundary: true,
          ),
        ),
        const SizedBox(height: 32),
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
        const SizedBox(height: 32),
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
          SizedBox(width: isTablet ? 48 : 64),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: isTablet ? 24 : 32),
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
          const SizedBox(height: 4),
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
