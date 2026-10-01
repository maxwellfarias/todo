# Arquitetura Flutter reutilizável baseada no Nexo

> Documento normativo para a criação de novas aplicações Flutter com a mesma
> organização arquitetural do Nexo, preservando seus padrões sólidos e
> eliminando decisões legadas ou específicas do produto atual.

## 1. Objetivo e escopo

Este documento descreve a arquitetura do aplicativo Flutter existente em
`nexo` e transforma essa implementação em um modelo reutilizável para outros
projetos.

O padrão adotado é uma arquitetura em camadas com apresentação em MVVM:

```text
Widget/View
    ↓ eventos                         ↑ estado e reações
ViewModel + Command
    ↓
Interface de Repository
    ↓
Implementação de Repository
    ↓
Mapper + Service/Gateway + ApiClient
    ↓
Dio
    ↓
API/backend
```

As decisões centrais são:

- UI organizada por feature;
- tela e componentes locais dentro da pasta `widgets` da feature;
- um ou mais ViewModels por feature;
- operações assíncronas da UI expostas por `Command`;
- domínio independente de Flutter, Dio, Provider e backend;
- repositories separados por entidade ou agregado;
- interface e implementação de cada repository no mesmo módulo de entidade;
- retorno de operações falíveis por `Result<T>`;
- conversão JSON/domínio centralizada em mappers;
- transporte HTTP atrás da abstração `ApiClient`, implementada com Dio;
- injeção de dependências com Provider;
- navegação de páginas exclusivamente com GoRouter;
- tema Material 3 centralizado em `lib/core/theme/theme.dart`;
- componentes visuais comuns centralizados e sem acesso a dados;
- testes organizados de modo a espelhar `lib/`.

Esta não é uma Clean Architecture formal com uma camada obrigatória de use
cases. Na arquitetura observada, os ViewModels orquestram repositories. Um use
case pode ser criado quando uma regra de negócio for reutilizada por várias
features ou quando a orquestração for complexa, mas não deve ser adicionado
apenas como passagem de parâmetros.

## 2. Regra de dependência

As dependências sempre apontam para dentro, em direção ao domínio e aos
contratos. O domínio nunca conhece detalhes externos.

```text
┌──────────────────────────────────────────────────────────────┐
│ UI: Widgets, telas, ViewModels e Commands                    │
├──────────────────────────────────────────────────────────────┤
│ Data: interfaces/implementações de repositories e mappers   │
├──────────────────────────────────────────────────────────────┤
│ Services: ApiClient, gateways, sessão, storage e adapters    │
├──────────────────────────────────────────────────────────────┤
│ Domain: models, enums, requests e regras de negócio puras    │
└──────────────────────────────────────────────────────────────┘
       Config, Routing, Theme e Utils são módulos transversais
```

Dependências permitidas:

| Origem | Pode depender de | Não deve depender de |
|---|---|---|
| `domain` | Dart e outros objetos de domínio | Flutter, Dio, Provider, widgets, JSON do backend |
| `data/mappers` | `domain` | UI e navegação |
| `data/services` | `domain`, `utils`, `exceptions` e biblioteca adaptada | UI e ViewModels |
| `data/repositories` | contratos de repository, domínio, mappers, services, utils | Widgets, rotas e BuildContext |
| `ui/*/viewmodel` | domínio, interfaces de repository, `Command` e `Result` | Dio, JSON, GoRouter e widgets concretos |
| `ui/*/widgets` | ViewModel, domínio somente para exibição, tema, componentes e navegação | implementações de repository, Dio e detalhes do backend |
| `config` | todas as abstrações necessárias para composição | regras visuais ou de feature |
| `routing` | telas, ViewModels, providers e estado de sessão | acesso direto ao backend |

Regra prática: se um tipo de Dio ou um `Map<String, dynamic>` vindo da API
chegar à UI, uma fronteira arquitetural foi violada.

## 3. Estrutura de diretórios de referência

Esta é a árvore recomendada para um novo aplicativo. Os nomes entre `<...>`
devem ser substituídos pelos nomes reais do projeto e das entidades.

```text
project/
├── assets/
│   ├── branding/
│   ├── icons/
│   └── images/
├── docs/
│   ├── ARQUITETURA_FLUTTER_REUTILIZAVEL.md
│   └── interface.md
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── app_providers.dart
│   │   ├── feature_providers.dart
│   │   └── <controller_global>.dart
│   ├── core/
│   │   └── theme/
│   │       ├── theme.dart
│   │       ├── app_tokens.dart
│   │       └── app_semantic_colors.dart
│   ├── domain/
│   │   ├── <entidade>/
│   │   │   ├── <entidade>_model.dart
│   │   │   ├── <entidade>_requests.dart
│   │   │   └── <entidade>_enums.dart
│   │   ├── auth/
│   │   └── pagination/
│   │       ├── paginated_response.dart
│   │       └── query_params.dart
│   ├── data/
│   │   ├── mappers/
│   │   │   ├── mappers.dart
│   │   │   └── <entidade>_mapper.dart
│   │   ├── repositories/
│   │   │   ├── <entidade>/
│   │   │   │   ├── <entidade>_repository.dart
│   │   │   │   └── <entidade>_repository_impl.dart
│   │   │   └── auth/
│   │   │       ├── auth_repository.dart
│   │   │       └── auth_repository_impl.dart
│   │   └── services/
│   │       ├── api_client/
│   │       │   ├── api_client.dart
│   │       │   └── api_client_impl.dart
│   │       ├── auth/
│   │       ├── storage/
│   │       └── <provedor_ou_integracao>/
│   ├── exceptions/
│   │   └── app_exception.dart
│   ├── routing/
│   │   ├── routes.dart
│   │   ├── router.dart
│   │   ├── app_navigation.dart
│   │   ├── auth_route_guard.dart
│   │   └── route_observers.dart
│   ├── ui/
│   │   ├── core/
│   │   │   ├── componentes_reutilizaveis/
│   │   │   ├── extensions/
│   │   │   ├── formatters/
│   │   │   └── ui/
│   │   ├── shell/
│   │   │   └── widgets/
│   │   └── <feature>/
│   │       ├── viewmodel/
│   │       │   ├── <feature>_view_model.dart
│   │       │   └── <fluxo_especifico>_view_model.dart
│   │       └── widgets/
│   │           ├── <feature>_screen.dart
│   │           └── componentes/
│   │               ├── <feature>_form.dart
│   │               ├── <feature>_card.dart
│   │               └── <feature>_filters.dart
│   └── utils/
│       ├── command.dart
│       ├── result.dart
│       ├── extensions/
│       └── log/
├── test/
│   ├── config/
│   ├── data/
│   │   ├── mappers/
│   │   ├── repositories/
│   │   └── services/
│   ├── routing/
│   └── ui/
│       ├── core/
│       └── <feature>/
├── analysis_options.yaml
├── pubspec.yaml
├── .env.example
└── README.md
```

