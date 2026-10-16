// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Architecture'));
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, int> syncState =
      GeneratedColumn<int>('sync_state', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(1))
          .withConverter<SyncState>($NotesTableTable.$convertersyncState);
  static const VerificationMeta _baseVersionMeta =
      const VerificationMeta('baseVersion');
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
      'base_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _conflictedRemoteTitleMeta =
      const VerificationMeta('conflictedRemoteTitle');
  @override
  late final GeneratedColumn<String> conflictedRemoteTitle =
      GeneratedColumn<String>('conflicted_remote_title', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictedRemoteContentMeta =
      const VerificationMeta('conflictedRemoteContent');
  @override
  late final GeneratedColumn<String> conflictedRemoteContent =
      GeneratedColumn<String>('conflicted_remote_content', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conflictedRemoteVersionMeta =
      const VerificationMeta('conflictedRemoteVersion');
  @override
  late final GeneratedColumn<int> conflictedRemoteVersion =
      GeneratedColumn<int>('conflicted_remote_version', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtUtcMeta =
      const VerificationMeta('updatedAtUtc');
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
      'updated_at_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        category,
        isPinned,
        syncState,
        baseVersion,
        localVersion,
        conflictedRemoteTitle,
        conflictedRemoteContent,
        conflictedRemoteVersion,
        updatedAtUtc
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(Insertable<NoteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('base_version')) {
      context.handle(
          _baseVersionMeta,
          baseVersion.isAcceptableOrUnknown(
              data['base_version']!, _baseVersionMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('conflicted_remote_title')) {
      context.handle(
          _conflictedRemoteTitleMeta,
          conflictedRemoteTitle.isAcceptableOrUnknown(
              data['conflicted_remote_title']!, _conflictedRemoteTitleMeta));
    }
    if (data.containsKey('conflicted_remote_content')) {
      context.handle(
          _conflictedRemoteContentMeta,
          conflictedRemoteContent.isAcceptableOrUnknown(
              data['conflicted_remote_content']!,
              _conflictedRemoteContentMeta));
    }
    if (data.containsKey('conflicted_remote_version')) {
      context.handle(
          _conflictedRemoteVersionMeta,
          conflictedRemoteVersion.isAcceptableOrUnknown(
              data['conflicted_remote_version']!,
              _conflictedRemoteVersionMeta));
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
          _updatedAtUtcMeta,
          updatedAtUtc.isAcceptableOrUnknown(
              data['updated_at_utc']!, _updatedAtUtcMeta));
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      syncState: $NotesTableTable.$convertersyncState.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_state'])!),
      baseVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_version'])!,
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      conflictedRemoteTitle: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}conflicted_remote_title']),
      conflictedRemoteContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}conflicted_remote_content']),
      conflictedRemoteVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}conflicted_remote_version']),
      updatedAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_utc'])!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, int, int> $convertersyncState =
      const EnumIndexConverter<SyncState>(SyncState.values);
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isPinned;

  /// Stored as SyncState enum index: 0=synced, 1=pendingPush, 2=pendingDelete, 3=conflicted
  final SyncState syncState;
  final int baseVersion;
  final int localVersion;

  /// Conflict snapshot columns (populated when server rejects push with 409)
  final String? conflictedRemoteTitle;
  final String? conflictedRemoteContent;
  final int? conflictedRemoteVersion;
  final DateTime updatedAtUtc;
  const NoteRow(
      {required this.id,
      required this.title,
      required this.content,
      required this.category,
      required this.isPinned,
      required this.syncState,
      required this.baseVersion,
      required this.localVersion,
      this.conflictedRemoteTitle,
      this.conflictedRemoteContent,
      this.conflictedRemoteVersion,
      required this.updatedAtUtc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['is_pinned'] = Variable<bool>(isPinned);
    {
      map['sync_state'] =
          Variable<int>($NotesTableTable.$convertersyncState.toSql(syncState));
    }
    map['base_version'] = Variable<int>(baseVersion);
    map['local_version'] = Variable<int>(localVersion);
    if (!nullToAbsent || conflictedRemoteTitle != null) {
      map['conflicted_remote_title'] = Variable<String>(conflictedRemoteTitle);
    }
    if (!nullToAbsent || conflictedRemoteContent != null) {
      map['conflicted_remote_content'] =
          Variable<String>(conflictedRemoteContent);
    }
    if (!nullToAbsent || conflictedRemoteVersion != null) {
      map['conflicted_remote_version'] = Variable<int>(conflictedRemoteVersion);
    }
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      isPinned: Value(isPinned),
      syncState: Value(syncState),
      baseVersion: Value(baseVersion),
      localVersion: Value(localVersion),
      conflictedRemoteTitle: conflictedRemoteTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictedRemoteTitle),
      conflictedRemoteContent: conflictedRemoteContent == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictedRemoteContent),
      conflictedRemoteVersion: conflictedRemoteVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictedRemoteVersion),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory NoteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      syncState: $NotesTableTable.$convertersyncState
          .fromJson(serializer.fromJson<int>(json['syncState'])),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      conflictedRemoteTitle:
          serializer.fromJson<String?>(json['conflictedRemoteTitle']),
      conflictedRemoteContent:
          serializer.fromJson<String?>(json['conflictedRemoteContent']),
      conflictedRemoteVersion:
          serializer.fromJson<int?>(json['conflictedRemoteVersion']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'isPinned': serializer.toJson<bool>(isPinned),
      'syncState': serializer
          .toJson<int>($NotesTableTable.$convertersyncState.toJson(syncState)),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'localVersion': serializer.toJson<int>(localVersion),
      'conflictedRemoteTitle':
          serializer.toJson<String?>(conflictedRemoteTitle),
      'conflictedRemoteContent':
          serializer.toJson<String?>(conflictedRemoteContent),
      'conflictedRemoteVersion':
          serializer.toJson<int?>(conflictedRemoteVersion),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  NoteRow copyWith(
          {String? id,
          String? title,
          String? content,
          String? category,
          bool? isPinned,
          SyncState? syncState,
          int? baseVersion,
          int? localVersion,
          Value<String?> conflictedRemoteTitle = const Value.absent(),
          Value<String?> conflictedRemoteContent = const Value.absent(),
          Value<int?> conflictedRemoteVersion = const Value.absent(),
          DateTime? updatedAtUtc}) =>
      NoteRow(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        category: category ?? this.category,
        isPinned: isPinned ?? this.isPinned,
        syncState: syncState ?? this.syncState,
        baseVersion: baseVersion ?? this.baseVersion,
        localVersion: localVersion ?? this.localVersion,
        conflictedRemoteTitle: conflictedRemoteTitle.present
            ? conflictedRemoteTitle.value
            : this.conflictedRemoteTitle,
        conflictedRemoteContent: conflictedRemoteContent.present
            ? conflictedRemoteContent.value
            : this.conflictedRemoteContent,
        conflictedRemoteVersion: conflictedRemoteVersion.present
            ? conflictedRemoteVersion.value
            : this.conflictedRemoteVersion,
        updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      );
  NoteRow copyWithCompanion(NotesTableCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      baseVersion:
          data.baseVersion.present ? data.baseVersion.value : this.baseVersion,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      conflictedRemoteTitle: data.conflictedRemoteTitle.present
          ? data.conflictedRemoteTitle.value
          : this.conflictedRemoteTitle,
      conflictedRemoteContent: data.conflictedRemoteContent.present
          ? data.conflictedRemoteContent.value
          : this.conflictedRemoteContent,
      conflictedRemoteVersion: data.conflictedRemoteVersion.present
          ? data.conflictedRemoteVersion.value
          : this.conflictedRemoteVersion,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isPinned: $isPinned, ')
          ..write('syncState: $syncState, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('localVersion: $localVersion, ')
          ..write('conflictedRemoteTitle: $conflictedRemoteTitle, ')
          ..write('conflictedRemoteContent: $conflictedRemoteContent, ')
          ..write('conflictedRemoteVersion: $conflictedRemoteVersion, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      content,
      category,
      isPinned,
      syncState,
      baseVersion,
      localVersion,
      conflictedRemoteTitle,
      conflictedRemoteContent,
      conflictedRemoteVersion,
      updatedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.isPinned == this.isPinned &&
          other.syncState == this.syncState &&
          other.baseVersion == this.baseVersion &&
          other.localVersion == this.localVersion &&
          other.conflictedRemoteTitle == this.conflictedRemoteTitle &&
          other.conflictedRemoteContent == this.conflictedRemoteContent &&
          other.conflictedRemoteVersion == this.conflictedRemoteVersion &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class NotesTableCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> category;
  final Value<bool> isPinned;
  final Value<SyncState> syncState;
  final Value<int> baseVersion;
  final Value<int> localVersion;
  final Value<String?> conflictedRemoteTitle;
  final Value<String?> conflictedRemoteContent;
  final Value<int?> conflictedRemoteVersion;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.syncState = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.conflictedRemoteTitle = const Value.absent(),
    this.conflictedRemoteContent = const Value.absent(),
    this.conflictedRemoteVersion = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.category = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.syncState = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.conflictedRemoteTitle = const Value.absent(),
    this.conflictedRemoteContent = const Value.absent(),
    this.conflictedRemoteVersion = const Value.absent(),
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        updatedAtUtc = Value(updatedAtUtc);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<bool>? isPinned,
    Expression<int>? syncState,
    Expression<int>? baseVersion,
    Expression<int>? localVersion,
    Expression<String>? conflictedRemoteTitle,
    Expression<String>? conflictedRemoteContent,
    Expression<int>? conflictedRemoteVersion,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (isPinned != null) 'is_pinned': isPinned,
      if (syncState != null) 'sync_state': syncState,
      if (baseVersion != null) 'base_version': baseVersion,
      if (localVersion != null) 'local_version': localVersion,
      if (conflictedRemoteTitle != null)
        'conflicted_remote_title': conflictedRemoteTitle,
      if (conflictedRemoteContent != null)
        'conflicted_remote_content': conflictedRemoteContent,
      if (conflictedRemoteVersion != null)
        'conflicted_remote_version': conflictedRemoteVersion,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? category,
      Value<bool>? isPinned,
      Value<SyncState>? syncState,
      Value<int>? baseVersion,
      Value<int>? localVersion,
      Value<String?>? conflictedRemoteTitle,
      Value<String?>? conflictedRemoteContent,
      Value<int?>? conflictedRemoteVersion,
      Value<DateTime>? updatedAtUtc,
      Value<int>? rowid}) {
    return NotesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      syncState: syncState ?? this.syncState,
      baseVersion: baseVersion ?? this.baseVersion,
      localVersion: localVersion ?? this.localVersion,
      conflictedRemoteTitle:
          conflictedRemoteTitle ?? this.conflictedRemoteTitle,
      conflictedRemoteContent:
          conflictedRemoteContent ?? this.conflictedRemoteContent,
      conflictedRemoteVersion:
          conflictedRemoteVersion ?? this.conflictedRemoteVersion,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<int>(
          $NotesTableTable.$convertersyncState.toSql(syncState.value));
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (conflictedRemoteTitle.present) {
      map['conflicted_remote_title'] =
          Variable<String>(conflictedRemoteTitle.value);
    }
    if (conflictedRemoteContent.present) {
      map['conflicted_remote_content'] =
          Variable<String>(conflictedRemoteContent.value);
    }
    if (conflictedRemoteVersion.present) {
      map['conflicted_remote_version'] =
          Variable<int>(conflictedRemoteVersion.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('isPinned: $isPinned, ')
          ..write('syncState: $syncState, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('localVersion: $localVersion, ')
          ..write('conflictedRemoteTitle: $conflictedRemoteTitle, ')
          ..write('conflictedRemoteContent: $conflictedRemoteContent, ')
          ..write('conflictedRemoteVersion: $conflictedRemoteVersion, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notesTable];
}

typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  required String title,
  required String content,
  Value<String> category,
  Value<bool> isPinned,
  Value<SyncState> syncState,
  Value<int> baseVersion,
  Value<int> localVersion,
  Value<String?> conflictedRemoteTitle,
  Value<String?> conflictedRemoteContent,
  Value<int?> conflictedRemoteVersion,
  required DateTime updatedAtUtc,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<String> category,
  Value<bool> isPinned,
  Value<SyncState> syncState,
  Value<int> baseVersion,
  Value<int> localVersion,
  Value<String?> conflictedRemoteTitle,
  Value<String?> conflictedRemoteContent,
  Value<int?> conflictedRemoteVersion,
  Value<DateTime> updatedAtUtc,
  Value<int> rowid,
});

class $$NotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncState, SyncState, int> get syncState =>
      $composableBuilder(
          column: $table.syncState,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictedRemoteTitle => $composableBuilder(
      column: $table.conflictedRemoteTitle,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictedRemoteContent => $composableBuilder(
      column: $table.conflictedRemoteContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conflictedRemoteVersion => $composableBuilder(
      column: $table.conflictedRemoteVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => ColumnFilters(column));
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictedRemoteTitle => $composableBuilder(
      column: $table.conflictedRemoteTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictedRemoteContent => $composableBuilder(
      column: $table.conflictedRemoteContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conflictedRemoteVersion => $composableBuilder(
      column: $table.conflictedRemoteVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc,
      builder: (column) => ColumnOrderings(column));
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, int> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get conflictedRemoteTitle => $composableBuilder(
      column: $table.conflictedRemoteTitle, builder: (column) => column);

  GeneratedColumn<String> get conflictedRemoteContent => $composableBuilder(
      column: $table.conflictedRemoteContent, builder: (column) => column);

  GeneratedColumn<int> get conflictedRemoteVersion => $composableBuilder(
      column: $table.conflictedRemoteVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => column);
}

class $$NotesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NoteRow,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTableTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()> {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<SyncState> syncState = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String?> conflictedRemoteTitle = const Value.absent(),
            Value<String?> conflictedRemoteContent = const Value.absent(),
            Value<int?> conflictedRemoteVersion = const Value.absent(),
            Value<DateTime> updatedAtUtc = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion(
            id: id,
            title: title,
            content: content,
            category: category,
            isPinned: isPinned,
            syncState: syncState,
            baseVersion: baseVersion,
            localVersion: localVersion,
            conflictedRemoteTitle: conflictedRemoteTitle,
            conflictedRemoteContent: conflictedRemoteContent,
            conflictedRemoteVersion: conflictedRemoteVersion,
            updatedAtUtc: updatedAtUtc,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String content,
            Value<String> category = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<SyncState> syncState = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String?> conflictedRemoteTitle = const Value.absent(),
            Value<String?> conflictedRemoteContent = const Value.absent(),
            Value<int?> conflictedRemoteVersion = const Value.absent(),
            required DateTime updatedAtUtc,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion.insert(
            id: id,
            title: title,
            content: content,
            category: category,
            isPinned: isPinned,
            syncState: syncState,
            baseVersion: baseVersion,
            localVersion: localVersion,
            conflictedRemoteTitle: conflictedRemoteTitle,
            conflictedRemoteContent: conflictedRemoteContent,
            conflictedRemoteVersion: conflictedRemoteVersion,
            updatedAtUtc: updatedAtUtc,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$NotesTableTable, NoteRow>(table),
                    BaseReferences<_$AppDatabase, $NotesTableTable, NoteRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NoteRow,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableAnnotationComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder,
    (NoteRow, BaseReferences<_$AppDatabase, $NotesTableTable, NoteRow>),
    NoteRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
}
