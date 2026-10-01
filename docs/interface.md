# Regras Oficiais do Projeto Flutter Material Design 3

Este documento define as regras oficiais para criação de telas, componentes visuais, navegação, temas, espaçamentos e padrões de interface deste projeto Flutter.

Ele deve ser usado como uma **constituição visual do projeto** por desenvolvedores, revisores de código e ferramentas de IA/Codex. O objetivo é garantir que todas as interfaces sejam consistentes, manuteníveis, responsivas e alinhadas ao **Flutter Material Design 3**.

---

## 1. Objetivo do documento

Este projeto deve seguir exclusivamente o **Material Design 3** por meio dos componentes nativos do Flutter Material.

Sempre que existir um componente oficial do Flutter Material para resolver uma necessidade visual, ele deve ser usado antes de qualquer implementação customizada.

Este documento orienta:

* geração de código por IA/Codex;
* revisão de código visual;
* criação de novas telas;
* manutenção de telas existentes;
* padronização de tema, cores, tipografia e espaçamentos;
* decisões sobre responsividade;
* prevenção de design system paralelo.

---

## 2. Princípios gerais

### 2.1. Material primeiro

Toda decisão visual deve começar pela pergunta:

> Existe um componente nativo do Flutter Material que resolve este caso?

Se a resposta for sim, o componente Material deve ser usado.

Exemplos:

* botão → `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton` ou `FloatingActionButton`;
* card → `Card`, `Card.filled` ou `Card.outlined`;
* campo de texto → `TextField`;
* item de lista → `ListTile`;
* navegação inferior → `NavigationBar`;
* navegação lateral → `NavigationRail` ou `NavigationDrawer`;
* alerta modal → `AlertDialog` ou `Dialog`;
* ação temporária → `SnackBar`;
* seleção segmentada → `SegmentedButton`.

### 2.2. Tema antes de estilo local

A aparência da aplicação deve ser definida principalmente em:

* `ThemeData`;
* `ColorScheme`;
* `TextTheme`;
* `ThemeExtension`;
* tokens próprios do projeto.

As telas não devem decidir cores, tipografia, formatos, elevações e espaçamentos de forma isolada.

### 2.3. Consistência acima de criatividade visual

A interface deve parecer parte de um único produto. Evite criar variações visuais desnecessárias para botões, cards, inputs, navegação ou feedback.

Quando houver dúvida entre uma solução customizada visualmente interessante e uma solução Material nativa, escolha a solução Material nativa.

### 2.4. Customização somente com justificativa

Componentes customizados são permitidos apenas quando:

1. não existir equivalente nativo no Flutter Material;
2. o componente customizado for apenas uma composição de componentes Material;
3. houver uma necessidade técnica clara;
4. a decisão estiver documentada no código ou no pull request.

---

## 3. Uso obrigatório de Material Design 3

O projeto deve usar `MaterialApp` com tema centralizado e Material Design 3 habilitado explicitamente.

Mesmo que versões recentes do Flutter já adotem Material 3 por padrão, este projeto deve declarar `useMaterial3: true` para deixar a intenção arquitetural explícita.

### Exemplo base obrigatório

```dart
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

### Regras obrigatórias

* O projeto deve usar `MaterialApp`.
* O tema claro deve estar centralizado em `AppTheme.light` ou equivalente.
* O tema escuro deve estar centralizado em `AppTheme.dark` ou equivalente.
* O app deve respeitar `themeMode: ThemeMode.system`, salvo necessidade específica documentada.
* Todo componente visual deve seguir os padrões oficiais do Material Design 3.
* Nenhuma tela deve criar um design system paralelo ao `ThemeData`.

### Exemplo de estrutura mínima de tema

```dart
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: Typography.material2021().black,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: Typography.material2021().white,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
```

---

## 4. Prioridade para widgets nativos do Flutter Material

Sempre use componentes nativos do Flutter Material quando existirem.

### Componentes prioritários

#### Estrutura de tela

* `Scaffold`
* `AppBar`
* `SliverAppBar`
* `SafeArea`
* `BottomAppBar`

#### Navegação

* `NavigationBar`
* `NavigationRail`
* `NavigationDrawer`
* `Drawer`
* `TabBar`
* `TabBarView`

#### Botões e ações

* `FilledButton`
* `FilledButton.tonal`
* `OutlinedButton`
* `TextButton`
* `ElevatedButton`, quando houver justificativa visual
* `IconButton`
* `FloatingActionButton`
* `FloatingActionButton.extended`
* `PopupMenuButton`, quando adequado
* `MenuAnchor`, especialmente para menus Material 3

#### Conteúdo e superfícies

* `Card`
* `Card.filled`
* `Card.outlined`
* `ListTile`
* `Divider`
* `VerticalDivider`
* `Badge`
* `Chip`
* `ActionChip`
* `FilterChip`
* `ChoiceChip`
* `InputChip`

#### Formulários e seleção

* `TextField`
* `TextFormField`
* `Checkbox`
* `Radio`
* `Switch`
* `Slider`
* `DropdownMenu`
* `SegmentedButton`
* `SearchBar`
* `showDatePicker`
* `showTimePicker`

#### Feedback e sobreposição

* `SnackBar`
* `AlertDialog`
* `Dialog`
* `BottomSheet`
* `showModalBottomSheet`
* `CircularProgressIndicator`
* `LinearProgressIndicator`
* `Tooltip`

---

## 5. Proibição de componentes visuais desnecessariamente customizados

Não crie manualmente componentes visuais quando houver equivalente oficial no Flutter Material.

### É proibido criar manualmente, sem justificativa

* botões customizados;
* cards customizados;
* campos de texto customizados;
* barras de navegação customizadas;
* menus customizados;
* dialogs customizados;
* bottom sheets customizados;
* listas customizadas;
* chips customizados;
* switches customizados;
* sliders customizados;
* checkboxes customizados;
* radios customizados.

### Exemplo incorreto: botão feito com `GestureDetector` e `Container`

```dart
GestureDetector(
  onTap: onPressed,
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text('Salvar'),
  ),
);
```

Problemas:

* ignora estilos do tema;
* não respeita estados Material, como hover, focus, pressed e disabled;
* não usa acessibilidade padrão;
* cria comportamento visual inconsistente;
* dificulta manutenção;
* duplica funcionalidade já existente.

### Exemplo correto: botão Material

```dart
FilledButton(
  onPressed: onPressed,
  child: const Text('Salvar'),
);
```

### Exemplo incorreto: card manual

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 12,
      ),
    ],
  ),
  child: const Text('Resumo'),
);
```