Todos os nomes de pastas e arquivos Dart devem usar `snake_case`. Mesmo quando
se fala conceitualmente em `/Domain`, o diretório real deve ser
`lib/domain/`, em minúsculas.

Diretórios de plataforma como `ios/`, `android/`, `web/`, `macos/`, `linux/` e
`windows/` são gerados e mantidos conforme os alvos do aplicativo. Eles não
definem as camadas da aplicação e não devem receber regra de negócio. Assets e
configurações nativas específicas permanecem neles; código funcional permanece
em `lib/`.

### 3.1. Organização observada no Nexo

O Nexo já separa os módulos principais em:

- `config`: configuração, providers e controllers globais;
- `core/theme`: Material 3, tokens e cores semânticas;
- `domain`: autenticação, usuário, paginação e objetos do domínio funcional;
- `data/mappers`: tradução entre JSON e domínio;
- `data/repositories`: contratos e implementações;
- `data/services`: HTTP, autenticação, arquivos, PostgREST e storage;
- `routing`: caminhos, router, guardas e fachada de navegação;
- `ui`: features, ViewModels, telas, shell e componentes compartilhados;
- `utils`: `Result`, `Command`, extensões e logging;
- `test`: testes que espelham as principais áreas de `lib`.

As features atuais (`account`, `auth`, `evidence`, `factions`, `home`, `links`,
`people`, `search` e `shell`) servem como exemplos de separação. Seus objetos de
negócio são específicos do Nexo e não fazem parte da arquitetura obrigatória.

## 4. Inicialização da aplicação

`lib/main.dart` deve ser um composition root pequeno. Sua responsabilidade é:

1. ler a configuração do ambiente;
2. construir os providers globais;
3. criar o GoRouter;
4. aplicar tema claro, escuro e `themeMode`;
5. instalar wrappers realmente globais, quando existirem.

Estrutura base:

```dart
void main() {
  runApp(MyApp(config: AppConfig.fromEnvironment()));
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(config),
      child: const _AppRoot(),
    );
  }
}

final class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

final class _AppRootState extends State<_AppRoot> {
  late final GoRouter _router = appRouter(
    sessionManager: context.read(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: MaterialTheme(ThemeData().textTheme).light(),
      darkTheme: MaterialTheme(ThemeData().textTheme).dark(),
      themeMode: context.watch<AppSessionController>().themeMode,
      routerConfig: _router,
    );
  }
}
```

O router deve ser criado uma única vez. Criá-lo em todo `build` perde estado de
navegação e pode recriar listeners.

## 5. Configuração e ambientes

`AppConfig` é um objeto imutável com os valores externos necessários pelo app.
Ele deve:

- ler valores com `String.fromEnvironment`;
- normalizar espaços e defaults;
- validar campos obrigatórios antes de montar a árvore de dependências;
- expor apenas configurações, nunca segredos privados;
- permitir construção direta em testes por `fromValues` ou construtor;
- evitar leitura de variáveis de ambiente espalhada pelo código.

Exemplo:

```dart
final class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.publicApiKey});

  factory AppConfig.fromEnvironment() => AppConfig.fromValues(
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    publicApiKey: const String.fromEnvironment('PUBLIC_API_KEY'),
  );

  factory AppConfig.fromValues({
    required String apiBaseUrl,
    required String publicApiKey,
  }) => AppConfig(
    apiBaseUrl: apiBaseUrl.trim(),
    publicApiKey: publicApiKey.trim(),
  );

  final String apiBaseUrl;
  final String publicApiKey;

  void validate() {
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('API_BASE_URL não configurada.');
    }
    if (publicApiKey.isEmpty) {
      throw StateError('PUBLIC_API_KEY não configurada.');
    }
  }
}
```

Manter `.env.example` sem valores secretos e documentar os comandos de execução
no README. Arquivos `.env` reais não devem ser versionados nem declarados como
assets Flutter.

## 6. Camada de domínio

O domínio fica obrigatoriamente em `lib/domain/` e é organizado por entidade ou
agregado. Ele representa conceitos do negócio, não respostas da API.

### 6.1. O que pertence ao domínio

- models imutáveis;
- enums e seus valores de contrato (`wireName`);
- requests de leitura/escrita usados por repositories;
- filtros e paginação;
- regras puras e calculadas;
- value objects, quando necessários.

### 6.2. Regras dos models

- preferir `final class` e campos `final`;
- oferecer construtor `const` quando possível;
- não importar Flutter;
- não armazenar `Response`, `RequestOptions` ou outros tipos de Dio;
- não depender de Provider ou GoRouter;
- não fazer chamadas remotas;
- proteger coleções mutáveis com `List.unmodifiable`;
- usar `copyWith` quando o objeto precisar de evolução incremental;
- modelar datas como `DateTime`, bytes como `Uint8List` e estados como enums;
- não expor JSON cru para a UI.

Exemplo:

```dart
final class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.name,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final String name;
  final bool active;
  final DateTime createdAt;
}
```

### 6.3. Requests e filtros

Objetos de entrada evitam listas extensas de parâmetros e dão nome ao contrato:

```dart
final class CustomerWriteRequest {
  const CustomerWriteRequest({
    this.id,
    required this.name,
    required this.active,
  });

  final String? id;
  final String name;
  final bool active;
}

final class CustomerFilter {
  const CustomerFilter({
    this.query,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? query;
  final int page;
  final int pageSize;

  int get offset => (page - 1) * pageSize;
}
```

No Nexo alguns requests possuem `toJson()` ou `toRpcJson()`. Isso é aceitável
quando o request representa explicitamente o contrato de escrita. Para máxima
independência de backend, a alternativa preferível no novo projeto é deixar a
serialização no mapper.

### 6.4. Enums

Nunca depender de `enum.name` se o valor é persistido ou enviado ao backend.
Usar um valor explícito:

```dart
enum CustomerStatus {
  active('active'),
  blocked('blocked');

  const CustomerStatus(this.wireName);
  final String wireName;

  static CustomerStatus fromWire(String value) =>
      values.firstWhere((item) => item.wireName == value);
}
```

## 7. Result Pattern e exceções da aplicação

Toda operação falível que cruza as camadas de data, repository e ViewModel deve
retornar `Future<Result<T>>`.

```dart
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;
  const factory Result.error(AppException error) = Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);
  final T value;
}

final class Error<T> extends Result<T> {
  const Error._(this.error);
  final AppException error;
}
```

O arquivo real do Nexo fornece, além de `Ok` e `Error`:

