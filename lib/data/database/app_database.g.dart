// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PasswordsTableTable extends PasswordsTable
    with TableInfo<$PasswordsTableTable, PasswordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    title,
    username,
    password,
    url,
    notes,
    tags,
    favorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passwords_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PasswordsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PasswordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PasswordsTableTable createAlias(String alias) {
    return $PasswordsTableTable(attachedDatabase, alias);
  }
}

class PasswordsTableData extends DataClass
    implements Insertable<PasswordsTableData> {
  /// Chave primaria (UUID).
  final String id;

  /// FK para categoria (nullable).
  final String? categoryId;

  /// Titulo da credencial.
  final String title;

  /// Nome de usuario (texto claro, permite busca).
  final String username;

  /// Senha (criptografada com AES-256-GCM na camada de servico).
  final String password;

  /// URL do servico (nullable).
  final String? url;

  /// Observacoes (criptografadas, nullable).
  final String? notes;

  /// Tags como JSON array serializado (ex: '["dev","work"]').
  final String tags;

  /// Se esta nos favoritos.
  final bool favorite;

  /// Data/hora de criacao (ISO 8601).
  final String createdAt;

  /// Data/hora da ultima atualizacao (ISO 8601).
  final String updatedAt;
  const PasswordsTableData({
    required this.id,
    this.categoryId,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
    required this.tags,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['title'] = Variable<String>(title);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['tags'] = Variable<String>(tags);
    map['favorite'] = Variable<bool>(favorite);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  PasswordsTableCompanion toCompanion(bool nullToAbsent) {
    return PasswordsTableCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      title: Value(title),
      username: Value(username),
      password: Value(password),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: Value(tags),
      favorite: Value(favorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PasswordsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordsTableData(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      url: serializer.fromJson<String?>(json['url']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String?>(categoryId),
      'title': serializer.toJson<String>(title),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'url': serializer.toJson<String?>(url),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String>(tags),
      'favorite': serializer.toJson<bool>(favorite),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  PasswordsTableData copyWith({
    String? id,
    Value<String?> categoryId = const Value.absent(),
    String? title,
    String? username,
    String? password,
    Value<String?> url = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? tags,
    bool? favorite,
    String? createdAt,
    String? updatedAt,
  }) => PasswordsTableData(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    title: title ?? this.title,
    username: username ?? this.username,
    password: password ?? this.password,
    url: url.present ? url.value : this.url,
    notes: notes.present ? notes.value : this.notes,
    tags: tags ?? this.tags,
    favorite: favorite ?? this.favorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PasswordsTableData copyWithCompanion(PasswordsTableCompanion data) {
    return PasswordsTableData(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      url: data.url.present ? data.url.value : this.url,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordsTableData(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('url: $url, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('favorite: $favorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    title,
    username,
    password,
    url,
    notes,
    tags,
    favorite,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordsTableData &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.username == this.username &&
          other.password == this.password &&
          other.url == this.url &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.favorite == this.favorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PasswordsTableCompanion extends UpdateCompanion<PasswordsTableData> {
  final Value<String> id;
  final Value<String?> categoryId;
  final Value<String> title;
  final Value<String> username;
  final Value<String> password;
  final Value<String?> url;
  final Value<String?> notes;
  final Value<String> tags;
  final Value<bool> favorite;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const PasswordsTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.url = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.favorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PasswordsTableCompanion.insert({
    required String id,
    this.categoryId = const Value.absent(),
    required String title,
    required String username,
    required String password,
    this.url = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.favorite = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       username = Value(username),
       password = Value(password),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PasswordsTableData> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? url,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<bool>? favorite,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (url != null) 'url': url,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (favorite != null) 'favorite': favorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PasswordsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? categoryId,
    Value<String>? title,
    Value<String>? username,
    Value<String>? password,
    Value<String?>? url,
    Value<String?>? notes,
    Value<String>? tags,
    Value<bool>? favorite,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return PasswordsTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordsTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('url: $url, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('favorite: $favorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  /// Chave primaria (UUID).
  final String id;

  /// Nome da categoria.
  final String name;

  /// Identificador do icone (nullable).
  final String? icon;

  /// Cor em formato ARGB int (nullable).
  final int? color;

  /// Data/hora de criacao (ISO 8601).
  final String createdAt;
  const CategoriesTableData({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<int?>(color),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  CategoriesTableData copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<int?> color = const Value.absent(),
    String? createdAt,
  }) => CategoriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int?> color;
  final Value<String> createdAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<int?>? color,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupMetaTableTable extends BackupMetaTable
    with TableInfo<$BackupMetaTableTable, BackupMetaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupMetaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('main'),
  );
  static const VerificationMeta _lastBackupMeta = const VerificationMeta(
    'lastBackup',
  );
  @override
  late final GeneratedColumn<String> lastBackup = GeneratedColumn<String>(
    'last_backup',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudPathMeta = const VerificationMeta(
    'cloudPath',
  );
  @override
  late final GeneratedColumn<String> cloudPath = GeneratedColumn<String>(
    'cloud_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lastBackup, fileHash, cloudPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_meta_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackupMetaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_backup')) {
      context.handle(
        _lastBackupMeta,
        lastBackup.isAcceptableOrUnknown(data['last_backup']!, _lastBackupMeta),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('cloud_path')) {
      context.handle(
        _cloudPathMeta,
        cloudPath.isAcceptableOrUnknown(data['cloud_path']!, _cloudPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupMetaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupMetaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lastBackup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_backup'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      cloudPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_path'],
      ),
    );
  }

  @override
  $BackupMetaTableTable createAlias(String alias) {
    return $BackupMetaTableTable(attachedDatabase, alias);
  }
}

class BackupMetaTableData extends DataClass
    implements Insertable<BackupMetaTableData> {
  /// Identificador do registro (sempre "main").
  final String id;

  /// Data/hora do ultimo backup (ISO 8601, nullable).
  final String? lastBackup;

  /// Hash do ultimo arquivo de backup (nullable).
  final String? fileHash;

  /// Caminho do arquivo na nuvem (nullable).
  final String? cloudPath;
  const BackupMetaTableData({
    required this.id,
    this.lastBackup,
    this.fileHash,
    this.cloudPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || lastBackup != null) {
      map['last_backup'] = Variable<String>(lastBackup);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || cloudPath != null) {
      map['cloud_path'] = Variable<String>(cloudPath);
    }
    return map;
  }

  BackupMetaTableCompanion toCompanion(bool nullToAbsent) {
    return BackupMetaTableCompanion(
      id: Value(id),
      lastBackup: lastBackup == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackup),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      cloudPath: cloudPath == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudPath),
    );
  }

  factory BackupMetaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupMetaTableData(
      id: serializer.fromJson<String>(json['id']),
      lastBackup: serializer.fromJson<String?>(json['lastBackup']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      cloudPath: serializer.fromJson<String?>(json['cloudPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lastBackup': serializer.toJson<String?>(lastBackup),
      'fileHash': serializer.toJson<String?>(fileHash),
      'cloudPath': serializer.toJson<String?>(cloudPath),
    };
  }

  BackupMetaTableData copyWith({
    String? id,
    Value<String?> lastBackup = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
    Value<String?> cloudPath = const Value.absent(),
  }) => BackupMetaTableData(
    id: id ?? this.id,
    lastBackup: lastBackup.present ? lastBackup.value : this.lastBackup,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    cloudPath: cloudPath.present ? cloudPath.value : this.cloudPath,
  );
  BackupMetaTableData copyWithCompanion(BackupMetaTableCompanion data) {
    return BackupMetaTableData(
      id: data.id.present ? data.id.value : this.id,
      lastBackup: data.lastBackup.present
          ? data.lastBackup.value
          : this.lastBackup,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      cloudPath: data.cloudPath.present ? data.cloudPath.value : this.cloudPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupMetaTableData(')
          ..write('id: $id, ')
          ..write('lastBackup: $lastBackup, ')
          ..write('fileHash: $fileHash, ')
          ..write('cloudPath: $cloudPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastBackup, fileHash, cloudPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupMetaTableData &&
          other.id == this.id &&
          other.lastBackup == this.lastBackup &&
          other.fileHash == this.fileHash &&
          other.cloudPath == this.cloudPath);
}

class BackupMetaTableCompanion extends UpdateCompanion<BackupMetaTableData> {
  final Value<String> id;
  final Value<String?> lastBackup;
  final Value<String?> fileHash;
  final Value<String?> cloudPath;
  final Value<int> rowid;
  const BackupMetaTableCompanion({
    this.id = const Value.absent(),
    this.lastBackup = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.cloudPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupMetaTableCompanion.insert({
    this.id = const Value.absent(),
    this.lastBackup = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.cloudPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<BackupMetaTableData> custom({
    Expression<String>? id,
    Expression<String>? lastBackup,
    Expression<String>? fileHash,
    Expression<String>? cloudPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastBackup != null) 'last_backup': lastBackup,
      if (fileHash != null) 'file_hash': fileHash,
      if (cloudPath != null) 'cloud_path': cloudPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupMetaTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? lastBackup,
    Value<String?>? fileHash,
    Value<String?>? cloudPath,
    Value<int>? rowid,
  }) {
    return BackupMetaTableCompanion(
      id: id ?? this.id,
      lastBackup: lastBackup ?? this.lastBackup,
      fileHash: fileHash ?? this.fileHash,
      cloudPath: cloudPath ?? this.cloudPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lastBackup.present) {
      map['last_backup'] = Variable<String>(lastBackup.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (cloudPath.present) {
      map['cloud_path'] = Variable<String>(cloudPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupMetaTableCompanion(')
          ..write('id: $id, ')
          ..write('lastBackup: $lastBackup, ')
          ..write('fileHash: $fileHash, ')
          ..write('cloudPath: $cloudPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaultStateTableTable extends VaultStateTable
    with TableInfo<$VaultStateTableTable, VaultStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('vault_state'),
  );
  static const VerificationMeta _lockedMeta = const VerificationMeta('locked');
  @override
  late final GeneratedColumn<String> locked = GeneratedColumn<String>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('true'),
  );
  static const VerificationMeta _failedAttemptsMeta = const VerificationMeta(
    'failedAttempts',
  );
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
    'failed_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lockUntilMeta = const VerificationMeta(
    'lockUntil',
  );
  @override
  late final GeneratedColumn<String> lockUntil = GeneratedColumn<String>(
    'lock_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, locked, failedAttempts, lockUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locked')) {
      context.handle(
        _lockedMeta,
        locked.isAcceptableOrUnknown(data['locked']!, _lockedMeta),
      );
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
        _failedAttemptsMeta,
        failedAttempts.isAcceptableOrUnknown(
          data['failed_attempts']!,
          _failedAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('lock_until')) {
      context.handle(
        _lockUntilMeta,
        lockUntil.isAcceptableOrUnknown(data['lock_until']!, _lockUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultStateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultStateTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      locked: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locked'],
      )!,
      failedAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_attempts'],
      )!,
      lockUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lock_until'],
      ),
    );
  }

  @override
  $VaultStateTableTable createAlias(String alias) {
    return $VaultStateTableTable(attachedDatabase, alias);
  }
}

class VaultStateTableData extends DataClass
    implements Insertable<VaultStateTableData> {
  /// Identificador do registro (sempre "vault_state").
  final String id;

  /// Se o vault esta bloqueado (armazenado como texto "true"/"false").
  final String locked;

  /// Numero de tentativas falhas consecutivas.
  final int failedAttempts;

  /// Data/hora ate qual o vault fica bloqueado (ISO 8601, nullable).
  final String? lockUntil;
  const VaultStateTableData({
    required this.id,
    required this.locked,
    required this.failedAttempts,
    this.lockUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['locked'] = Variable<String>(locked);
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockUntil != null) {
      map['lock_until'] = Variable<String>(lockUntil);
    }
    return map;
  }

  VaultStateTableCompanion toCompanion(bool nullToAbsent) {
    return VaultStateTableCompanion(
      id: Value(id),
      locked: Value(locked),
      failedAttempts: Value(failedAttempts),
      lockUntil: lockUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockUntil),
    );
  }

  factory VaultStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultStateTableData(
      id: serializer.fromJson<String>(json['id']),
      locked: serializer.fromJson<String>(json['locked']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockUntil: serializer.fromJson<String?>(json['lockUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locked': serializer.toJson<String>(locked),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockUntil': serializer.toJson<String?>(lockUntil),
    };
  }

  VaultStateTableData copyWith({
    String? id,
    String? locked,
    int? failedAttempts,
    Value<String?> lockUntil = const Value.absent(),
  }) => VaultStateTableData(
    id: id ?? this.id,
    locked: locked ?? this.locked,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockUntil: lockUntil.present ? lockUntil.value : this.lockUntil,
  );
  VaultStateTableData copyWithCompanion(VaultStateTableCompanion data) {
    return VaultStateTableData(
      id: data.id.present ? data.id.value : this.id,
      locked: data.locked.present ? data.locked.value : this.locked,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockUntil: data.lockUntil.present ? data.lockUntil.value : this.lockUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultStateTableData(')
          ..write('id: $id, ')
          ..write('locked: $locked, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockUntil: $lockUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, locked, failedAttempts, lockUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultStateTableData &&
          other.id == this.id &&
          other.locked == this.locked &&
          other.failedAttempts == this.failedAttempts &&
          other.lockUntil == this.lockUntil);
}

class VaultStateTableCompanion extends UpdateCompanion<VaultStateTableData> {
  final Value<String> id;
  final Value<String> locked;
  final Value<int> failedAttempts;
  final Value<String?> lockUntil;
  final Value<int> rowid;
  const VaultStateTableCompanion({
    this.id = const Value.absent(),
    this.locked = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultStateTableCompanion.insert({
    this.id = const Value.absent(),
    this.locked = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<VaultStateTableData> custom({
    Expression<String>? id,
    Expression<String>? locked,
    Expression<int>? failedAttempts,
    Expression<String>? lockUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locked != null) 'locked': locked,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockUntil != null) 'lock_until': lockUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultStateTableCompanion copyWith({
    Value<String>? id,
    Value<String>? locked,
    Value<int>? failedAttempts,
    Value<String?>? lockUntil,
    Value<int>? rowid,
  }) {
    return VaultStateTableCompanion(
      id: id ?? this.id,
      locked: locked ?? this.locked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockUntil: lockUntil ?? this.lockUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locked.present) {
      map['locked'] = Variable<String>(locked.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockUntil.present) {
      map['lock_until'] = Variable<String>(lockUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultStateTableCompanion(')
          ..write('id: $id, ')
          ..write('locked: $locked, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockUntil: $lockUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user_preferences'),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _autoLockTimeoutMeta = const VerificationMeta(
    'autoLockTimeout',
  );
  @override
  late final GeneratedColumn<int> autoLockTimeout = GeneratedColumn<int>(
    'auto_lock_timeout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _autoWipeThresholdMeta = const VerificationMeta(
    'autoWipeThreshold',
  );
  @override
  late final GeneratedColumn<int> autoWipeThreshold = GeneratedColumn<int>(
    'auto_wipe_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _backupReminderDaysMeta =
      const VerificationMeta('backupReminderDays');
  @override
  late final GeneratedColumn<int> backupReminderDays = GeneratedColumn<int>(
    'backup_reminder_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    autoLockTimeout,
    autoWipeThreshold,
    backupReminderDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('auto_lock_timeout')) {
      context.handle(
        _autoLockTimeoutMeta,
        autoLockTimeout.isAcceptableOrUnknown(
          data['auto_lock_timeout']!,
          _autoLockTimeoutMeta,
        ),
      );
    }
    if (data.containsKey('auto_wipe_threshold')) {
      context.handle(
        _autoWipeThresholdMeta,
        autoWipeThreshold.isAcceptableOrUnknown(
          data['auto_wipe_threshold']!,
          _autoWipeThresholdMeta,
        ),
      );
    }
    if (data.containsKey('backup_reminder_days')) {
      context.handle(
        _backupReminderDaysMeta,
        backupReminderDays.isAcceptableOrUnknown(
          data['backup_reminder_days']!,
          _backupReminderDaysMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      autoLockTimeout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_lock_timeout'],
      )!,
      autoWipeThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_wipe_threshold'],
      )!,
      backupReminderDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}backup_reminder_days'],
      )!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  /// Identificador do registro (sempre "user_preferences").
  final String id;

  /// Tema do app (ex: "light", "dark", "system").
  final String theme;

  /// Timeout de auto-lock em minutos (default: 2).
  final int autoLockTimeout;

  /// Numero de tentativas antes do auto-wipe (default: 10).
  final int autoWipeThreshold;

  /// Dias entre lembretes de backup (default: 7).
  final int backupReminderDays;
  const UserPreferencesTableData({
    required this.id,
    required this.theme,
    required this.autoLockTimeout,
    required this.autoWipeThreshold,
    required this.backupReminderDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['theme'] = Variable<String>(theme);
    map['auto_lock_timeout'] = Variable<int>(autoLockTimeout);
    map['auto_wipe_threshold'] = Variable<int>(autoWipeThreshold);
    map['backup_reminder_days'] = Variable<int>(backupReminderDays);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      id: Value(id),
      theme: Value(theme),
      autoLockTimeout: Value(autoLockTimeout),
      autoWipeThreshold: Value(autoWipeThreshold),
      backupReminderDays: Value(backupReminderDays),
    );
  }

  factory UserPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      id: serializer.fromJson<String>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      autoLockTimeout: serializer.fromJson<int>(json['autoLockTimeout']),
      autoWipeThreshold: serializer.fromJson<int>(json['autoWipeThreshold']),
      backupReminderDays: serializer.fromJson<int>(json['backupReminderDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'theme': serializer.toJson<String>(theme),
      'autoLockTimeout': serializer.toJson<int>(autoLockTimeout),
      'autoWipeThreshold': serializer.toJson<int>(autoWipeThreshold),
      'backupReminderDays': serializer.toJson<int>(backupReminderDays),
    };
  }

  UserPreferencesTableData copyWith({
    String? id,
    String? theme,
    int? autoLockTimeout,
    int? autoWipeThreshold,
    int? backupReminderDays,
  }) => UserPreferencesTableData(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
    autoWipeThreshold: autoWipeThreshold ?? this.autoWipeThreshold,
    backupReminderDays: backupReminderDays ?? this.backupReminderDays,
  );
  UserPreferencesTableData copyWithCompanion(
    UserPreferencesTableCompanion data,
  ) {
    return UserPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      autoLockTimeout: data.autoLockTimeout.present
          ? data.autoLockTimeout.value
          : this.autoLockTimeout,
      autoWipeThreshold: data.autoWipeThreshold.present
          ? data.autoWipeThreshold.value
          : this.autoWipeThreshold,
      backupReminderDays: data.backupReminderDays.present
          ? data.backupReminderDays.value
          : this.backupReminderDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('autoLockTimeout: $autoLockTimeout, ')
          ..write('autoWipeThreshold: $autoWipeThreshold, ')
          ..write('backupReminderDays: $backupReminderDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    theme,
    autoLockTimeout,
    autoWipeThreshold,
    backupReminderDays,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.autoLockTimeout == this.autoLockTimeout &&
          other.autoWipeThreshold == this.autoWipeThreshold &&
          other.backupReminderDays == this.backupReminderDays);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<String> id;
  final Value<String> theme;
  final Value<int> autoLockTimeout;
  final Value<int> autoWipeThreshold;
  final Value<int> backupReminderDays;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.autoLockTimeout = const Value.absent(),
    this.autoWipeThreshold = const Value.absent(),
    this.backupReminderDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.autoLockTimeout = const Value.absent(),
    this.autoWipeThreshold = const Value.absent(),
    this.backupReminderDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<UserPreferencesTableData> custom({
    Expression<String>? id,
    Expression<String>? theme,
    Expression<int>? autoLockTimeout,
    Expression<int>? autoWipeThreshold,
    Expression<int>? backupReminderDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (autoLockTimeout != null) 'auto_lock_timeout': autoLockTimeout,
      if (autoWipeThreshold != null) 'auto_wipe_threshold': autoWipeThreshold,
      if (backupReminderDays != null)
        'backup_reminder_days': backupReminderDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? theme,
    Value<int>? autoLockTimeout,
    Value<int>? autoWipeThreshold,
    Value<int>? backupReminderDays,
    Value<int>? rowid,
  }) {
    return UserPreferencesTableCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      autoWipeThreshold: autoWipeThreshold ?? this.autoWipeThreshold,
      backupReminderDays: backupReminderDays ?? this.backupReminderDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (autoLockTimeout.present) {
      map['auto_lock_timeout'] = Variable<int>(autoLockTimeout.value);
    }
    if (autoWipeThreshold.present) {
      map['auto_wipe_threshold'] = Variable<int>(autoWipeThreshold.value);
    }
    if (backupReminderDays.present) {
      map['backup_reminder_days'] = Variable<int>(backupReminderDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('autoLockTimeout: $autoLockTimeout, ')
          ..write('autoWipeThreshold: $autoWipeThreshold, ')
          ..write('backupReminderDays: $backupReminderDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PasswordsTableTable passwordsTable = $PasswordsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $BackupMetaTableTable backupMetaTable = $BackupMetaTableTable(
    this,
  );
  late final $VaultStateTableTable vaultStateTable = $VaultStateTableTable(
    this,
  );
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    passwordsTable,
    categoriesTable,
    backupMetaTable,
    vaultStateTable,
    userPreferencesTable,
  ];
}

typedef $$PasswordsTableTableCreateCompanionBuilder =
    PasswordsTableCompanion Function({
      required String id,
      Value<String?> categoryId,
      required String title,
      required String username,
      required String password,
      Value<String?> url,
      Value<String?> notes,
      Value<String> tags,
      Value<bool> favorite,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$PasswordsTableTableUpdateCompanionBuilder =
    PasswordsTableCompanion Function({
      Value<String> id,
      Value<String?> categoryId,
      Value<String> title,
      Value<String> username,
      Value<String> password,
      Value<String?> url,
      Value<String?> notes,
      Value<String> tags,
      Value<bool> favorite,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$PasswordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PasswordsTableTable> {
  $$PasswordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PasswordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PasswordsTableTable> {
  $$PasswordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PasswordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PasswordsTableTable> {
  $$PasswordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PasswordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PasswordsTableTable,
          PasswordsTableData,
          $$PasswordsTableTableFilterComposer,
          $$PasswordsTableTableOrderingComposer,
          $$PasswordsTableTableAnnotationComposer,
          $$PasswordsTableTableCreateCompanionBuilder,
          $$PasswordsTableTableUpdateCompanionBuilder,
          (
            PasswordsTableData,
            BaseReferences<
              _$AppDatabase,
              $PasswordsTableTable,
              PasswordsTableData
            >,
          ),
          PasswordsTableData,
          PrefetchHooks Function()
        > {
  $$PasswordsTableTableTableManager(
    _$AppDatabase db,
    $PasswordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PasswordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PasswordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PasswordsTableCompanion(
                id: id,
                categoryId: categoryId,
                title: title,
                username: username,
                password: password,
                url: url,
                notes: notes,
                tags: tags,
                favorite: favorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> categoryId = const Value.absent(),
                required String title,
                required String username,
                required String password,
                Value<String?> url = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PasswordsTableCompanion.insert(
                id: id,
                categoryId: categoryId,
                title: title,
                username: username,
                password: password,
                url: url,
                notes: notes,
                tags: tags,
                favorite: favorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PasswordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PasswordsTableTable,
      PasswordsTableData,
      $$PasswordsTableTableFilterComposer,
      $$PasswordsTableTableOrderingComposer,
      $$PasswordsTableTableAnnotationComposer,
      $$PasswordsTableTableCreateCompanionBuilder,
      $$PasswordsTableTableUpdateCompanionBuilder,
      (
        PasswordsTableData,
        BaseReferences<_$AppDatabase, $PasswordsTableTable, PasswordsTableData>,
      ),
      PasswordsTableData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      Value<int?> color,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<int?> color,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $CategoriesTableTable,
              CategoriesTableData
            >,
          ),
          CategoriesTableData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        >,
      ),
      CategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$BackupMetaTableTableCreateCompanionBuilder =
    BackupMetaTableCompanion Function({
      Value<String> id,
      Value<String?> lastBackup,
      Value<String?> fileHash,
      Value<String?> cloudPath,
      Value<int> rowid,
    });
typedef $$BackupMetaTableTableUpdateCompanionBuilder =
    BackupMetaTableCompanion Function({
      Value<String> id,
      Value<String?> lastBackup,
      Value<String?> fileHash,
      Value<String?> cloudPath,
      Value<int> rowid,
    });

class $$BackupMetaTableTableFilterComposer
    extends Composer<_$AppDatabase, $BackupMetaTableTable> {
  $$BackupMetaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cloudPath => $composableBuilder(
    column: $table.cloudPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BackupMetaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupMetaTableTable> {
  $$BackupMetaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cloudPath => $composableBuilder(
    column: $table.cloudPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BackupMetaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupMetaTableTable> {
  $$BackupMetaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastBackup => $composableBuilder(
    column: $table.lastBackup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get cloudPath =>
      $composableBuilder(column: $table.cloudPath, builder: (column) => column);
}

class $$BackupMetaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BackupMetaTableTable,
          BackupMetaTableData,
          $$BackupMetaTableTableFilterComposer,
          $$BackupMetaTableTableOrderingComposer,
          $$BackupMetaTableTableAnnotationComposer,
          $$BackupMetaTableTableCreateCompanionBuilder,
          $$BackupMetaTableTableUpdateCompanionBuilder,
          (
            BackupMetaTableData,
            BaseReferences<
              _$AppDatabase,
              $BackupMetaTableTable,
              BackupMetaTableData
            >,
          ),
          BackupMetaTableData,
          PrefetchHooks Function()
        > {
  $$BackupMetaTableTableTableManager(
    _$AppDatabase db,
    $BackupMetaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupMetaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupMetaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupMetaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> lastBackup = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> cloudPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackupMetaTableCompanion(
                id: id,
                lastBackup: lastBackup,
                fileHash: fileHash,
                cloudPath: cloudPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> lastBackup = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> cloudPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BackupMetaTableCompanion.insert(
                id: id,
                lastBackup: lastBackup,
                fileHash: fileHash,
                cloudPath: cloudPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BackupMetaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BackupMetaTableTable,
      BackupMetaTableData,
      $$BackupMetaTableTableFilterComposer,
      $$BackupMetaTableTableOrderingComposer,
      $$BackupMetaTableTableAnnotationComposer,
      $$BackupMetaTableTableCreateCompanionBuilder,
      $$BackupMetaTableTableUpdateCompanionBuilder,
      (
        BackupMetaTableData,
        BaseReferences<
          _$AppDatabase,
          $BackupMetaTableTable,
          BackupMetaTableData
        >,
      ),
      BackupMetaTableData,
      PrefetchHooks Function()
    >;
typedef $$VaultStateTableTableCreateCompanionBuilder =
    VaultStateTableCompanion Function({
      Value<String> id,
      Value<String> locked,
      Value<int> failedAttempts,
      Value<String?> lockUntil,
      Value<int> rowid,
    });
typedef $$VaultStateTableTableUpdateCompanionBuilder =
    VaultStateTableCompanion Function({
      Value<String> id,
      Value<String> locked,
      Value<int> failedAttempts,
      Value<String?> lockUntil,
      Value<int> rowid,
    });

class $$VaultStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $VaultStateTableTable> {
  $$VaultStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lockUntil => $composableBuilder(
    column: $table.lockUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultStateTableTable> {
  $$VaultStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lockUntil => $composableBuilder(
    column: $table.lockUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultStateTableTable> {
  $$VaultStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locked =>
      $composableBuilder(column: $table.locked, builder: (column) => column);

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lockUntil =>
      $composableBuilder(column: $table.lockUntil, builder: (column) => column);
}

class $$VaultStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultStateTableTable,
          VaultStateTableData,
          $$VaultStateTableTableFilterComposer,
          $$VaultStateTableTableOrderingComposer,
          $$VaultStateTableTableAnnotationComposer,
          $$VaultStateTableTableCreateCompanionBuilder,
          $$VaultStateTableTableUpdateCompanionBuilder,
          (
            VaultStateTableData,
            BaseReferences<
              _$AppDatabase,
              $VaultStateTableTable,
              VaultStateTableData
            >,
          ),
          VaultStateTableData,
          PrefetchHooks Function()
        > {
  $$VaultStateTableTableTableManager(
    _$AppDatabase db,
    $VaultStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locked = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<String?> lockUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultStateTableCompanion(
                id: id,
                locked: locked,
                failedAttempts: failedAttempts,
                lockUntil: lockUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locked = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<String?> lockUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultStateTableCompanion.insert(
                id: id,
                locked: locked,
                failedAttempts: failedAttempts,
                lockUntil: lockUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultStateTableTable,
      VaultStateTableData,
      $$VaultStateTableTableFilterComposer,
      $$VaultStateTableTableOrderingComposer,
      $$VaultStateTableTableAnnotationComposer,
      $$VaultStateTableTableCreateCompanionBuilder,
      $$VaultStateTableTableUpdateCompanionBuilder,
      (
        VaultStateTableData,
        BaseReferences<
          _$AppDatabase,
          $VaultStateTableTable,
          VaultStateTableData
        >,
      ),
      VaultStateTableData,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableTableCreateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<String> id,
      Value<String> theme,
      Value<int> autoLockTimeout,
      Value<int> autoWipeThreshold,
      Value<int> backupReminderDays,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableTableUpdateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<String> id,
      Value<String> theme,
      Value<int> autoLockTimeout,
      Value<int> autoWipeThreshold,
      Value<int> backupReminderDays,
      Value<int> rowid,
    });

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoLockTimeout => $composableBuilder(
    column: $table.autoLockTimeout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoWipeThreshold => $composableBuilder(
    column: $table.autoWipeThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backupReminderDays => $composableBuilder(
    column: $table.backupReminderDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoLockTimeout => $composableBuilder(
    column: $table.autoLockTimeout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoWipeThreshold => $composableBuilder(
    column: $table.autoWipeThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backupReminderDays => $composableBuilder(
    column: $table.backupReminderDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<int> get autoLockTimeout => $composableBuilder(
    column: $table.autoLockTimeout,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoWipeThreshold => $composableBuilder(
    column: $table.autoWipeThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get backupReminderDays => $composableBuilder(
    column: $table.backupReminderDays,
    builder: (column) => column,
  );
}

class $$UserPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData,
          $$UserPreferencesTableTableFilterComposer,
          $$UserPreferencesTableTableOrderingComposer,
          $$UserPreferencesTableTableAnnotationComposer,
          $$UserPreferencesTableTableCreateCompanionBuilder,
          $$UserPreferencesTableTableUpdateCompanionBuilder,
          (
            UserPreferencesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTableTable,
              UserPreferencesTableData
            >,
          ),
          UserPreferencesTableData,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<int> autoLockTimeout = const Value.absent(),
                Value<int> autoWipeThreshold = const Value.absent(),
                Value<int> backupReminderDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion(
                id: id,
                theme: theme,
                autoLockTimeout: autoLockTimeout,
                autoWipeThreshold: autoWipeThreshold,
                backupReminderDays: backupReminderDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<int> autoLockTimeout = const Value.absent(),
                Value<int> autoWipeThreshold = const Value.absent(),
                Value<int> backupReminderDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion.insert(
                id: id,
                theme: theme,
                autoLockTimeout: autoLockTimeout,
                autoWipeThreshold: autoWipeThreshold,
                backupReminderDays: backupReminderDays,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTableTable,
      UserPreferencesTableData,
      $$UserPreferencesTableTableFilterComposer,
      $$UserPreferencesTableTableOrderingComposer,
      $$UserPreferencesTableTableAnnotationComposer,
      $$UserPreferencesTableTableCreateCompanionBuilder,
      $$UserPreferencesTableTableUpdateCompanionBuilder,
      (
        UserPreferencesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData
        >,
      ),
      UserPreferencesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PasswordsTableTableTableManager get passwordsTable =>
      $$PasswordsTableTableTableManager(_db, _db.passwordsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$BackupMetaTableTableTableManager get backupMetaTable =>
      $$BackupMetaTableTableTableManager(_db, _db.backupMetaTable);
  $$VaultStateTableTableTableManager get vaultStateTable =>
      $$VaultStateTableTableTableManager(_db, _db.vaultStateTable);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
}