### Exemplo correto: card Material

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Text(
      'Resumo',
      style: Theme.of(context).textTheme.titleMedium,
    ),
  ),
);
```

### Exemplo correto: variações Material 3 de card

```dart
Card.filled(
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Text(
      'Informação importante',
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  ),
);
```

```dart
Card.outlined(
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Text(
      'Detalhes adicionais',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  ),
);
```

---

## 6. Proibição de Cupertino widgets

Não use widgets do pacote Cupertino, exceto se o usuário pedir explicitamente ou se houver uma justificativa técnica documentada.

O projeto deve manter identidade visual consistente com Material Design 3, inclusive em iOS.

### Evitar

* `CupertinoButton`
* `CupertinoNavigationBar`
* `CupertinoPageScaffold`
* `CupertinoSwitch`
* `CupertinoTextField`
* `CupertinoAlertDialog`
* `CupertinoActivityIndicator`
* qualquer outro componente visual Cupertino

### Exemplo incorreto

```dart
CupertinoButton(
  onPressed: onPressed,
  child: const Text('Continuar'),
);
```

### Exemplo correto

```dart
FilledButton(
  onPressed: onPressed,
  child: const Text('Continuar'),
);
```

---

## 7. Proibição de bibliotecas visuais externas

Não use bibliotecas externas para substituir componentes oficiais do Material Design.

### Evitar bibliotecas que forneçam

* botões customizados;
* cards prontos com design próprio;
* kits visuais externos;
* sistemas de navegação visual alternativos;
* componentes que substituam `ThemeData`;
* componentes que substituam `ColorScheme`;
* componentes que substituam `TextTheme`;
* design systems paralelos ao Material.

### Permitido com critério

Bibliotecas externas podem ser usadas para funcionalidades que o Flutter Material não oferece nativamente, como:

* gráficos, usando obrigatoriamente o pacote `fl_chart` quando a tela exigir esse tipo de visualização;
* mapas;
* leitura de QR Code;
* câmera;
* permissões;
* autenticação;
* persistência local;
* comunicação HTTP;
* estado e injeção de dependência;
* internacionalização;
* animações específicas que não substituam componentes Material.

Mesmo nesses casos, a biblioteca externa deve respeitar o tema visual do projeto sempre que renderizar interface.

---

## 8. Tema centralizado

O tema deve centralizar obrigatoriamente:

* cores;
* tipografia;
* espaçamentos;
* formatos;
* bordas;
* elevações;
* estilos de botões;
* estilos de inputs;
* estilos de cards;
* estilos de navegação;
* estilos de dialogs;
* estilos de bottom sheets;
* estilos de snackbars;
* estilos de listas;
* estados visuais.

### APIs preferenciais

Use preferencialmente:

* `ThemeData`
* `ColorScheme`
* `TextTheme`
* `ThemeExtension`
* `AppBarTheme`
* `CardThemeData`
* `InputDecorationTheme`
* `FilledButtonThemeData`
* `OutlinedButtonThemeData`
* `TextButtonThemeData`
* `ElevatedButtonThemeData`, quando necessário
* `IconButtonThemeData`
* `FloatingActionButtonThemeData`
* `NavigationBarThemeData`
* `NavigationRailThemeData`
* `NavigationDrawerThemeData`
* `BottomAppBarTheme`
* `BottomSheetThemeData`
* `DialogThemeData`
* `SnackBarThemeData`
* `ListTileThemeData`
* `TabBarThemeData`
* `CheckboxThemeData`
* `RadioThemeData`
* `SwitchThemeData`
* `SliderThemeData`
* `ChipThemeData`

> Observação: para botões modernos do Material, prefira os temas específicos, como `FilledButtonThemeData`, `OutlinedButtonThemeData` e `TextButtonThemeData`. Evite depender de `ButtonThemeData` para novos componentes, pois ele está associado ao modelo antigo de botões.

### Exemplo de tema centralizado

```dart
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF6750A4);

  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 48),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      extensions: const [
        AppSemanticColors.light,
      ],
    );
  }
}
```

---

## 9. Proibição de cores diretas dentro das telas

Nunca defina cores diretamente dentro das telas, exceto em casos muito justificados.

### Evitar

```dart
Container(
  color: Colors.blue,
);
```

```dart
Text(
  'Erro',
  style: TextStyle(color: Colors.red),
);
```

```dart
Icon(
  Icons.warning,
  color: Colors.orange,
);
```

### Preferir `ColorScheme`

```dart
Container(
  color: Theme.of(context).colorScheme.primary,
);
```

```dart
Text(
  'Erro',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
);
```

```dart
Icon(
  Icons.warning,
  color: Theme.of(context).colorScheme.error,
);
```

### Preferir `ThemeExtension` para cores semânticas específicas

```dart
Container(
  color: context.appColors.warning,
);
```

### Origem permitida para cores

As cores devem vir de:

* `Theme.of(context).colorScheme`;
* `Theme.of(context).textTheme`;
* `ThemeExtension`;
* tokens próprios do projeto;
* componentes Material que já resolvem cor automaticamente pelo tema.

### Quando uma cor direta pode ser aceita

Uma cor direta só pode aparecer em tela quando:

1. for uma cor extremamente específica e isolada;
2. não fizer parte da identidade visual recorrente;
3. houver justificativa clara;
4. não prejudicar tema claro/escuro;
5. não criar padrão visual paralelo.

Mesmo nesses casos, prefira mover a cor para um token ou `ThemeExtension`.

---

## 10. Tokens de design

Tokens são valores centralizados que representam decisões visuais do produto.

Eles evitam valores mágicos espalhados pelas telas e tornam a interface mais consistente.

### O que deve virar token

* espaçamentos;
* raios de borda;
* tamanhos de ícones;
* alturas mínimas;
* larguras máximas;
* breakpoints;
* duração de animações;
* elevação;
* opacidade;
* margens;
* paddings;
* tamanhos de cards;
* tamanhos de botões;
* larguras de conteúdo.

### Exemplo: espaçamentos

```dart
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}
```

### Exemplo: raios de borda

```dart
abstract final class AppRadius {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}
```

### Exemplo: breakpoints

```dart
abstract final class AppBreakpoints {
  static const mobile = 0.0;
  static const tablet = 600.0;
  static const desktop = 1024.0;
  static const wide = 1440.0;
}
```

### Exemplo: tamanhos

```dart
abstract final class AppSizes {
  static const minButtonHeight = 48.0;
  static const minTouchTarget = 48.0;
  static const maxContentWidth = 1200.0;
  static const iconSm = 18.0;
  static const iconMd = 24.0;
  static const iconLg = 32.0;
}
```

### Exemplo: animações

```dart
abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);
}
```

---

## 11. Uso de `ColorScheme`

O projeto deve usar `ColorScheme` como base principal de cores.

Evite criar nomes soltos de cores que não tenham relação com o Material Design 3.

### Cores prioritárias

Use principalmente:

* `primary`
* `onPrimary`
* `primaryContainer`
* `onPrimaryContainer`
* `secondary`
* `onSecondary`
* `secondaryContainer`
* `onSecondaryContainer`
* `tertiary`
* `onTertiary`
* `tertiaryContainer`
* `onTertiaryContainer`
* `surface`
* `onSurface`
* `surfaceContainerLowest`
* `surfaceContainerLow`
* `surfaceContainer`
* `surfaceContainerHigh`
* `surfaceContainerHighest`
* `error`
* `onError`
* `errorContainer`
* `onErrorContainer`
* `outline`
* `outlineVariant`
* `scrim`
* `shadow`

### Exemplo correto

```dart
final colorScheme = Theme.of(context).colorScheme;