- `isOk` e `isError`;
- `getSuccessOrNull()` e `getErrorOrNull()`;
- `map`, `flatMap` e `mapError`;
- `fold` e `when`;
- versões assíncronas para composição de resultados.

Contrato obrigatório:

```dart
Future<Result<CustomerModel>> getCustomer(String id);
Future<Result<CustomerModel>> createCustomer(CustomerWriteRequest request);
Future<Result<void>> archiveCustomer(String id);
```

Não retornar `null` para representar falha. `null` pode ser um sucesso válido
somente quando o contrato o declarar, por exemplo `Result<CustomerModel?>`.

### 7.1. Exceções tipadas

`lib/exceptions/app_exception.dart` contém a taxonomia de erros mostrada à
aplicação:

```dart
sealed class AppException implements Exception {
  AppException(this.code, this.message);

  final String code;
  final String message;
}
```

Categorias recomendadas:

- validação/requisição inválida;
- não autenticado e sessão expirada;
- acesso proibido;
- recurso não encontrado;
- conflito;
- muitas requisições;
- timeout;
- falha de comunicação;
- servidor indisponível;
- resposta incompatível com o contrato;
- erro inesperado.

O `code` deve ser estável e útil para suporte e telemetria. A `message` deve ser
segura para exibição. Stack traces, tokens, URLs sensíveis e corpo integral da
resposta não devem aparecer na mensagem de UI.

### 7.2. Onde capturar erros

- `ApiClientImpl`: converte falhas Dio e HTTP em `AppException`;
- services/adapters: convertem falhas da biblioteca adaptada;
- repository: converte erros de mapeamento e regras do repositório;
- ViewModel: propaga `Result`, sem transformar tudo em erro genérico;
- Widget: renderiza `Command.errorMessage` e ações de recuperação.

Não espalhar `try/catch` em widgets.

## 8. Camada de data e repositories por entidade

Cada entidade ou agregado deve possuir sua própria pasta:

```text
lib/data/repositories/customer/
├── customer_repository.dart
└── customer_repository_impl.dart
```

### 8.1. Interface

A interface descreve todas as operações necessárias para manipular a entidade,
usando apenas tipos de domínio e `Result`:

```dart
abstract interface class CustomerRepository {
  Future<Result<PaginatedResponse<CustomerModel>>> getCustomers(
    CustomerFilter filter,
  );

  Future<Result<CustomerModel>> getCustomer(String id);
  Future<Result<CustomerModel>> createCustomer(
    CustomerWriteRequest request,
  );
  Future<Result<CustomerModel>> updateCustomer(
    CustomerWriteRequest request,
  );
  Future<Result<void>> archiveCustomer(String id);
  Future<Result<void>> restoreCustomer(String id);
}
```

Critérios para definir a fronteira:

- um repository representa uma entidade, agregado ou capacidade coesa;
- métodos devem expressar intenção de negócio, não detalhes HTTP;
- não expor nomes de tabela, endpoints ou filtros PostgREST;
- leituras paginadas retornam `PaginatedResponse<T>`;
- escritas recebem request objects;
- exclusões lógicas devem usar verbos como `archive` e `restore`;
- deleção física só deve existir se for realmente uma regra do produto.

### 8.2. Implementação

A implementação recebe suas dependências pelo construtor e implementa somente a
interface correspondente:

```dart
final class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl({
    required ApiClient apiClient,
    required CustomerMapper mapper,
    required CustomLogger logger,
  }) : _apiClient = apiClient,
       _mapper = mapper,
       _logger = logger;

  static const _logTag = 'CustomerRepository';

  final ApiClient _apiClient;
  final CustomerMapper _mapper;
  final CustomLogger _logger;

  @override
  Future<Result<CustomerModel>> getCustomer(String id) async {
    try {
      final result = await _apiClient.get<Map<String, dynamic>>(
        '/customers/:id',
        pathParameters: {'id': id},
        decoder: (data) => Map<String, dynamic>.from(data! as Map),
      );

      return result.map((response) => _mapper.toDomain(response.data));
    } on FormatException catch (error, stackTrace) {
      _logger.error(
        'Resposta inválida ao carregar customer',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return Result.error(RespostaInvalidaException());
    } catch (error, stackTrace) {
      _logger.error(
        'Falha inesperada ao carregar customer',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return Result.error(UnknownErrorException());
    }
  }

  // create, update, list, archive e restore seguem o mesmo contrato.
}
```

Responsabilidades da implementação:

- conhecer endpoints, tabelas, RPCs e gateways;
- montar query parameters e headers específicos;
- chamar o mapper para entrada e saída;
- orquestrar múltiplas chamadas necessárias à operação;
- preservar erros já tipados retornados pelos services;
- capturar `FormatException` e `TypeError` de respostas incompatíveis;
- registrar detalhes técnicos no logger;
- sempre finalizar com `Result<T>`.

### 8.3. Regra contra repositories gigantes

O Nexo atual possui `MvpRepositoriesImpl`, que implementa muitas interfaces em
um único arquivo com mais de 1.500 linhas. Essa consolidação foi útil durante o
MVP, mas **não deve ser replicada**.

No novo projeto, separar desde o início:

```text
data/repositories/person/...
data/repositories/faction/...
data/repositories/evidence/...
data/repositories/notification/...
```

Helpers comuns de PostgREST, REST ou persistência devem ir para um gateway ou
service compartilhado; não são motivo para juntar repositories diferentes.

## 9. Mappers

Mappers isolam o domínio do formato externo:

```dart
abstract interface class DtoMapper<T> {
  T toDomain(Map<String, dynamic> json);
}

abstract interface class JsonMapper<T> {
  Map<String, dynamic> toJson(T value);
}

abstract interface class Mapper<T>
    implements DtoMapper<T>, JsonMapper<T> {}
```

Exemplo:

```dart
final class CustomerMapper implements Mapper<CustomerModel> {
  const CustomerMapper();

  @override
  CustomerModel toDomain(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    active: json['active'] as bool? ?? true,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  @override
  Map<String, dynamic> toJson(CustomerModel value) => {
    'id': value.id,
    'name': value.name.trim(),
    'active': value.active,
  };
}
```

Regras:

- um mapper não chama API;
- um mapper não altera estado global;
- o mapper é determinístico e testável isoladamente;
- valores obrigatórios inválidos devem causar `FormatException`/`TypeError`;
- defaults só devem existir quando o contrato do backend permitir;
- enums usam `fromWire` e `wireName`;
- datas de saída devem ser normalizadas, normalmente em UTC;
- mapeamento de listas pode ser fornecido por mixins/helpers genéricos.

## 10. Services, gateways e adapters

Services encapsulam tecnologia ou integrações que não são entidades de
negócio. Exemplos:

- cliente HTTP;
- persistência segura da sessão;
- refresh de token;
- seleção/processamento de arquivos;
- storage remoto;
- banco local;
- analytics e logging;
- gateway específico de um provedor.

Sempre que possível, definir interface e implementação:

```dart
abstract interface class SessionStorage {
  Future<Result<String?>> read();
  Future<Result<void>> write(String value);
  Future<Result<void>> clear();
}

final class SecureSessionStorage implements SessionStorage {
  // Adapta a biblioteca concreta.
}
```

Gateways são úteis para evitar repetição entre repositories. O Nexo usa um
`PostgrestGateway` para `select`, `selectOne`, `insert`, `update`, `delete` e
`rpc`. Em outro backend, esse módulo pode ser substituído sem alterar ViewModels
ou telas.

## 11. ApiClient abstrato e implementação com Dio

Dio não deve ser usado diretamente por ViewModels, widgets ou contratos de
repository.

### 11.1. Contrato independente

```dart
enum HttpMethod { get, post, put, patch, delete }
enum ApiResponseType { json, text, bytes }

typedef ApiResponseDecoder<T> = T Function(Object? data);

final class ApiResponse<T> {
  ApiResponse({
    required this.data,
    required this.statusCode,
    required Map<String, String> headers,
  }) : headers = Map.unmodifiable(headers);

  final T data;
  final int statusCode;
  final Map<String, String> headers;

  String? header(String name) => headers[name.toLowerCase()];
}

abstract interface class ApiClient {
  Future<Result<ApiResponse<T>>> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, Object> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
    bool authenticated = true,
    ApiResponseType responseType = ApiResponseType.json,
    ApiResponseDecoder<T>? decoder,
  });

  void close({bool force = false});
}
```

Extensões `get`, `post`, `put`, `patch` e `delete` podem delegar a `request`.

### 11.2. Configuração do Dio

O Dio deve ser criado uma vez no provider global:

```dart
Provider<Dio>(
  create: (context) => Dio(
    BaseOptions(
      baseUrl: context.read<AppConfig>().apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ),
  dispose: (_, dio) => dio.close(force: true),
),
```

`ApiClientImpl` deve:

- resolver e codificar path parameters;
- remover query parameters nulos;
- escolher `ResponseType` para JSON, texto ou bytes;
- aplicar decoder tipado;
- normalizar headers de resposta;
- considerar sucesso somente status 2xx;
- mapear 400, 401, 403, 404, 409, 422, 429 e 5xx;
- diferenciar timeout, falha de comunicação e resposta inválida;
- omitir dados sensíveis dos logs;
- retornar `Result`, nunca deixar `DioException` escapar.

### 11.3. Interceptors

Autenticação, correlation ID e logging de transporte pertencem a interceptors.
Um interceptor de autenticação pode:

1. ignorar endpoints públicos por flag em `RequestOptions.extra`;
2. obter o token do `SessionManager`;
3. anexar `Authorization`;
4. ao receber 401, renovar a sessão uma única vez;
5. repetir a requisição original;
6. impedir loop por uma flag de retry.

O refresh concorrente deve ser deduplicado para que várias respostas 401 não
disparem várias renovações simultâneas.

## 12. ViewModel e Command

Cada feature tem uma pasta `viewmodel`. O ViewModel é a única camada que a tela
usa para ler estado de negócio e disparar operações.

### 12.1. Responsabilidades do ViewModel

- receber interfaces de repository por construtor;
- manter o estado apresentado pela view;
- expor coleções imutáveis;
- validar e normalizar eventos de UI quando necessário;
- coordenar uma ou mais operações de repository;
- atualizar estado somente após sucesso;
- chamar `notifyListeners()` quando o estado observável mudar;
- expor operações assíncronas por `Command0` ou `Command1`;
- descartar todos os Commands em `dispose`.

O ViewModel não deve:

- importar Dio;
- conhecer JSON ou endpoints;
- receber `BuildContext`;
- abrir dialog, SnackBar ou rota;
- construir widgets;
- acessar implementação concreta de repository;
- ler Provider diretamente.

### 12.2. Command como reação observável

`Command` encapsula o ciclo de uma ação assíncrona:

- `running`: operação em andamento;
- `completed`: último resultado foi sucesso;
- `error`: último resultado foi falha;
- `value`: valor de sucesso;
- `exception` e `errorMessage`: falha tipada;
- `clearResult()`: limpa uma reação já consumida;
- bloqueio de execução duplicada enquanto `running` for verdadeiro.

```dart
typedef CommandAction0<T> = Future<Result<T>> Function();
typedef CommandAction1<T, A> = Future<Result<T>> Function(A argument);
```

Exemplo de ViewModel:

```dart
final class CustomerListViewModel extends ChangeNotifier {
  CustomerListViewModel({required CustomerRepository repository})
    : _repository = repository {
    load = Command0(_load);
    create = Command1(_create);
  }

  final CustomerRepository _repository;

  late final Command0<PaginatedResponse<CustomerModel>> load;
  late final Command1<CustomerModel, CustomerWriteRequest> create;

  List<CustomerModel> _items = const [];
  List<CustomerModel> get items => _items;

  Future<Result<PaginatedResponse<CustomerModel>>> _load() async {
    final result = await _repository.getCustomers(const CustomerFilter());
    if (result.isOk) {
      _items = List.unmodifiable(result.getSuccessOrNull()!.items);
      notifyListeners();
    }
    return result;
  }

  Future<Result<CustomerModel>> _create(
    CustomerWriteRequest request,
  ) async {
    final result = await _repository.createCustomer(request);
    if (result.isOk) {
      _items = List.unmodifiable([
        result.getSuccessOrNull()!,
        ..._items,
      ]);
      notifyListeners();
    }
    return result;
  }

  @override
  void dispose() {
    load.dispose();
    create.dispose();
    super.dispose();
  }
}
```

Para mais de um argumento, criar um request object e continuar usando
`Command1` em vez de adicionar `Command2`, `Command3` etc.

## 13. Camada de UI por feature

Estrutura obrigatória:

```text
ui/customer/
├── viewmodel/
│   ├── customer_list_view_model.dart
│   └── customer_form_view_model.dart
└── widgets/
    ├── customer_list_screen.dart
    ├── customer_form_screen.dart
    └── componentes/
        ├── customer_card.dart
        ├── customer_filters.dart
        └── customer_form_fields.dart
```

### 13.1. Responsabilidades da tela

- criar e descartar controllers puramente visuais, como
  `TextEditingController` e `FocusNode`;
- transformar gestos e submissões em chamadas ao ViewModel;
- observar ViewModel e Commands;
- renderizar loading, conteúdo, vazio e erro;
- realizar navegação por `AppNavigation`/GoRouter;
- mostrar feedback transitório após reações do Command;
- compor componentes locais e compartilhados;
- respeitar tema, tokens, responsividade e acessibilidade.