return Card.filled(
  color: colorScheme.surfaceContainerLow,
  child: Text(
    'Ocorrências recentes',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
  ),
);
```

### Exemplo incorreto

```dart
return Container(
  color: const Color(0xFFF5F5F5),
  child: const Text(
    'Ocorrências recentes',
    style: TextStyle(color: Color(0xFF222222)),
  ),
);
```

### Regra prática

Quando a cor representar função visual Material, use `ColorScheme`.

Quando a cor representar uma semântica de negócio que não existe no `ColorScheme`, use `ThemeExtension`.

---

## 12. Uso de `TextTheme`

Toda tipografia deve vir de `TextTheme`.

Evite definir manualmente `fontSize`, `fontWeight`, `letterSpacing`, `height` e `color` diretamente nas telas.

### Estilos prioritários

Use os estilos Material:

* `displayLarge`
* `displayMedium`
* `displaySmall`
* `headlineLarge`
* `headlineMedium`
* `headlineSmall`
* `titleLarge`
* `titleMedium`
* `titleSmall`
* `bodyLarge`
* `bodyMedium`
* `bodySmall`
* `labelLarge`
* `labelMedium`
* `labelSmall`

### Exemplo incorreto

```dart
Text(
  'Título',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
);
```

### Exemplo correto

```dart
Text(
  'Título',
  style: Theme.of(context).textTheme.headlineMedium,
);
```

### Exemplo correto com pequena adaptação

```dart
Text(
  'Alerta crítico',
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
);
```

### Regra para `copyWith`

O uso de `copyWith` é permitido quando for necessário alterar algo pontual, como cor semântica, alinhamento ou peso em um caso específico.

Mesmo assim, a base deve continuar sendo o `TextTheme`.

---

## 13. Uso de `ThemeExtension`

Quando o projeto precisar de tokens que não existem no `ThemeData`, use `ThemeExtension`.

### Casos recomendados

Use `ThemeExtension` para:

* cores semânticas, como sucesso, alerta e informação;
* espaçamentos próprios acessíveis pelo tema;
* estilos específicos de módulos;
* propriedades visuais específicas do produto;
* cores de prioridade, status ou severidade;
* tokens que precisam mudar entre tema claro e escuro.

### Exemplo: cores semânticas

```dart
import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  static const light = AppSemanticColors(
    success: Color(0xFF2E7D32),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFF9A825),
    onWarning: Color(0xFF1C1B1F),
    info: Color(0xFF1565C0),
    onInfo: Color(0xFFFFFFFF),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF81C784),
    onSuccess: Color(0xFF0B1F0D),
    warning: Color(0xFFFFD54F),
    onWarning: Color(0xFF1C1B1F),
    info: Color(0xFF90CAF9),
    onInfo: Color(0xFF0D1B2A),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  AppSemanticColors lerp(
    ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;

    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }
}
```

### Exemplo de acesso via extensão de `BuildContext`

```dart
import 'package:flutter/material.dart';

extension AppThemeContext on BuildContext {
  AppSemanticColors get appColors {
    return Theme.of(this).extension<AppSemanticColors>()!;
  }
}
```

### Exemplo de uso

```dart
Chip(
  label: const Text('Concluído'),
  backgroundColor: context.appColors.success,
  labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: context.appColors.onSuccess,
      ),
);
```

---

## 14. Responsividade obrigatória

As telas devem funcionar bem em:

* mobile;
* tablet;
* web;
* desktop, quando aplicável.

A responsividade deve ser considerada desde a criação da tela, e não apenas como ajuste posterior.

### APIs recomendadas

Use:

* `LayoutBuilder` para adaptar layout conforme espaço disponível;
* `MediaQuery` para informações de tela, orientação e acessibilidade;
* `NavigationBar` em mobile;
* `NavigationRail` em tablet e desktop;
* `NavigationDrawer` quando houver muitas seções;
* grids responsivos;
* largura máxima de conteúdo;
* breakpoints próprios.

### Regras por tamanho de tela

#### Mobile

* Priorizar layout em coluna.
* Usar `NavigationBar` para navegação principal inferior.
* Usar `Scaffold` com `AppBar`.
* Evitar excesso de informações lado a lado.
* Usar `ListView`, `CustomScrollView` ou `SingleChildScrollView` quando necessário.

#### Tablet

* Considerar `NavigationRail`.
* Usar duas colunas quando fizer sentido.
* Aumentar respiro lateral.
* Manter conteúdo principal com largura controlada.

#### Desktop/Web

* Considerar `NavigationRail`, `NavigationDrawer` ou layout centralizado.
* Usar largura máxima para evitar linhas muito longas.
* Usar grids responsivos.
* Evitar conteúdo esticado de ponta a ponta sem necessidade.

### Exemplo de layout responsivo

```dart
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrLarger = constraints.maxWidth >= AppBreakpoints.tablet;

        if (isTabletOrLarger) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Início'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Configurações'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Configurações',
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Exemplo de container com largura máxima

```dart
class AppPageContainer extends StatelessWidget {
  const AppPageContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.maxContentWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 15. Composição de widgets pequenos

Prefira composição de widgets pequenos, claros e reutilizáveis.

Evite telas enormes com centenas de linhas dentro de um único método `build`.

### Separar widgets por responsabilidade

Separe a interface em widgets como:

* header;
* cards;
* filtros;
* listas;
* estados vazios;
* botões de ação;
* seções;
* componentes de feedback;
* containers responsivos;
* barras de navegação;
* formulários;
* itens de lista.

### Exemplo recomendado

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: HomeBody(),
    );
  }
}
```

```dart
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(),
          SizedBox(height: AppSpacing.lg),
          HomeSummarySection(),
          SizedBox(height: AppSpacing.lg),
          HomeRecentItemsSection(),
        ],
      ),
    );
  }
}
```

### Regras práticas

* Se o `build` passar de muitas responsabilidades, divida em widgets privados ou públicos.
* Se um bloco visual for reutilizado, crie um widget próprio.
* Se o widget for específico de uma feature, mantenha-o na pasta da feature.
* Se o widget for genérico, coloque-o em `core/widgets`.
* Evite lógica de negócio dentro da camada visual.
* Evite widgets genéricos demais que não deixam clara sua intenção.

---

## 16. Organização recomendada de pastas

A estrutura abaixo é recomendada para manter tema, tokens, widgets compartilhados e features organizados.

```text
lib/
  core/
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_radius.dart
      app_sizes.dart
      app_breakpoints.dart
      app_durations.dart
      app_typography.dart
      app_theme_extensions.dart
    widgets/
      responsive_layout.dart
      app_page_container.dart
      app_empty_state.dart
      app_error_state.dart
      app_loading_state.dart
  features/
    home/
      presentation/
        pages/
          home_page.dart
        widgets/
          home_app_bar.dart
          home_body.dart
          home_header.dart
          home_summary_section.dart
          home_recent_items_section.dart
    settings/
      presentation/
        pages/
        widgets/
```

### Responsabilidade de cada pasta

#### `lib/core/theme/`

Contém tudo que define a linguagem visual global do app.

Use para:

* `ThemeData` claro e escuro;
* `ColorScheme`;
* tokens de espaçamento;
* tokens de raio;
* tokens de tamanho;
* breakpoints;
* durações de animação;
* extensões de tema;
* tipografia;
* estilos globais de componentes Material.

#### `lib/core/widgets/`

Contém widgets compartilhados e genéricos que podem ser usados em várias features.

Exemplos:

* container com largura máxima;
* layout responsivo;
* estado vazio;
* estado de erro;
* estado de carregamento;
* wrappers que compõem widgets Material.

Atenção: widgets em `core/widgets` não devem criar design system paralelo. Eles devem compor componentes Material existentes.

#### `lib/features/`

Contém os módulos funcionais da aplicação.

Cada feature deve organizar sua interface dentro de `presentation`.

#### `presentation/pages/`

Contém telas completas, normalmente compostas por `Scaffold`.

Exemplos:

* `home_page.dart`;
* `settings_page.dart`;
* `profile_page.dart`.

#### `presentation/widgets/`

Contém widgets específicos daquela feature.

Exemplos:

* cabeçalhos;
* cards específicos;
* seções;
* filtros;
* listas;
* formulários.

---

## 17. Consulta à documentação oficial via MCP

Antes de gerar código visual, quando houver dúvida sobre componentes Flutter ou Material 3, a IA/Codex deve consultar documentação atualizada via MCP, quando disponível.

### Consultar documentação quando houver dúvida sobre