A tela não faz requisição, não mapeia JSON e não instancia repository.

### 13.2. Observação do estado

O padrão do Nexo usa `ListenableBuilder` e `Listenable.merge`:

```dart
ListenableBuilder(
  listenable: Listenable.merge([
    viewModel,
    viewModel.load,
    viewModel.create,
  ]),
  builder: (context, _) {
    if (viewModel.load.running && viewModel.items.isEmpty) {
      return const AppLoadingList();
    }

    if (viewModel.load.error && viewModel.items.isEmpty) {
      return AppFeedbackState(
        type: AppFeedbackType.error,
        title: 'Não foi possível carregar os dados',
        message: viewModel.load.errorMessage ?? 'Tente novamente.',
        primaryActionLabel: 'Tentar novamente',
        onPrimaryAction: viewModel.load.execute,
      );
    }

    return CustomerList(items: viewModel.items);
  },
)
```

`Consumer` e `context.watch/select` também são válidos, mas o projeto deve
escolher um padrão predominante. Prefira observar somente o menor escopo
necessário.

### 13.3. Inicialização

Uma tela stateful pode iniciar o primeiro carregamento no `initState`, desde que
evite duplicação:

```dart
@override
void initState() {
  super.initState();
  if (widget.viewModel.items.isEmpty && !widget.viewModel.load.running) {
    widget.viewModel.load.execute();
  }
}
```

Quando o carregamento precisa ocorrer antes da primeira tela de toda a feature,
o provider pode usar `lazy: false` e executar o comando na criação. Não repetir
as duas estratégias para o mesmo dado.

### 13.4. Componentes locais

Componentes específicos da feature ficam em
`widgets/componentes/`. Widgets muito pequenos e usados apenas em um arquivo
podem ser classes privadas no mesmo arquivo. Extrair quando:

- o componente tiver responsabilidade própria;
- for reutilizado por duas telas da feature;
- o arquivo da tela ficar difícil de navegar;
- houver estado visual independente;
- fizer sentido testá-lo isoladamente.

Telas com milhares de linhas, como algumas telas de cadastro e detalhe do MVP
atual, não devem ser usadas como referência. Dividir por seções, cards,
formulários, filtros e estados.

## 14. Componentes reutilizáveis

Componentes usados por várias features ficam em:

```text
lib/ui/core/componentes_reutilizaveis/
```

Um componente compartilhado deve:

- não conhecer repository, endpoint ou entidade específica;
- receber dados e callbacks por parâmetros;
- usar widgets Material 3 antes de criar desenho próprio;
- consumir `Theme.of(context)`, `ColorScheme`, `TextTheme` e tokens;
- ter comportamento responsivo;
- incluir semântica, tooltip e áreas de toque adequadas;
- possuir teste de widget quando tiver comportamento relevante.

Catálogo reutilizável comprovado pelo Nexo:

- `AppResponsiveScaffold`: navegação inferior, rail ou drawer por breakpoint;
- `AppPageContainer`: padding e largura máxima consistentes;
- `AppSearchField`: busca, submissão e limpeza;
- `AppFilterButton`: filtros com contador ativo;
- `AppEntityAvatar`: avatar/fallback padronizado;
- `AppStatusChip`: estado visual semântico;
- `AppRecordCard`: apresentação consistente de registros;
- `AppSectionHeader`: título e ação de seção;
- `AppKeyValueRow`: pares de rótulo/valor;
- `AppNoticeBanner`: aviso persistente com ação;
- `AppStepProgress`: progresso de formulários em etapas;
- `AppFormActions`: ações principal e secundária;
- `AppFeedbackState`: vazio, erro, offline e sucesso;
- `AppLoadingList`: skeleton/lista de carregamento;
- `AppModalSheet`: modal com largura e layout consistentes;
- `AppSemanticTone`: tradução de intenção para cores do tema.

Componentes de mapa, grafo, mídia ou conectividade não fazem parte do baseline;
devem existir apenas quando o novo produto realmente precisar deles.

## 15. Injeção de dependências com Provider

Provider é o mecanismo de composição oficial. Dependências são declaradas em
ordem: uma dependência só pode ler providers anteriores.

### 15.1. Escopos

**Escopo da aplicação**, em `app_providers.dart`:

- `AppConfig`;
- logger;
- Dio;
- ApiClient;
- storage e sessão;
- interceptors;
- mappers stateless;
- gateways;
- repositories;
- controllers realmente globais.

**Escopo de shell ou feature**, em `feature_providers.dart`:

- ViewModels compartilhados por várias rotas da mesma área;
- estado que deve sobreviver à navegação entre páginas filhas;
- sessão de perfil e navegação principal.

**Escopo de rota**:

- ViewModel de formulário;
- ViewModel de detalhe descartável;
- fluxos temporários;
- estado que deve ser recriado ao reabrir a página.

### 15.2. Registro recomendado

```dart
List<SingleChildWidget> buildAppProviders(AppConfig config) => [
  Provider<AppConfig>.value(value: config),
  Provider<CustomLogger>(
    create: (_) => CustomLoggerImpl(logger: Logger()),
  ),
  Provider<Dio>(
    create: (context) => buildDio(context.read()),
    dispose: (_, dio) => dio.close(force: true),
  ),
  Provider<ApiClient>(
    create: (context) => ApiClientImpl(
      dio: context.read(),
      logger: context.read(),
    ),
  ),
  Provider<CustomerMapper>(create: (_) => const CustomerMapper()),
  Provider<CustomerRepository>(
    create: (context) => CustomerRepositoryImpl(
      apiClient: context.read(),
      mapper: context.read(),
      logger: context.read(),
    ),
  ),
];
```

Registrar pela interface (`Provider<CustomerRepository>`), não apenas pela
implementação. Isso torna substituição e teste diretos.

```dart
List<SingleChildWidget> buildCustomerProviders() => [
  ChangeNotifierProvider<CustomerListViewModel>(
    create: (context) => CustomerListViewModel(
      repository: context.read(),
    ),
  ),
];
```

### 15.3. Regras de lifecycle

- usar `Provider` para objetos sem notificação;
- usar `ChangeNotifierProvider` para ViewModels/controllers observáveis;
- fornecer objetos já existentes com `.value`;
- fechar Dio e outros recursos em `dispose`;
- ViewModel descarta Commands e subscriptions;
- não criar objetos novos dentro de `build` sem necessidade;
- evitar providers globais para estado de formulário;
- não usar Provider como service locator dentro da lógica de negócio;
- `context.read` é apropriado em composition roots e builders de rota;
- widgets recebem preferencialmente o ViewModel por construtor.

## 16. Navegação exclusivamente com GoRouter