* widget Material mais adequado;
* parâmetros recomendados;
* comportamento Material 3;
* atualização de APIs;
* componentes novos;
* diferenças entre componentes antigos e novos;
* boas práticas atuais do Flutter;
* alterações de tema entre versões;
* propriedades de `ColorScheme`;
* propriedades de `ThemeData`;
* comportamento responsivo recomendado.

### Quando o MCP não estiver disponível

Se o MCP não estiver disponível, use como referência os links oficiais listados ao final deste documento.

### Regra para IA/Codex

A IA não deve inventar componentes, parâmetros ou APIs.

Quando houver incerteza, deve:

1. consultar a documentação oficial via MCP, se disponível;
2. usar links oficiais do Flutter e Material;
3. preferir solução simples e nativa;
4. evitar bibliotecas visuais externas;
5. documentar qualquer exceção.

---

## 18. Critérios para geração de código Flutter

Ao gerar código Flutter para telas, a IA/Codex deve obrigatoriamente:

* usar componentes Material nativos;
* respeitar `ThemeData`;
* usar `ColorScheme` para cores;
* usar `TextTheme` para tipografia;
* usar `ThemeExtension` para tokens extras;
* não usar cores diretas nas telas;
* não criar design system paralelo;
* não usar Cupertino;
* não usar bibliotecas visuais externas para substituir Material;
* usar `fl_chart` sempre que a tela precisar exibir gráficos;
* manter código limpo e reutilizável;
* separar widgets quando a tela crescer;
* garantir responsividade quando aplicável;
* preferir `const` sempre que possível;
* manter nomes claros para classes, métodos e widgets;
* evitar lógica de negócio dentro da camada visual;
* comentar apenas quando o código não for autoexplicativo;
* priorizar acessibilidade padrão dos componentes Material;
* usar estados visuais nativos de componentes Material;
* evitar `GestureDetector` para criar botões;
* evitar `Container` como substituto de componentes Material.

---

## 19. Regras específicas por tipo de componente

### 19.1. Telas

Toda tela principal deve usar `Scaffold`, salvo exceção técnica clara.

```dart
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Exemplo')),
      body: ExampleBody(),
    );
  }
}
```

### 19.2. Botões

Use:

* `FilledButton` para ação principal;
* `FilledButton.tonal` para ação secundária com destaque moderado;
* `OutlinedButton` para ação secundária;
* `TextButton` para ação de baixo destaque;
* `IconButton` para ações compactas com ícone;
* `FloatingActionButton` para ação principal flutuante;
* `FloatingActionButton.extended` quando o texto da ação for necessário.

Não use `Container`, `InkWell` ou `GestureDetector` para simular botão, exceto se estiver compondo um comportamento que não existe em nenhum botão Material e houver justificativa.

### 19.3. Cards

Use:

* `Card`;
* `Card.filled`;
* `Card.outlined`.

Não crie cards manualmente com `Container`, `BoxDecoration` e `boxShadow` quando `Card` resolver o caso.

### 19.4. Inputs

Use:

* `TextField` para entrada simples;
* `TextFormField` quando houver formulário e validação;
* `InputDecorationTheme` para padronizar aparência;
* `SearchBar` para busca Material 3;
* `DropdownMenu` para seleção quando aplicável.

### 19.5. Listas

Use:

* `ListView` para listas roláveis;
* `ListTile` para itens de lista padrão;
* `Divider` para separação;
* `Card` quando o item precisar de superfície destacada.

### 19.6. Feedback

Use:

* `SnackBar` para mensagens temporárias;
* `AlertDialog` para decisões importantes;
* `Dialog` para conteúdo modal personalizado, mas ainda Material;
* `showModalBottomSheet` para ações ou formulários contextuais;
* `CircularProgressIndicator` e `LinearProgressIndicator` para carregamento.

### 19.7. Navegação

Use:

* `NavigationBar` em mobile;
* `NavigationRail` em tablet e desktop;
* `NavigationDrawer` quando houver muitas seções;
* `TabBar` para alternância de conteúdo relacionado dentro da mesma tela;
* `BottomAppBar` quando houver ação flutuante associada à barra inferior.

---

## 20. Exemplos completos

### 20.1. Tela simples correta

```dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: AppPageContainer(
        child: ProfileContent(),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dados do usuário',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Card.outlined(
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              'Maxwell Farias',
              style: textTheme.titleMedium,
            ),
            subtitle: const Text('Usuário administrador'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save_outlined),
          label: const Text('Salvar alterações'),
        ),
      ],
    );
  }
}
```

### 20.2. Formulário correto

```dart
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'E-mail',
            prefixIcon: Icon(Icons.mail_outline),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Senha',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () {},
          child: const Text('Entrar'),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () {},
          child: const Text('Esqueci minha senha'),
        ),
      ],
    );
  }
}
```

### 20.3. Lista correta

```dart
class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: Text('Notificação ${index + 1}'),
          subtitle: const Text('Detalhes da notificação'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }
}
```

---

## 21. Exemplos proibidos

### 21.1. Botão manual

```dart
GestureDetector(
  onTap: () {},
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'Confirmar',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

Use:

```dart
FilledButton(
  onPressed: () {},
  child: const Text('Confirmar'),
);
```

### 21.2. Input manual

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(12),
  ),
  child: const TextField(
    decoration: InputDecoration(border: InputBorder.none),
  ),
);
```

Use:

```dart
TextField(
  decoration: const InputDecoration(
    labelText: 'Pesquisar',
    prefixIcon: Icon(Icons.search),
  ),
);
```

### 21.3. Navegação inferior manual

```dart
Container(
  height: 72,
  color: Colors.white,
  child: Row(
    children: const [
      Icon(Icons.home),
      Icon(Icons.search),
      Icon(Icons.settings),
    ],
  ),
);
```

Use:

```dart
NavigationBar(
  selectedIndex: selectedIndex,
  onDestinationSelected: onDestinationSelected,
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Início',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Buscar',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Ajustes',
    ),
  ],
);
```

---

## 22. Checklist obrigatório antes de entregar uma tela

Use este checklist antes de entregar qualquer tela, componente ou alteração visual.

### Estrutura

* [ ] A tela usa `Scaffold` quando representa uma página completa?
* [ ] A tela usa `AppBar`, `BottomAppBar`, `NavigationBar`, `NavigationRail` ou `NavigationDrawer` quando necessário?
* [ ] A estrutura está separada em widgets menores?
* [ ] O `build` não concentra responsabilidades demais?

### Material Design 3

* [ ] O projeto usa `ThemeData(useMaterial3: true)`?
* [ ] Os componentes seguem Material Design 3?
* [ ] A tela evita visual incompatível com Material?

### Componentes nativos

* [ ] Os botões são `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton` ou `FloatingActionButton`?
* [ ] Os cards usam `Card`, `Card.filled` ou `Card.outlined`?
* [ ] Os campos usam `TextField`, `TextFormField`, `SearchBar` ou equivalente Material?
* [ ] As listas usam `ListTile` quando aplicável?
* [ ] Os menus usam `MenuAnchor`, `PopupMenuButton` ou componente Material adequado?
* [ ] Os dialogs usam `AlertDialog` ou `Dialog`?
* [ ] Os bottom sheets usam `showModalBottomSheet` ou `BottomSheet`?
* [ ] Feedback temporário usa `SnackBar`?
* [ ] Se a tela possui gráficos, eles foram implementados com `fl_chart`?

### Tema e tokens

* [ ] As cores vêm de `ColorScheme` ou `ThemeExtension`?
* [ ] A tipografia vem de `TextTheme`?
* [ ] Os espaçamentos vêm de tokens como `AppSpacing`?
* [ ] Os raios vêm de tokens como `AppRadius`?
* [ ] As dimensões recorrentes vêm de tokens como `AppSizes`?
* [ ] O tema claro e escuro estão centralizados?
* [ ] A tela evita `Colors.blue`, `Colors.red`, `Colors.black`, `Colors.white` diretamente?

### Proibições

* [ ] A tela evita `Container` usado como botão?
* [ ] A tela evita `GestureDetector` para simular componente Material?
* [ ] A tela evita componentes customizados desnecessários?
* [ ] A tela não usa Cupertino?
* [ ] A tela não usa bibliotecas visuais externas para substituir Material?
* [ ] A tela não cria design system paralelo?

### Responsividade

* [ ] A tela funciona bem em mobile?
* [ ] A tela foi pensada para tablet/web quando aplicável?
* [ ] A navegação muda corretamente entre `NavigationBar`, `NavigationRail` ou `NavigationDrawer`?
* [ ] O conteúdo possui largura máxima quando necessário?
* [ ] O layout evita overflow?

### Qualidade de código

* [ ] O código usa `const` sempre que possível?
* [ ] Os nomes de classes, métodos e widgets são claros?
* [ ] A lógica de negócio está fora da camada visual?
* [ ] Comentários existem apenas quando necessários?
* [ ] O código está limpo, legível e manutenível?

---

## 23. Regras para revisão de código

Durante revisão de código, considere erro de padrão visual quando encontrar:

* botão feito com `Container`, `InkWell` ou `GestureDetector` sem justificativa;
* card feito manualmente com `Container` e `BoxShadow` sem justificativa;
* cor direta dentro da tela;
* `TextStyle` manual sem usar `TextTheme` como base;
* navegação customizada sem necessidade;
* uso de Cupertino sem solicitação explícita;
* biblioteca visual externa substituindo Material;
* tela sem responsividade mínima;
* ausência de tokens para valores recorrentes;
* tema duplicado dentro de features;
* componentes visuais que ignoram `ThemeData`.

### Severidade recomendada

#### Bloqueante

Deve impedir merge:

* uso de design system paralelo;
* uso de biblioteca visual externa para substituir Material;
* uso recorrente de cores diretas;
* componentes customizados substituindo Material sem justificativa;
* tela principal sem `Scaffold` sem justificativa;
* ausência de suporte a tema claro/escuro quando a tela define cores próprias.

#### Ajuste necessário

Deve ser corrigido antes da entrega:

* espaçamentos fora dos tokens;
* tipografia parcialmente manual;
* widget grande demais;
* ausência de `const` em muitos pontos;
* responsividade insuficiente.

#### Sugestão

Pode ser melhorado:

* nomes mais claros;
* melhor separação de widgets;
* melhor reaproveitamento;
* simplificação de layout.

---

## 24. Orientação final para IA/Codex

Ao gerar uma tela Flutter para este projeto, siga esta ordem de decisão:

1. Entenda a função da tela.
2. Escolha componentes nativos Material adequados.
3. Use `Scaffold` para páginas completas.
4. Use `Theme.of(context).colorScheme` para cores.
5. Use `Theme.of(context).textTheme` para textos.
6. Use tokens para espaçamentos, raios e tamanhos.
7. Use `ThemeExtension` para semânticas próprias do produto.
8. Garanta responsividade mínima.
9. Separe widgets por responsabilidade.
10. Evite qualquer solução visual customizada sem necessidade.

A IA/Codex deve tratar este documento como a referência principal de UI do projeto.

Se uma solicitação do usuário entrar em conflito com este documento, a IA deve:

1. priorizar este documento;
2. explicar o conflito;
3. propor uma solução Material 3 equivalente;
4. só seguir fora do padrão se o usuário solicitar explicitamente.

---

## 25. Links oficiais de referência

### Documentação geral

* Flutter Material widgets: https://docs.flutter.dev/ui/widgets/material
* Material Design no Flutter: https://docs.flutter.dev/ui/design/material
* Temas no Flutter: https://docs.flutter.dev/cookbook/design/themes
* Migração para Material 3: https://docs.flutter.dev/release/breaking-changes/material-3-migration
* Material 3 como padrão no Flutter: https://docs.flutter.dev/release/breaking-changes/material-3-default

### Tema, cores e tipografia

* `ThemeData`: https://api.flutter.dev/flutter/material/ThemeData-class.html
* `ThemeData.useMaterial3`: https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html
* `MaterialApp`: https://api.flutter.dev/flutter/material/MaterialApp-class.html
* `ThemeMode`: https://api.flutter.dev/flutter/material/ThemeMode.html
* `ColorScheme`: https://api.flutter.dev/flutter/material/ColorScheme-class.html
* Novos papéis de cor do Material 3: https://docs.flutter.dev/release/breaking-changes/new-color-scheme-roles
* `TextTheme`: https://api.flutter.dev/flutter/material/TextTheme-class.html
* `ThemeExtension`: https://api.flutter.dev/flutter/material/ThemeExtension-class.html

### Botões e ações

* `ButtonStyle`: https://api.flutter.dev/flutter/material/ButtonStyle-class.html
* `FilledButton`: https://api.flutter.dev/flutter/material/FilledButton-class.html
* `OutlinedButton`: https://api.flutter.dev/flutter/material/OutlinedButton-class.html
* `TextButton`: https://api.flutter.dev/flutter/material/TextButton-class.html
* `ElevatedButton`: https://api.flutter.dev/flutter/material/ElevatedButton-class.html
* `FloatingActionButton`: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html
* `FloatingActionButton.extended`: https://api.flutter.dev/flutter/material/FloatingActionButton/FloatingActionButton.extended.html
* `IconButton`: https://api.flutter.dev/flutter/material/IconButton-class.html
* `SegmentedButton`: https://api.flutter.dev/flutter/material/SegmentedButton-class.html

### Componentes Material

* `Badge`: https://api.flutter.dev/flutter/material/Badge-class.html
* `SnackBar`: https://api.flutter.dev/flutter/material/SnackBar-class.html
* `AlertDialog`: https://api.flutter.dev/flutter/material/AlertDialog-class.html
* `Dialog`: https://api.flutter.dev/flutter/material/Dialog-class.html
* `BottomSheet`: https://api.flutter.dev/flutter/material/BottomSheet-class.html
* `showModalBottomSheet`: https://api.flutter.dev/flutter/material/showModalBottomSheet.html
* `Card`: https://api.flutter.dev/flutter/material/Card-class.html
* `Divider`: https://api.flutter.dev/flutter/material/Divider-class.html
* `ListTile`: https://api.flutter.dev/flutter/material/ListTile-class.html
* `BottomAppBar`: https://api.flutter.dev/flutter/material/BottomAppBar-class.html
* `NavigationBar`: https://api.flutter.dev/flutter/material/NavigationBar-class.html
* `NavigationDrawer`: https://api.flutter.dev/flutter/material/NavigationDrawer-class.html
* `NavigationRail`: https://api.flutter.dev/flutter/material/NavigationRail-class.html
* `TabBar`: https://api.flutter.dev/flutter/material/TabBar-class.html
* `Checkbox`: https://api.flutter.dev/flutter/material/Checkbox-class.html
* `Chip`: https://api.flutter.dev/flutter/material/Chip-class.html
* `MenuAnchor`: https://api.flutter.dev/flutter/material/MenuAnchor-class.html
* `Radio`: https://api.flutter.dev/flutter/material/Radio-class.html
* `Slider`: https://api.flutter.dev/flutter/material/Slider-class.html
* `Switch`: https://api.flutter.dev/flutter/material/Switch-class.html
* `TextField`: https://api.flutter.dev/flutter/material/TextField-class.html
* `SearchBar`: https://api.flutter.dev/flutter/material/SearchBar-class.html
* `DropdownMenu`: https://api.flutter.dev/flutter/material/DropdownMenu-class.html
* `showDatePicker`: https://api.flutter.dev/flutter/material/showDatePicker.html
* `showTimePicker`: https://api.flutter.dev/flutter/material/showTimePicker.html