Toda navegação de página deve passar pelo GoRouter. `Navigator` direto fica
restrito a overlays locais quando a API Material exigir, como fechamento de
dialog/bottom sheet. Não usar `MaterialPageRoute` nas features.

### 16.1. Arquivos e responsabilidades

`routes.dart`:

- constantes de path;
- helpers para path parameters;
- helpers para query parameters com `Uri`.

`router.dart`:

- árvore de `GoRoute` e `ShellRoute`;
- criação de providers por shell/rota;
- extração de path/query parameters;
- guardas de autorização;
- error page.

`app_navigation.dart`:

- fachada semântica usada pelos widgets;
- escolha entre `go`, `push`, `pop` e resultado tipado;
- construção de locations pelos helpers de `Routes`.

`auth_route_guard.dart`:

- decisão pura de redirect;
- distinção entre autenticação desconhecida, autenticada e não autenticada;
- lista de rotas públicas.

### 16.2. Paths centralizados

```dart
abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const customers = '/customers';
  static const customerCreate = '/customers/new';
  static const customer = '/customers/:customerId';

  static String customerPath(String id) => '/customers/$id';

  static String customerCreatePath({String? draftId}) => Uri(
    path: customerCreate,
    queryParameters: draftId == null ? null : {'draft': draftId},
  ).toString();
}
```

Não concatenar query string manualmente.

### 16.3. Fachada de navegação

```dart
abstract final class AppNavigation {
  static void goToCustomers(BuildContext context) {
    context.go(Routes.customers);
  }

  static Future<bool?> goToCustomer(
    BuildContext context,
    String id,
  ) => context.push<bool>(Routes.customerPath(id));

  static void completeCustomerChange(BuildContext context) {
    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go(Routes.customers);
    }
  }
}
```

Resultados de `push<T>` permitem atualizar a lista somente quando a tela filha
alterar algo.

### 16.4. Router, shell e providers locais

```dart
GoRouter appRouter({required SessionManager sessionManager}) {
  final guard = AuthRouteGuard(
    sessionManager: sessionManager,
    loginLocation: Routes.login,
    authenticatedHomeLocation: Routes.home,
  );

  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: sessionManager,
    redirect: (_, state) => guard.redirect(state.matchedLocation),
    routes: [
      GoRoute(path: Routes.login, builder: buildLogin),
      ShellRoute(
        builder: (context, state, child) => MultiProvider(
          providers: buildAuthenticatedFeatureProviders(),
          child: child,
        ),
        routes: [
          GoRoute(path: Routes.home, builder: buildHome),
          GoRoute(path: Routes.customers, builder: buildCustomerList),
          GoRoute(
            path: Routes.customerCreate,
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) => CustomerFormViewModel(
                repository: context.read(),
              ),
              child: Builder(
                builder: (context) => CustomerFormScreen(
                  viewModel: context.read<CustomerFormViewModel>(),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
```

`refreshListenable` faz o router reavaliar o redirect após login, logout,
expiração ou restauração da sessão.

## 17. Tema e design system

O ponto único de tema é obrigatoriamente:

```text
lib/core/theme/theme.dart
```

O app deve usar:

```dart
MaterialApp.router(
  theme: MaterialTheme(ThemeData().textTheme).light(),
  darkTheme: MaterialTheme(ThemeData().textTheme).dark(),
  themeMode: sessionController.themeMode,
  routerConfig: router,
)
```

Regras:

- Material Design 3 com `useMaterial3: true`;
- `ColorScheme` completo para claro e escuro;
- `TextTheme` como fonte de tipografia;
- cores semânticas adicionais em `ThemeExtension`;
- espaçamentos, raios, breakpoints e tamanhos em `app_tokens.dart`;
- nenhum `ThemeData` criado dentro de uma feature;
- evitar cores diretas em telas;
- evitar tamanhos mágicos repetidos;
- preferir componentes Material nativos;
- modo do tema controlado por estado de sessão/preferências.

Tokens observados e reutilizáveis:

```text
AppSpacing: xs 4, sm 8, md 16, lg 24, xl 32
AppRadius: sm 8, md 12, lg 16, full 999
AppBreakpoints: tablet 600, expanded 840, desktop 1200, wide 1440
AppSizes: área de toque 48 e limites de largura por componente
```

O Nexo possui ainda `lib/ui/core/themes/colors.dart` e `dimens.dart`, herdados
de uma organização anterior. No novo projeto, **não duplicar o design system**:
usar apenas `lib/core/theme/` e migrar qualquer token ainda necessário para lá.

As regras visuais detalhadas e o catálogo de componentes do projeto atual estão
em `docs/interface.md` e complementam este documento.

## 18. Responsividade e acessibilidade

A UI deve ser adaptativa, não apenas redimensionável.

Padrão do Nexo:

- abaixo de 600 px: navegação inferior e conteúdo em uma coluna;
- a partir de 600 px: `NavigationRail`;
- a partir de 840 px: layouts mestre/detalhe quando úteis;
- a partir de 1200 px: `NavigationDrawer` expandível;
- conteúdo central com largura máxima em telas muito amplas.

Usar `LayoutBuilder` para decisões baseadas no espaço do componente e
`MediaQuery.sizeOf` para decisões de viewport.

Checklist de acessibilidade:

- tooltips em ações somente com ícone;
- área de toque mínima de 48 px;
- `Semantics` em estados e controles compostos;
- `liveRegion` para erros importantes;
- labels que não dependem apenas de cor;
- contraste provido pelo `ColorScheme`;
- suporte a teclado e foco;
- campos com `textInputAction`, autofill e validação;
- não remover comportamento nativo de hover, focus, pressed e disabled.

## 19. Sessão, autenticação e autorização

Quando o app tiver autenticação, separar:

- `AuthRepository`: login, logout e restauração;
- `SessionStorage`: persistência segura;
- `SessionManager`: estado, expiração e refresh;
- `AuthInterceptor`: token e retry;
- `AuthRouteGuard`: proteção de rotas;
- `AppSessionController`: preferências globais ligadas à sessão.

Regras de segurança:

- tokens não pertencem a models genéricos de UI;
- persistir sessão somente quando a regra do produto permitir;
- usar storage seguro, nunca preferences comuns para credenciais;
- limpar sessão local mesmo se o logout remoto falhar;
- não logar senha, token, header Authorization ou payload sensível;
- autorização real deve existir no backend;
- capabilities na UI servem para apresentação e prevenção de ações, não como
  única barreira de segurança;
- diferenciar estado `unknown` durante restauração para evitar redirects
  prematuros.

Recursos como auto-lock e preferências de tema podem ficar em um controller
global observável, desde que não sejam misturados ao ViewModel de uma feature.

## 20. Logging e observabilidade

Usar uma abstração própria:

```dart
abstract interface class CustomLogger {
  void info(String message, {String? tag});
  void warning(String message, {String? tag, Object? error});
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  });
  void debug(String message, {String? tag});
}
```

Cada classe de data deve ter uma tag estável. A implementação pode adaptar
`logger`, console do navegador ou um serviço de telemetria sem alterar
repositories.

Sanitizar:

- tokens e credenciais;
- parâmetros sensíveis;
- fragmentos/query strings de URLs;
- stack traces antes de enviar para console remoto;
- documentos pessoais e dados privados.

## 21. Dependências do projeto-base

### 21.1. Dependências arquiteturais essenciais

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: <versão compatível>
  go_router: <versão compatível>
  dio: <versão compatível>
```

Esses pacotes materializam as decisões obrigatórias de UI, DI, navegação e
transporte.

### 21.2. Dependências comuns, mas condicionais

- `logger`: implementação do logger abstrato;
- `flutter_secure_storage`: quando existir autenticação persistente;
- `intl`: quando houver formatação e localização;
- `cupertino_icons`: apenas ícones, se realmente usados;
- bibliotecas de banco local, analytics ou serialização somente conforme a
  necessidade do novo produto.

### 21.3. Dependências específicas do Nexo que não pertencem ao template

As dependências abaixo não são requisitos arquiteturais e não devem ser
copiadas automaticamente:

```yaml
crypto: ^3.0.7
graphview: ^1.5.1
file_selector: ^1.1.0
image_picker: ^1.2.3
flutter_map: ^8.3.1
latlong2: ^0.9.1
connectivity_plus: ^6.1.5
```

Também devem ser avaliadas como opcionais, pois atendem a funcionalidades
concretas do Nexo:

- `image`: processamento de imagens;
- `pdfrx`: visualização de PDF;
- `url_launcher`: abertura de URLs externas.

No cadastro de pessoas, `image_picker` atende exclusivamente à captura de foto
pela câmera. O pacote fica restrito a
`data/services/files/file_selection_service.dart`, atrás de
`FileSelectionService` e da origem tipada `PhotoInputSource`. O ViewModel recebe
essa interface por Provider e expõe a operação por `Command`; widgets não
importam nem instanciam o plugin. Ambientes sem câmera devolvem `Result.error` e
continuam oferecendo a seleção de arquivo por `file_selector`.

Não copiar dependência por conveniência. Para cada pacote novo, documentar qual
abstração o isola e qual requisito ele atende.

## 22. Testes

`test/` deve espelhar a arquitetura de `lib/`:

```text
test/
├── config/
├── data/
│   ├── mappers/
│   ├── repositories/<entidade>/
│   └── services/api_client/
├── routing/
└── ui/
    ├── core/componentes_reutilizaveis/
    └── <feature>/
        ├── viewmodel/
        └── widgets/
```

Cobertura mínima por tipo:

**Domain**

- regras puras, `copyWith`, filtros, paginação e enums.

**Mapper**

- JSON completo;
- campos opcionais;
- enums;
- datas;
- resposta inválida.

**ApiClient**

- path e query parameters;
- headers e autenticação;
- chamada pública;
- decoder;
- bytes/texto;
- erro HTTP conhecido;
- timeout e conexão;
- resposta incompatível.

**Repository**

- endpoint/gateway e payload corretos;
- orquestração do mapper;
- propagação do erro do service;
- conversão de resposta inválida;
- paginação;
- create/update/archive/restore.

**ViewModel**

- execução pelo Command;
- `running`, sucesso e erro;
- atualização somente no sucesso;
- listas imutáveis;
- paginação, filtros e seleção;
- descarte dos Commands.

**Widget**

- loading inicial;
- estado vazio;
- erro e retry;
- conteúdo;
- validação de formulário;
- permissões/capabilities;
- responsividade nos breakpoints;
- comportamento dos componentes reutilizáveis.

**Routing**

- paths e query parameters;
- resultado de navegação;
- redirect autenticado/não autenticado;
- rota não encontrada.

Preferir fakes pequenos que implementam interfaces. Como ViewModels dependem de
contratos e o ApiClient esconde Dio, os testes não precisam de rede real.

Comandos de verificação:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## 23. Fluxos de referência

### 23.1. Leitura de lista

```text
initState
  → viewModel.load.execute()
  → Command define running = true
  → repository.getEntities(filter)
  → gateway/ApiClient
  → Dio
  → decoder
  → mapper.toDomain
  → Result.ok(PaginatedResponse)
  → ViewModel substitui lista por List.unmodifiable
  → notifyListeners
  → Command define running = false e completed = true
  → Widget renderiza conteúdo
```

### 23.2. Falha

```text
DioException/HTTP inválido
  → ApiClientImpl converte em AppException
  → Result.error
  → Repository preserva o erro
  → Command expõe exception/errorMessage
  → Widget mostra AppFeedbackState ou AppNoticeBanner
  → usuário executa retry
```

### 23.3. Formulário e retorno de rota

```text
Widget valida campos locais
  → cria EntityWriteRequest
  → viewModel.save.execute(request)
  → repository.create/update
  → Result.ok(entity)
  → Command.completed
  → AppNavigation.completeEntityChange(context)
  → context.pop(true ou entity.id)
  → tela anterior recebe resultado
  → refresh.execute()