---

## 26. Resumo da regra principal

> Use Material Design 3 nativo. Centralize tudo no tema. Não crie componentes visuais customizados quando o Flutter Material já oferece uma solução oficial.

---

## 27. Componentes reutilizáveis do MVP de análise de vínculos

Esta seção registra a infraestrutura compartilhada de apresentação preparada a
partir das 33 telas de
`docs/MVP_ANALISE_DE_VINCULOS_MOBILE_FIRST (1).md`. Os widgets abaixo apenas
compõem componentes Material 3, não conhecem ViewModels ou entidades de domínio e
devem receber dados já prontos para apresentação.

### 27.1. Matriz de reutilização

| Componente candidato | Telas do MVP | Variações necessárias | Justificativa |
|---|---|---|---|
| `AppResponsiveScaffold` | 02, 04, 23 e 27 | `NavigationBar` abaixo de 600 px, `NavigationRail` entre 600 e 1199 px e `NavigationDrawer` fixa a partir de 1200 px; App Bar e FAB opcionais | Os quatro destinos e a mudança de navegação por largura são iguais nas telas principais. |
| `AppPageContainer` | 02–04 e 06–31 | largura máxima, padding e alinhamento configuráveis | Quase todo conteúdo de página precisa de margem mobile e largura controlada em telas grandes. |
| `AppSearchField` | 02, 03, 04, 23 e 29 | foco inicial, habilitado/desabilitado, submissão e limpeza | Busca com ícone e ação de limpar é recorrente e precisa manter alvo de toque e semântica consistentes. |
| `AppFilterButton` | 04, 25 e 27 | sem contador ou com quantidade de filtros ativos | A mesma ação combina botão Material e `Badge` sem depender apenas de cor. |
| `AppEntityAvatar` | 02–04, 06, 10–13, 18–25 e 27–33 | pessoa, facção, veículo, local, evidência ou vínculo; ícone ou imagem | Os mesmos tipos de entidade aparecem como identidade visual em listas, detalhes, grafo e confirmações. |
| `AppStatusChip` | 03, 04, 06, 10, 11, 23–25 e 27–29 | neutro, informativo, sucesso, alerta ou crítico; ícone obrigatório | Status, risco e confiança repetem a mesma combinação acessível de texto, ícone e tom semântico. |
| `AppRecordCard` | 02–04, 07, 08, 10–13, 18–23, 25, 27, 30 e 33 | com ou sem identidade, metadados, chips, ação e trailing | Listas de entidades distintas compartilham a mesma hierarquia de título, detalhes, estados e abertura de detalhe. |
| `AppSectionHeader` | 02, 06–08, 16, 17, 24, 26 e 28–31 | leading e ação opcionais | Títulos de seção aparecem repetidamente dentro de páginas e detalhes, com a mesma semântica de cabeçalho. |
| `AppKeyValueRow` | 06–08, 10–13, 24, 28, 30 e 31 | alinhamento do valor configurável | Detalhes sensíveis e metadados usam repetidamente pares rótulo/valor. |
| `AppNoticeBanner` | 06, 08, 10, 12, 16, 19 e 32 | neutro, informativo, sucesso, alerta ou crítico; título e ação opcionais | Avisos operacionais, ressalvas jurídicas e offline têm a mesma estrutura, mudando apenas a semântica. |
| `AppStepProgress` | 14–22 | etapa atual, total e título | As nove etapas do cadastro repetem o mesmo indicador textual e linear. |
| `AppFormActions` | 14–22, 26, 28–30, 32 e 33 | uma ou duas ações, ícones opcionais e envio em andamento | Pares anterior/próximo, cancelar/salvar e tentar/voltar precisam responder a largura e escala de texto. |
| `AppFeedbackState` | 03, 04, 07–13, 23, 25 e 32 | vazio, erro, offline e sucesso; ações e código de suporte opcionais | Todas as coleções precisam apresentar os mesmos estados de ausência e falha; o contrato também cobre feedback conclusivo. |
| `AppLoadingList` | 02–04, 06–13, 23–25, 27, 28, 30–32 | quantidade e rótulo semântico configuráveis | As telas de consulta repetem carregamento linear com cartões de esqueleto. |
| `AppModalSheet` | 05 e 27 | conteúdo rolável, fechar opcional e uma ou duas ações | Filtros e legenda do grafo compartilham o mesmo contêiner modal Material, incluindo teclado e Safe Area. |

### 27.2. Suporte semântico e breakpoints

`AppSemanticColors`, em `lib/core/theme/app_semantic_colors.dart`, é uma
`ThemeExtension` registrada pelos temas claro e escuro. Ela centraliza os papéis
de sucesso, alerta e informação usados por chips, avisos e estados. Cores críticas
continuam vindo de `ColorScheme.error`; cores neutras continuam vindo dos papéis
de superfície do `ColorScheme`.

`AppBreakpoints` foi complementado com 840, 1200 e 1440 px. Para o shell, prevalece
a especificação concreta do MVP: 600 px inicia o `NavigationRail` e 1200 px inicia
o `NavigationDrawer` fixo. O valor de 1024 px mostrado anteriormente neste
documento era um exemplo genérico e não define o contrato específico deste MVP.

`AppSemanticTone` é o tipo compartilhado que traduz `neutral`, `info`, `success`,
`warning` e `critical` para os tokens do tema. Ele não deve receber regras de
negócio: a tela decide o tom a partir do estado já calculado.

### 27.3. Catálogo e contratos

#### `AppResponsiveScaffold`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_responsive_scaffold.dart`
- **Finalidade:** oferecer o shell responsivo dos quatro destinos principais.
- **Quando usar:** páginas raiz de Início, Pessoas, Vínculos e Facções.
- **Quando não usar:** login, detalhes empilhados e fluxos modais sem navegação principal.
- **Principais propriedades:** `selectedIndex`, `onDestinationSelected`,
  `destinations`, `body`, `appBar` e `floatingActionButton`.
- **Variações e estados:** barra inferior, rail ou drawer conforme a largura;
  destino selecionado e FAB contextual.
- **Telas:** 02, 04, 23 e 27.
- **Responsividade e acessibilidade:** os componentes Material preservam foco,
  teclado e alvos de toque; cada `AppNavigationDestination` exige rótulo,
  ícone normal e selecionado.

```dart
AppResponsiveScaffold(
  selectedIndex: 1,
  onDestinationSelected: onNavigate,
  destinations: destinations,
  appBar: AppBar(title: const Text('Pessoas')),
  body: const PeopleContent(),
);
```

#### `AppPageContainer`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_page_container.dart`
- **Finalidade:** aplicar margem de página e largura máxima sem esticar o conteúdo.
- **Quando usar:** conteúdo principal de páginas e painéis.
- **Quando não usar:** elementos que precisam ocupar toda a viewport, como o grafo,
  ou conteúdo já espaçado por outro contêiner.
- **Principais propriedades:** `child`, `maxWidth`, `padding` e `alignment`.
- **Variações e estados:** padding padrão de 16 dp no mobile e 24 dp a partir de
  600 px; valores podem ser substituídos explicitamente.
- **Telas:** 02–04 e 06–31.
- **Responsividade e acessibilidade:** não altera a árvore semântica; apenas limita
  e posiciona o conteúdo.

```dart
const AppPageContainer(child: PeopleListContent())
```

#### `AppSearchField`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_search_field.dart`
- **Finalidade:** padronizar busca Material 3 com limpar consulta.
- **Quando usar:** pesquisa global, pesquisa de listas e seleção de destino.
- **Quando não usar:** entrada textual comum ou campo de formulário validado; use
  `TextFormField`.
- **Principais propriedades:** `controller`, `hintText`, `onChanged`,
  `onSubmitted`, `onClear`, `autofocus`, `enabled` e `semanticLabel`.
- **Variações e estados:** vazio, preenchido com ação de limpar, desabilitado e
  foco inicial.
- **Telas:** 02, 03, 04, 23 e 29.
- **Responsividade e acessibilidade:** altura mínima de 48 dp, rótulo semântico e
  tooltip na ação de limpar.

```dart
AppSearchField(
  controller: searchController,
  hintText: 'Buscar nome, apelido ou CPF',
  onSubmitted: onSearch,
);
```

#### `AppFilterButton`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_filter_button.dart`
- **Finalidade:** abrir filtros e comunicar quantos estão ativos.
- **Quando usar:** quando a tela abre filtros em sheet ou painel.
- **Quando não usar:** filtros já expostos diretamente como `FilterChip`.
- **Principais propriedades:** `onPressed`, `activeFilterCount` e `label`.
- **Variações e estados:** sem badge, badge contado e desabilitado.
- **Telas:** 04, 25 e 27.
- **Responsividade e acessibilidade:** usa `OutlinedButton` e `Badge`; a semântica
  anuncia a contagem sem depender da cor.

```dart
AppFilterButton(activeFilterCount: 2, onPressed: openFilters)
```

#### `AppEntityAvatar`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_entity_avatar.dart`
- **Finalidade:** identificar visualmente o tipo de registro.
- **Quando usar:** leading de cards, resultados, detalhes e seleções.
- **Quando não usar:** foto em grade ou pré-visualização de evidência em tamanho
  grande.
- **Principais propriedades:** `type`, `image` e `semanticLabel`.
- **Variações e estados:** `person`, `faction`, `vehicle`, `place`, `evidence` e
  `link`; imagem substitui o ícone.
- **Telas:** 02–04, 06, 10–13, 18–25 e 27–33.
- **Responsividade e acessibilidade:** diâmetro de 48 dp e descrição semântica do
  tipo ou da imagem.

```dart
const AppEntityAvatar(type: AppEntityType.person)
```

#### `AppStatusChip`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_status_chip.dart`
- **Finalidade:** apresentar status, confiança ou severidade com semântica comum.
- **Quando usar:** rótulos curtos que descrevem estado de um registro.
- **Quando não usar:** seleção interativa; use `FilterChip`, `ChoiceChip` ou
  `SegmentedButton`.
- **Principais propriedades:** `label`, `icon`, `tone` e `semanticLabel`.
- **Variações e estados:** neutro, informativo, sucesso, alerta e crítico.
- **Telas:** 03, 04, 06, 10, 11, 23–25 e 27–29.
- **Responsividade e acessibilidade:** sempre combina texto, ícone, borda e cor;
  nunca comunica estado apenas pela cor.

```dart
const AppStatusChip(
  label: 'Em verificação',
  icon: Icons.manage_search_outlined,
  tone: AppSemanticTone.warning,
)
```

#### `AppRecordCard`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_record_card.dart`
- **Finalidade:** resumir um registro clicável com identidade, detalhes e estados.
- **Quando usar:** listas de pessoas, facções, veículos, vínculos, locais,
  evidências, abordagens e antecedentes.
- **Quando não usar:** cards métricos da Visão Geral, grades de foto ou superfícies
  com formulário complexo.
- **Principais propriedades:** `title`, `leading`, `details`, `statuses`,
  `trailing`, `onTap` e `semanticLabel`.
- **Variações e estados:** informativo ou acionável; trailing automático de
  navegação quando `onTap` está presente.
- **Telas:** 02–04, 07, 08, 10–13, 18–23, 25, 27, 30 e 33.
- **Responsividade e acessibilidade:** detalhes quebram linha, chips usam `Wrap` e
  o card acionável é anunciado como botão com resumo textual único.

```dart
AppRecordCard(
  title: 'Rafael Mendes',
  leading: const AppEntityAvatar(type: AppEntityType.person),
  details: const ['34 anos', 'Grupo Aurora'],
  onTap: openProfile,
)
```

#### `AppSectionHeader`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_section_header.dart`
- **Finalidade:** marcar o início de uma seção de conteúdo.
- **Quando usar:** Identificação, Contatos, Qualificação, Indicadores, Segurança e
  seções equivalentes.
- **Quando não usar:** título da página, que pertence à `AppBar`, ou label de campo.
- **Principais propriedades:** `title`, `leading` e `action`.
- **Variações e estados:** leading e ação opcionais.
- **Telas:** 02, 06–08, 16, 17, 24, 26 e 28–31.
- **Responsividade e acessibilidade:** o título ocupa o espaço restante e é
  anunciado como cabeçalho semântico.

```dart
const AppSectionHeader(title: 'Qualificação')
```

#### `AppKeyValueRow`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_key_value_row.dart`
- **Finalidade:** exibir metadado no formato rótulo/valor.
- **Quando usar:** detalhes somente leitura e resumos de atributos.
- **Quando não usar:** campos editáveis, tabelas extensas ou valores que exigem um
  widget rico.
- **Principais propriedades:** `label`, `value` e `valueTextAlign`.
- **Variações e estados:** valor alinhado ao fim por padrão ou alinhamento
  explicitamente alterado.
- **Telas:** 06–08, 10–13, 24, 28, 30 e 31.
- **Responsividade e acessibilidade:** os dois lados podem quebrar linha; leitores
  de tela recebem uma frase única no formato “rótulo: valor”.

```dart
const AppKeyValueRow(label: 'Confiança', value: 'Alta')
```

#### `AppNoticeBanner`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_notice_banner.dart`
- **Finalidade:** apresentar aviso persistente dentro do conteúdo.
- **Quando usar:** ressalvas operacionais, legais, de integridade ou conectividade.
- **Quando não usar:** feedback breve de uma ação; use `SnackBar`.
- **Principais propriedades:** `message`, `title`, `tone`, `icon`, `actionLabel`
  e `onAction`.
- **Variações e estados:** neutro, informativo, sucesso, alerta e crítico; título e
  ação opcionais.
- **Telas:** 06, 08, 10, 12, 16, 19 e 32.
- **Responsividade e acessibilidade:** texto quebra linha, ação fica em área
  própria e avisos críticos usam região semântica ativa.

```dart
const AppNoticeBanner(
  message: 'Abordagem não comprova vínculo.',
  tone: AppSemanticTone.warning,
)
```

#### `AppNetworkStatusBanner`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_network_status_banner.dart`
- **Finalidade:** informar globalmente a ausência de transporte de rede.
- **Quando usar:** uma única vez no `builder` do `MaterialApp.router`.
- **Quando não usar:** para concluir que o servidor está acessível; a resposta
  real do Dio/repositório continua sendo a autoridade.
- **Dependência:** `NetworkStatusController`, alimentado por
  `connectivity_plus` 6.x.
- **Comportamento:** mantém formulários editáveis, não reenvia ações ao
  reconectar e anuncia que consultas, uploads e demais chamadas remotas estão
  bloqueados pelo interceptor enquanto `ConnectivityResult.none` estiver ativo.