```

## 24. Processo para criar uma nova feature

Exemplo para a entidade `customer`:

1. Criar models, enums, requests e filtros em `domain/customer/`.
2. Criar `CustomerMapper` e seus testes.
3. Criar `data/repositories/customer/customer_repository.dart` com todas as
   operações necessárias.
4. Criar `CustomerRepositoryImpl`, usando ApiClient/gateway e mapper.
5. Testar o repository com ApiClient/gateway fake.
6. Registrar mapper e repository em `app_providers.dart` pela interface.
7. Criar `ui/customer/viewmodel/customer_list_view_model.dart`.
8. Criar ViewModel separado para formulário/detalhe se o lifecycle for
   diferente.
9. Expor operações assíncronas por Commands.
10. Criar telas em `ui/customer/widgets/`.
11. Extrair componentes da feature para `widgets/componentes/`.
12. Promover para `ui/core/componentes_reutilizaveis/` somente componentes
    realmente genéricos.
13. Adicionar paths em `Routes`.
14. Adicionar métodos semânticos em `AppNavigation`.
15. Registrar as rotas e providers no escopo correto.
16. Cobrir loading, erro, vazio, conteúdo e permissões.
17. Testar ViewModel, widgets e navegação.
18. Executar format, analyze e test.

## 25. Convenções de código

- arquivos e pastas: `snake_case`;
- classes: `UpperCamelCase`;
- variáveis, métodos e parâmetros: `lowerCamelCase`;
- interface: `<Entity>Repository`;
- implementação: `<Entity>RepositoryImpl`;
- mapper: `<Entity>Mapper`;
- model: `<Entity>Model`;
- request: `<Action><Entity>Request` ou `<Entity>WriteRequest`;
- ViewModel: `<Feature><Purpose>ViewModel`;
- tela: `<Feature><Purpose>Screen`;
- componentes compartilhados: prefixo `App`;
- classes que não devem ser estendidas: `final class`;
- namespaces estáticos: `abstract final class`;
- contratos: `abstract interface class`;
- propriedades internas privadas e leitura externa por getters;
- collections expostas como imutáveis;
- imports absolutos com `package:<app>/...`;
- evitar arquivos barrel grandes, pois ocultam dependências e criam ciclos.

## 26. Anti-patterns que não devem ser replicados

- repository único implementando entidades não relacionadas;
- arquivos de tela com milhares de linhas;
- widgets chamando Dio, gateway ou repository diretamente;
- ViewModel recebendo `BuildContext`;
- ViewModel navegando ou abrindo dialog;
- `Map<String, dynamic>` atravessando a camada de data;
- exceptions técnicas escapando sem conversão para `AppException`;
- método de repository retornando valor cru em vez de `Result`;
- implementação registrada e consumida diretamente quando existe interface;
- Provider global para estado temporário de formulário;
- criação de Dio ou router em todo `build`;
- strings de rota espalhadas pelas telas;
- `Navigator.push(MaterialPageRoute(...))` para navegação de páginas;
- cores, tipografia e breakpoints definidos localmente;
- design systems duplicados;
- componentes reutilizáveis contendo regra de negócio;
- dependência adicionada sem abstração e sem requisito explícito;
- arquivos inteiros comentados mantidos como “template”.

## 27. Estado atual versus padrão a reutilizar

| Elemento observado no Nexo | Decisão para o novo projeto |
|---|---|
| `ui/<feature>/widgets` e `viewmodel` | Manter |
| componentes globais em `ui/core/componentes_reutilizaveis` | Manter |
| `Command` + `Result` | Manter |
| `ApiClient` abstrato + `ApiClientImpl` com Dio | Manter |
| Provider por app, feature e rota | Manter |
| GoRouter, `Routes`, `AppNavigation` e guard | Manter |
| tema em `core/theme/theme.dart` | Manter como fonte única |
| domínio em `lib/domain` | Manter e dividir por entidade |
| `domain/mvp_models.dart` e `mvp_requests.dart` muito grandes | Dividir em arquivos/pastas por entidade |
| interfaces de repository em `data/repositories` | Manter |
| `MvpRepositoriesImpl` agregado | Dividir em implementations por entidade |
| `services/api_client/api_client/` com pasta repetida | Simplificar para `services/api_client/` |
| `lib/model/repository/ship` comentado/legado | Remover; não usar `model` como segunda raiz |
| `data/repositories/militar` comentado/legado | Remover ou implementar no padrão real |
| `ui/core/themes` paralelo a `core/theme` | Consolidar em `core/theme` |
| `ui/home/home_screen.dart` fora de `widgets` | Colocar todas as telas da feature em `widgets` |
| componentes locais privados em telas enormes | Extrair para `widgets/componentes` |
| services de arquivo acessados diretamente por algumas telas | Injetar no ViewModel e expor a ação por Command |
| services específicos de Supabase | Manter somente se o novo backend for Supabase |
| mapa, grafo, mídia e conectividade | Adicionar somente por requisito |
| diretório `supabase/` com migrations/functions | Opcional e específico do backend |

## 28. Checklist de conformidade arquitetural

Antes de considerar uma feature concluída:

### Domínio

- [ ] Models e requests estão em `lib/domain/<entidade>/`.
- [ ] Objetos de domínio não importam Flutter, Dio, Provider ou GoRouter.
- [ ] Enums persistidos possuem `wireName` explícito.
- [ ] Collections expostas são imutáveis.

### Data

- [ ] Existe uma pasta de repository por entidade/agregado.
- [ ] A implementação implementa sua interface correspondente.
- [ ] Todos os métodos falíveis retornam `Future<Result<T>>`.
- [ ] O repository contém todas as operações necessárias da entidade.
- [ ] JSON é convertido por mapper.
- [ ] Dio aparece somente no adapter/ApiClient e infraestrutura autorizada.
- [ ] Erros técnicos são convertidos para `AppException`.

### UI e ViewModel

- [ ] A feature possui `widgets` e `viewmodel`.
- [ ] Componentes locais maiores estão em `widgets/componentes`.
- [ ] A tela conversa com o ViewModel, não com data services.
- [ ] Operações assíncronas são Commands.
- [ ] Commands são descartados no `dispose`.
- [ ] Loading, vazio, erro, conteúdo e retry estão cobertos.
- [ ] Componentes comuns foram reutilizados quando apropriado.

### Composição e navegação

- [ ] A dependência foi registrada pela interface no Provider.
- [ ] O ViewModel está no menor escopo necessário.
- [ ] Paths estão em `Routes`.
- [ ] Navegação da tela passa por `AppNavigation`/GoRouter.
- [ ] Guardas usam estado observável e `refreshListenable`.

### Design system

- [ ] O tema vem de `lib/core/theme/theme.dart`.
- [ ] A tela usa Material 3, `ColorScheme`, `TextTheme` e tokens.
- [ ] Não foi criado um segundo arquivo/pacote de tema.
- [ ] A UI é responsiva e acessível.

### Qualidade

- [ ] Mapper, repository e ViewModel têm testes.
- [ ] Estados relevantes da tela têm testes de widget.
- [ ] Rotas novas têm teste quando carregam parâmetros ou retornam resultado.
- [ ] `dart format`, `flutter analyze` e `flutter test` passam.

## 29. Resumo executivo para iniciar outro app

Para reproduzir esta arquitetura em outro projeto:

1. copiar/adaptar primeiro os fundamentos: `Result`, `Command`,
   `AppException`, logger, ApiClient e tema;
2. configurar Provider e Dio no composition root;
3. configurar GoRouter, rotas e guardas;
4. criar o domínio por entidade;
5. criar mapper e repository por entidade;
6. criar cada UI como feature com `viewmodel`, `widgets` e
   `widgets/componentes`;
7. construir um catálogo pequeno de componentes reutilizáveis;
8. manter dependências específicas fora do template até surgir um requisito;
9. espelhar `lib` em `test`;
10. rejeitar qualquer dependência que atravesse as fronteiras descritas neste
    documento.

O resultado é uma base em que a UI reage a Commands, os ViewModels orquestram
contratos, os repositories concentram persistência e mapeamento, o ApiClient
isola Dio e todo o conjunto pode ser substituído e testado por camada.