- **Responsividade e acessibilidade:** ocupa a largura disponível, respeita a
  Safe Area superior e usa região semântica ativa.

```dart
MaterialApp.router(
  builder: (context, child) => Column(
    children: [
      const AppNetworkStatusBanner(),
      Expanded(child: child!),
    ],
  ),
)
```

#### `AppStepProgress`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_step_progress.dart`
- **Finalidade:** comunicar posição e progresso no cadastro em nove etapas.
- **Quando usar:** topo do conteúdo de cada etapa do cadastro progressivo.
- **Quando não usar:** navegação arbitrária entre abas ou progresso indeterminado.
- **Principais propriedades:** `currentStep`, `totalSteps` e `title`.
- **Variações e estados:** qualquer etapa válida entre 1 e o total.
- **Telas:** 14–22.
- **Responsividade e acessibilidade:** indicador linear ocupa a largura disponível
  e anuncia etapa atual, total e título.

```dart
const AppStepProgress(
  currentStep: 3,
  totalSteps: 9,
  title: 'Contexto do registro',
)
```

#### `AppFormActions`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_form_actions.dart`
- **Finalidade:** organizar ação principal e ação secundária de formulários e
  estados.
- **Quando usar:** anterior/próximo, cancelar/salvar, tentar novamente/voltar e
  pares equivalentes.
- **Quando não usar:** menus de muitas ações ou uma ação contextual compacta.
- **Principais propriedades:** labels e callbacks primário/secundário,
  `primaryIcon`, `secondaryIcon` e `isSubmitting`.
- **Variações e estados:** uma ou duas ações, com ícones, desabilitadas e envio em
  andamento.
- **Telas:** 14–22, 26, 28–30, 32 e 33.
- **Responsividade e acessibilidade:** usa botões Material; empilha em largura
  estreita ou com texto ampliado e preserva alvos mínimos definidos pelo tema.

```dart
AppFormActions(
  primaryLabel: 'Próximo',
  onPrimaryPressed: next,
  secondaryLabel: 'Anterior',
  onSecondaryPressed: previous,
)
```

#### `AppFeedbackState`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_feedback_state.dart`
- **Finalidade:** representar estados sem conteúdo de uma área ou página.
- **Quando usar:** lista vazia, erro recuperável, consulta offline ou conclusão
  persistente.
- **Quando não usar:** carregamento ou mensagem temporária.
- **Principais propriedades:** `type`, `title`, `message`, `icon`, ações primária e
  secundária e `supportCode`.
- **Variações e estados:** `empty`, `error`, `offline` e `success`.
- **Telas:** 03, 04, 07–13, 23, 25 e 32.
- **Responsividade e acessibilidade:** largura máxima de leitura, conteúdo
  centralizado, ações adaptativas e anúncio ativo de erros.

```dart
AppFeedbackState(
  type: AppFeedbackType.empty,
  title: 'Nenhuma pessoa encontrada',
  message: 'Ajuste os filtros ou crie o primeiro cadastro.',
  primaryActionLabel: 'Nova pessoa',
  onPrimaryAction: createPerson,
)
```

#### `AppLoadingList`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_loading_list.dart`
- **Finalidade:** indicar carregamento de listas sem simular conteúdo real.
- **Quando usar:** enquanto cards de uma consulta estão sendo obtidos.
- **Quando não usar:** ação pontual dentro de botão ou upload com progresso
  determinado.
- **Principais propriedades:** `itemCount` e `semanticLabel`.
- **Variações e estados:** quantidade configurável de esqueletos.
- **Telas:** 02–04, 06–13, 23–25, 27, 28 e 30–32.
- **Responsividade e acessibilidade:** barras usam frações da largura disponível e
  a composição visual é excluída da semântica em favor de um anúncio de
  carregamento.

```dart
const AppLoadingList(itemCount: 3)
```

#### `AppModalSheet`

- **Caminho:** `lib/ui/core/componentes_reutilizaveis/app_modal_sheet.dart`
- **Finalidade:** hospedar filtros e conteúdo contextual em bottom sheet Material.
- **Quando usar:** filtros de pessoas, filtros e legenda do grafo.
- **Quando não usar:** confirmação curta e importante; use `AlertDialog`.
- **Principais propriedades:** `title`, `child`, ações primária/secundária e
  `showCloseButton`; `AppModalSheet.show` abre a rota modal.
- **Variações e estados:** com ou sem fechar explícito, sem ações ou com uma/duas
  ações.
- **Telas:** 05 e 27.
- **Responsividade e acessibilidade:** respeita Safe Area, inset do teclado,
  rolagem, altura de 90% e largura máxima de 640 dp; o botão fechar tem tooltip.

```dart
AppModalSheet.show<void>(
  context: context,
  title: 'Filtrar pessoas',
  builder: (_) => const PeopleFilters(),
)
```

### 27.4. Candidatos deliberadamente não abstraídos

- Campos de formulário, `DropdownMenu`, seletores de data, checkboxes, radios,
  chips de seleção, tabs, steppers completos, FABs, dialogs, snackbars e menus
  continuam sendo widgets Material nativos. Seus conteúdos e validações variam
  por tela, e um wrapper agora apenas duplicaria a API oficial.
- Cards métricos da tela 02, grade de fotos das telas 09 e 15, mapa das telas 12,
  20 e 24, grafo da tela 27 e visualizador da tela 30 permanecem específicos de
  suas features porque cada padrão possui apenas um uso concreto.
- O grafo da tela 27 autoriza funcionalmente o package `graphview` 1.5.1. A
  árvore usa `GraphView.builder`, `BuchheimWalkerAlgorithm`,
  `TreeEdgeRenderer` e `GraphViewController`; não deve usar `CustomPainter`
  próprio para layout ou arestas. Cards, busca e ações continuam Material. A
  projeção escolhe uma raiz e um único pai determinístico por entidade;
  relações cruzadas permanecem na lista textual, que também preserva acesso
  por teclado e tecnologia assistiva. A expansão remota continua limitada a
  três níveis e 300 nós.
- Os mapas das telas 12, 20 e 24 autorizam `flutter_map` 8.3.1 somente através
  de `AppMapView`. URL, atribuição e identificação do cliente vêm do ambiente;
  não existe fallback para tiles públicos. A atribuição fica visível e nenhum
  recurso de geocodificação, GPS ou telemetria de registros é permitido.
- Seleção de fotos e evidências autoriza `file_selector` 1.1.0 por meio de
  `FileSelectionService`. Thumbnails privados usam `image` 4.8.x, compatível
  com o SDK Dart atual, e nunca são persistidos em cache público.
- A tela 30 autoriza `pdfrx` 2.2.24 para PDF por bytes em memória e
  `url_launcher` 6.3.x para o segundo clique explícito de download. A versão
  2.4.7 de `pdfrx` exige Flutter mais recente que o SDK 3.38.9 do projeto.
- O estado global de transporte autoriza `connectivity_plus` 6.1.x. Ele não
  substitui erros do Dio, não implementa banco local e não dispara
  sincronização automática.
- O layout lista + detalhe não foi abstraído: a documentação só define
  explicitamente sua composição para Pessoas e para o grafo, com necessidades
  diferentes. A extração deve ocorrer quando uma segunda implementação concreta
  confirmar o mesmo contrato.
- `MobileScaffold` e `DesktopScaffold` existentes não substituem
  `AppResponsiveScaffold`: eles recebem uma sidebar arbitrária e não expressam
  destinos, seleção nem a troca Material entre barra, rail e drawer. Foram
  preservados para não quebrar seu contrato público atual.
