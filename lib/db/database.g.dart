// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectModelTable extends ProjectModel
    with TableInfo<$ProjectModelTable, ProjectModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<int> lastModified = GeneratedColumn<int>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isPublicMeta =
      const VerificationMeta('isPublic');
  @override
  late final GeneratedColumn<int> isPublic = GeneratedColumn<int>(
      'is_public', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isPrivateMeta =
      const VerificationMeta('isPrivate');
  @override
  late final GeneratedColumn<int> isPrivate = GeneratedColumn<int>(
      'is_private', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _identifierMeta =
      const VerificationMeta('identifier');
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
      'identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priorityDefaultMeta =
      const VerificationMeta('priorityDefault');
  @override
  late final GeneratedColumn<int> priorityDefault = GeneratedColumn<int>(
      'priority_default', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priorityStartMeta =
      const VerificationMeta('priorityStart');
  @override
  late final GeneratedColumn<int> priorityStart = GeneratedColumn<int>(
      'priority_start', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priorityEndMeta =
      const VerificationMeta('priorityEnd');
  @override
  late final GeneratedColumn<int> priorityEnd = GeneratedColumn<int>(
      'priority_end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _predefinedEmailSubjectsMeta =
      const VerificationMeta('predefinedEmailSubjects');
  @override
  late final GeneratedColumn<String> predefinedEmailSubjects =
      GeneratedColumn<String>('predefined_email_subjects', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _perSwimlaneTaskLimitsMeta =
      const VerificationMeta('perSwimlaneTaskLimits');
  @override
  late final GeneratedColumn<int> perSwimlaneTaskLimits = GeneratedColumn<int>(
      'per_swimlane_task_limits', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskLimitMeta =
      const VerificationMeta('taskLimit');
  @override
  late final GeneratedColumn<int> taskLimit = GeneratedColumn<int>(
      'task_limit', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _enableGlobalTagsMeta =
      const VerificationMeta('enableGlobalTags');
  @override
  late final GeneratedColumn<int> enableGlobalTags = GeneratedColumn<int>(
      'enable_global_tags', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isTrelloImportedMeta =
      const VerificationMeta('isTrelloImported');
  @override
  late final GeneratedColumn<int> isTrelloImported = GeneratedColumn<int>(
      'is_trello_imported', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumnWithTypeConverter<Url, String> url =
      GeneratedColumn<String>('url', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Url>($ProjectModelTable.$converterurl);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        isActive,
        token,
        lastModified,
        isPublic,
        isPrivate,
        description,
        identifier,
        startDate,
        endDate,
        ownerId,
        priorityDefault,
        priorityStart,
        priorityEnd,
        email,
        predefinedEmailSubjects,
        perSwimlaneTaskLimits,
        taskLimit,
        enableGlobalTags,
        isTrelloImported,
        url
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_model';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(_isPublicMeta,
          isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta));
    } else if (isInserting) {
      context.missing(_isPublicMeta);
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta));
    } else if (isInserting) {
      context.missing(_isPrivateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier']!, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('priority_default')) {
      context.handle(
          _priorityDefaultMeta,
          priorityDefault.isAcceptableOrUnknown(
              data['priority_default']!, _priorityDefaultMeta));
    } else if (isInserting) {
      context.missing(_priorityDefaultMeta);
    }
    if (data.containsKey('priority_start')) {
      context.handle(
          _priorityStartMeta,
          priorityStart.isAcceptableOrUnknown(
              data['priority_start']!, _priorityStartMeta));
    } else if (isInserting) {
      context.missing(_priorityStartMeta);
    }
    if (data.containsKey('priority_end')) {
      context.handle(
          _priorityEndMeta,
          priorityEnd.isAcceptableOrUnknown(
              data['priority_end']!, _priorityEndMeta));
    } else if (isInserting) {
      context.missing(_priorityEndMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('predefined_email_subjects')) {
      context.handle(
          _predefinedEmailSubjectsMeta,
          predefinedEmailSubjects.isAcceptableOrUnknown(
              data['predefined_email_subjects']!,
              _predefinedEmailSubjectsMeta));
    }
    if (data.containsKey('per_swimlane_task_limits')) {
      context.handle(
          _perSwimlaneTaskLimitsMeta,
          perSwimlaneTaskLimits.isAcceptableOrUnknown(
              data['per_swimlane_task_limits']!, _perSwimlaneTaskLimitsMeta));
    } else if (isInserting) {
      context.missing(_perSwimlaneTaskLimitsMeta);
    }
    if (data.containsKey('task_limit')) {
      context.handle(_taskLimitMeta,
          taskLimit.isAcceptableOrUnknown(data['task_limit']!, _taskLimitMeta));
    } else if (isInserting) {
      context.missing(_taskLimitMeta);
    }
    if (data.containsKey('enable_global_tags')) {
      context.handle(
          _enableGlobalTagsMeta,
          enableGlobalTags.isAcceptableOrUnknown(
              data['enable_global_tags']!, _enableGlobalTagsMeta));
    } else if (isInserting) {
      context.missing(_enableGlobalTagsMeta);
    }
    if (data.containsKey('is_trello_imported')) {
      context.handle(
          _isTrelloImportedMeta,
          isTrelloImported.isAcceptableOrUnknown(
              data['is_trello_imported']!, _isTrelloImportedMeta));
    }
    context.handle(_urlMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token'])!,
      lastModified: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_modified'])!,
      isPublic: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_public'])!,
      isPrivate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_private'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      identifier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}identifier'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id'])!,
      priorityDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_default'])!,
      priorityStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_start'])!,
      priorityEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_end'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      predefinedEmailSubjects: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}predefined_email_subjects']),
      perSwimlaneTaskLimits: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}per_swimlane_task_limits'])!,
      taskLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_limit'])!,
      enableGlobalTags: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}enable_global_tags'])!,
      isTrelloImported: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_trello_imported']),
      url: $ProjectModelTable.$converterurl.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!),
    );
  }

  @override
  $ProjectModelTable createAlias(String alias) {
    return $ProjectModelTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Url, String, Map<String, dynamic>> $converterurl =
      const UrlConverter();
}

class ProjectModelData extends DataClass
    implements Insertable<ProjectModelData> {
  final int id;
  final String name;
  final int isActive;
  final String token;
  final int lastModified;
  final int isPublic;
  final int isPrivate;
  final String? description;
  final String identifier;
  final String startDate;
  final String endDate;
  final int ownerId;
  final int priorityDefault;
  final int priorityStart;
  final int priorityEnd;
  final String? email;
  final String? predefinedEmailSubjects;
  final int perSwimlaneTaskLimits;
  final int taskLimit;
  final int enableGlobalTags;
  final int? isTrelloImported;
  final Url url;
  const ProjectModelData(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.token,
      required this.lastModified,
      required this.isPublic,
      required this.isPrivate,
      this.description,
      required this.identifier,
      required this.startDate,
      required this.endDate,
      required this.ownerId,
      required this.priorityDefault,
      required this.priorityStart,
      required this.priorityEnd,
      this.email,
      this.predefinedEmailSubjects,
      required this.perSwimlaneTaskLimits,
      required this.taskLimit,
      required this.enableGlobalTags,
      this.isTrelloImported,
      required this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<int>(isActive);
    map['token'] = Variable<String>(token);
    map['last_modified'] = Variable<int>(lastModified);
    map['is_public'] = Variable<int>(isPublic);
    map['is_private'] = Variable<int>(isPrivate);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['identifier'] = Variable<String>(identifier);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['owner_id'] = Variable<int>(ownerId);
    map['priority_default'] = Variable<int>(priorityDefault);
    map['priority_start'] = Variable<int>(priorityStart);
    map['priority_end'] = Variable<int>(priorityEnd);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || predefinedEmailSubjects != null) {
      map['predefined_email_subjects'] =
          Variable<String>(predefinedEmailSubjects);
    }
    map['per_swimlane_task_limits'] = Variable<int>(perSwimlaneTaskLimits);
    map['task_limit'] = Variable<int>(taskLimit);
    map['enable_global_tags'] = Variable<int>(enableGlobalTags);
    if (!nullToAbsent || isTrelloImported != null) {
      map['is_trello_imported'] = Variable<int>(isTrelloImported);
    }
    {
      map['url'] =
          Variable<String>($ProjectModelTable.$converterurl.toSql(url));
    }
    return map;
  }

  ProjectModelCompanion toCompanion(bool nullToAbsent) {
    return ProjectModelCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      token: Value(token),
      lastModified: Value(lastModified),
      isPublic: Value(isPublic),
      isPrivate: Value(isPrivate),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      identifier: Value(identifier),
      startDate: Value(startDate),
      endDate: Value(endDate),
      ownerId: Value(ownerId),
      priorityDefault: Value(priorityDefault),
      priorityStart: Value(priorityStart),
      priorityEnd: Value(priorityEnd),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      predefinedEmailSubjects: predefinedEmailSubjects == null && nullToAbsent
          ? const Value.absent()
          : Value(predefinedEmailSubjects),
      perSwimlaneTaskLimits: Value(perSwimlaneTaskLimits),
      taskLimit: Value(taskLimit),
      enableGlobalTags: Value(enableGlobalTags),
      isTrelloImported: isTrelloImported == null && nullToAbsent
          ? const Value.absent()
          : Value(isTrelloImported),
      url: Value(url),
    );
  }

  factory ProjectModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectModelData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<int>(json['is_active']),
      token: serializer.fromJson<String>(json['token']),
      lastModified: serializer.fromJson<int>(json['last_modified']),
      isPublic: serializer.fromJson<int>(json['is_public']),
      isPrivate: serializer.fromJson<int>(json['is_private']),
      description: serializer.fromJson<String?>(json['description']),
      identifier: serializer.fromJson<String>(json['identifier']),
      startDate: serializer.fromJson<String>(json['start_date']),
      endDate: serializer.fromJson<String>(json['end_date']),
      ownerId: serializer.fromJson<int>(json['owner_id']),
      priorityDefault: serializer.fromJson<int>(json['priority_default']),
      priorityStart: serializer.fromJson<int>(json['priority_start']),
      priorityEnd: serializer.fromJson<int>(json['priority_end']),
      email: serializer.fromJson<String?>(json['email']),
      predefinedEmailSubjects:
          serializer.fromJson<String?>(json['predefined_email_subjects']),
      perSwimlaneTaskLimits:
          serializer.fromJson<int>(json['per_swimlane_task_limits']),
      taskLimit: serializer.fromJson<int>(json['task_limit']),
      enableGlobalTags: serializer.fromJson<int>(json['enable_global_tags']),
      isTrelloImported: serializer.fromJson<int?>(json['is_trello_imported']),
      url: $ProjectModelTable.$converterurl
          .fromJson(serializer.fromJson<Map<String, dynamic>>(json['url'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'is_active': serializer.toJson<int>(isActive),
      'token': serializer.toJson<String>(token),
      'last_modified': serializer.toJson<int>(lastModified),
      'is_public': serializer.toJson<int>(isPublic),
      'is_private': serializer.toJson<int>(isPrivate),
      'description': serializer.toJson<String?>(description),
      'identifier': serializer.toJson<String>(identifier),
      'start_date': serializer.toJson<String>(startDate),
      'end_date': serializer.toJson<String>(endDate),
      'owner_id': serializer.toJson<int>(ownerId),
      'priority_default': serializer.toJson<int>(priorityDefault),
      'priority_start': serializer.toJson<int>(priorityStart),
      'priority_end': serializer.toJson<int>(priorityEnd),
      'email': serializer.toJson<String?>(email),
      'predefined_email_subjects':
          serializer.toJson<String?>(predefinedEmailSubjects),
      'per_swimlane_task_limits': serializer.toJson<int>(perSwimlaneTaskLimits),
      'task_limit': serializer.toJson<int>(taskLimit),
      'enable_global_tags': serializer.toJson<int>(enableGlobalTags),
      'is_trello_imported': serializer.toJson<int?>(isTrelloImported),
      'url': serializer.toJson<Map<String, dynamic>>(
          $ProjectModelTable.$converterurl.toJson(url)),
    };
  }

  ProjectModelData copyWith(
          {int? id,
          String? name,
          int? isActive,
          String? token,
          int? lastModified,
          int? isPublic,
          int? isPrivate,
          Value<String?> description = const Value.absent(),
          String? identifier,
          String? startDate,
          String? endDate,
          int? ownerId,
          int? priorityDefault,
          int? priorityStart,
          int? priorityEnd,
          Value<String?> email = const Value.absent(),
          Value<String?> predefinedEmailSubjects = const Value.absent(),
          int? perSwimlaneTaskLimits,
          int? taskLimit,
          int? enableGlobalTags,
          Value<int?> isTrelloImported = const Value.absent(),
          Url? url}) =>
      ProjectModelData(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        token: token ?? this.token,
        lastModified: lastModified ?? this.lastModified,
        isPublic: isPublic ?? this.isPublic,
        isPrivate: isPrivate ?? this.isPrivate,
        description: description.present ? description.value : this.description,
        identifier: identifier ?? this.identifier,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        ownerId: ownerId ?? this.ownerId,
        priorityDefault: priorityDefault ?? this.priorityDefault,
        priorityStart: priorityStart ?? this.priorityStart,
        priorityEnd: priorityEnd ?? this.priorityEnd,
        email: email.present ? email.value : this.email,
        predefinedEmailSubjects: predefinedEmailSubjects.present
            ? predefinedEmailSubjects.value
            : this.predefinedEmailSubjects,
        perSwimlaneTaskLimits:
            perSwimlaneTaskLimits ?? this.perSwimlaneTaskLimits,
        taskLimit: taskLimit ?? this.taskLimit,
        enableGlobalTags: enableGlobalTags ?? this.enableGlobalTags,
        isTrelloImported: isTrelloImported.present
            ? isTrelloImported.value
            : this.isTrelloImported,
        url: url ?? this.url,
      );
  @override
  String toString() {
    return (StringBuffer('ProjectModelData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('token: $token, ')
          ..write('lastModified: $lastModified, ')
          ..write('isPublic: $isPublic, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('description: $description, ')
          ..write('identifier: $identifier, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('ownerId: $ownerId, ')
          ..write('priorityDefault: $priorityDefault, ')
          ..write('priorityStart: $priorityStart, ')
          ..write('priorityEnd: $priorityEnd, ')
          ..write('email: $email, ')
          ..write('predefinedEmailSubjects: $predefinedEmailSubjects, ')
          ..write('perSwimlaneTaskLimits: $perSwimlaneTaskLimits, ')
          ..write('taskLimit: $taskLimit, ')
          ..write('enableGlobalTags: $enableGlobalTags, ')
          ..write('isTrelloImported: $isTrelloImported, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        isActive,
        token,
        lastModified,
        isPublic,
        isPrivate,
        description,
        identifier,
        startDate,
        endDate,
        ownerId,
        priorityDefault,
        priorityStart,
        priorityEnd,
        email,
        predefinedEmailSubjects,
        perSwimlaneTaskLimits,
        taskLimit,
        enableGlobalTags,
        isTrelloImported,
        url
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectModelData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.token == this.token &&
          other.lastModified == this.lastModified &&
          other.isPublic == this.isPublic &&
          other.isPrivate == this.isPrivate &&
          other.description == this.description &&
          other.identifier == this.identifier &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.ownerId == this.ownerId &&
          other.priorityDefault == this.priorityDefault &&
          other.priorityStart == this.priorityStart &&
          other.priorityEnd == this.priorityEnd &&
          other.email == this.email &&
          other.predefinedEmailSubjects == this.predefinedEmailSubjects &&
          other.perSwimlaneTaskLimits == this.perSwimlaneTaskLimits &&
          other.taskLimit == this.taskLimit &&
          other.enableGlobalTags == this.enableGlobalTags &&
          other.isTrelloImported == this.isTrelloImported &&
          other.url == this.url);
}

class ProjectModelCompanion extends UpdateCompanion<ProjectModelData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> isActive;
  final Value<String> token;
  final Value<int> lastModified;
  final Value<int> isPublic;
  final Value<int> isPrivate;
  final Value<String?> description;
  final Value<String> identifier;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<int> ownerId;
  final Value<int> priorityDefault;
  final Value<int> priorityStart;
  final Value<int> priorityEnd;
  final Value<String?> email;
  final Value<String?> predefinedEmailSubjects;
  final Value<int> perSwimlaneTaskLimits;
  final Value<int> taskLimit;
  final Value<int> enableGlobalTags;
  final Value<int?> isTrelloImported;
  final Value<Url> url;
  const ProjectModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.token = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.description = const Value.absent(),
    this.identifier = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.priorityDefault = const Value.absent(),
    this.priorityStart = const Value.absent(),
    this.priorityEnd = const Value.absent(),
    this.email = const Value.absent(),
    this.predefinedEmailSubjects = const Value.absent(),
    this.perSwimlaneTaskLimits = const Value.absent(),
    this.taskLimit = const Value.absent(),
    this.enableGlobalTags = const Value.absent(),
    this.isTrelloImported = const Value.absent(),
    this.url = const Value.absent(),
  });
  ProjectModelCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int isActive,
    required String token,
    required int lastModified,
    required int isPublic,
    required int isPrivate,
    this.description = const Value.absent(),
    required String identifier,
    required String startDate,
    required String endDate,
    required int ownerId,
    required int priorityDefault,
    required int priorityStart,
    required int priorityEnd,
    this.email = const Value.absent(),
    this.predefinedEmailSubjects = const Value.absent(),
    required int perSwimlaneTaskLimits,
    required int taskLimit,
    required int enableGlobalTags,
    this.isTrelloImported = const Value.absent(),
    required Url url,
  })  : name = Value(name),
        isActive = Value(isActive),
        token = Value(token),
        lastModified = Value(lastModified),
        isPublic = Value(isPublic),
        isPrivate = Value(isPrivate),
        identifier = Value(identifier),
        startDate = Value(startDate),
        endDate = Value(endDate),
        ownerId = Value(ownerId),
        priorityDefault = Value(priorityDefault),
        priorityStart = Value(priorityStart),
        priorityEnd = Value(priorityEnd),
        perSwimlaneTaskLimits = Value(perSwimlaneTaskLimits),
        taskLimit = Value(taskLimit),
        enableGlobalTags = Value(enableGlobalTags),
        url = Value(url);
  static Insertable<ProjectModelData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? isActive,
    Expression<String>? token,
    Expression<int>? lastModified,
    Expression<int>? isPublic,
    Expression<int>? isPrivate,
    Expression<String>? description,
    Expression<String>? identifier,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? ownerId,
    Expression<int>? priorityDefault,
    Expression<int>? priorityStart,
    Expression<int>? priorityEnd,
    Expression<String>? email,
    Expression<String>? predefinedEmailSubjects,
    Expression<int>? perSwimlaneTaskLimits,
    Expression<int>? taskLimit,
    Expression<int>? enableGlobalTags,
    Expression<int>? isTrelloImported,
    Expression<String>? url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (token != null) 'token': token,
      if (lastModified != null) 'last_modified': lastModified,
      if (isPublic != null) 'is_public': isPublic,
      if (isPrivate != null) 'is_private': isPrivate,
      if (description != null) 'description': description,
      if (identifier != null) 'identifier': identifier,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (ownerId != null) 'owner_id': ownerId,
      if (priorityDefault != null) 'priority_default': priorityDefault,
      if (priorityStart != null) 'priority_start': priorityStart,
      if (priorityEnd != null) 'priority_end': priorityEnd,
      if (email != null) 'email': email,
      if (predefinedEmailSubjects != null)
        'predefined_email_subjects': predefinedEmailSubjects,
      if (perSwimlaneTaskLimits != null)
        'per_swimlane_task_limits': perSwimlaneTaskLimits,
      if (taskLimit != null) 'task_limit': taskLimit,
      if (enableGlobalTags != null) 'enable_global_tags': enableGlobalTags,
      if (isTrelloImported != null) 'is_trello_imported': isTrelloImported,
      if (url != null) 'url': url,
    });
  }

  ProjectModelCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? isActive,
      Value<String>? token,
      Value<int>? lastModified,
      Value<int>? isPublic,
      Value<int>? isPrivate,
      Value<String?>? description,
      Value<String>? identifier,
      Value<String>? startDate,
      Value<String>? endDate,
      Value<int>? ownerId,
      Value<int>? priorityDefault,
      Value<int>? priorityStart,
      Value<int>? priorityEnd,
      Value<String?>? email,
      Value<String?>? predefinedEmailSubjects,
      Value<int>? perSwimlaneTaskLimits,
      Value<int>? taskLimit,
      Value<int>? enableGlobalTags,
      Value<int?>? isTrelloImported,
      Value<Url>? url}) {
    return ProjectModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      lastModified: lastModified ?? this.lastModified,
      isPublic: isPublic ?? this.isPublic,
      isPrivate: isPrivate ?? this.isPrivate,
      description: description ?? this.description,
      identifier: identifier ?? this.identifier,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      ownerId: ownerId ?? this.ownerId,
      priorityDefault: priorityDefault ?? this.priorityDefault,
      priorityStart: priorityStart ?? this.priorityStart,
      priorityEnd: priorityEnd ?? this.priorityEnd,
      email: email ?? this.email,
      predefinedEmailSubjects:
          predefinedEmailSubjects ?? this.predefinedEmailSubjects,
      perSwimlaneTaskLimits:
          perSwimlaneTaskLimits ?? this.perSwimlaneTaskLimits,
      taskLimit: taskLimit ?? this.taskLimit,
      enableGlobalTags: enableGlobalTags ?? this.enableGlobalTags,
      isTrelloImported: isTrelloImported ?? this.isTrelloImported,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<int>(lastModified.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<int>(isPublic.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<int>(isPrivate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (priorityDefault.present) {
      map['priority_default'] = Variable<int>(priorityDefault.value);
    }
    if (priorityStart.present) {
      map['priority_start'] = Variable<int>(priorityStart.value);
    }
    if (priorityEnd.present) {
      map['priority_end'] = Variable<int>(priorityEnd.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (predefinedEmailSubjects.present) {
      map['predefined_email_subjects'] =
          Variable<String>(predefinedEmailSubjects.value);
    }
    if (perSwimlaneTaskLimits.present) {
      map['per_swimlane_task_limits'] =
          Variable<int>(perSwimlaneTaskLimits.value);
    }
    if (taskLimit.present) {
      map['task_limit'] = Variable<int>(taskLimit.value);
    }
    if (enableGlobalTags.present) {
      map['enable_global_tags'] = Variable<int>(enableGlobalTags.value);
    }
    if (isTrelloImported.present) {
      map['is_trello_imported'] = Variable<int>(isTrelloImported.value);
    }
    if (url.present) {
      map['url'] =
          Variable<String>($ProjectModelTable.$converterurl.toSql(url.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectModelCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('token: $token, ')
          ..write('lastModified: $lastModified, ')
          ..write('isPublic: $isPublic, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('description: $description, ')
          ..write('identifier: $identifier, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('ownerId: $ownerId, ')
          ..write('priorityDefault: $priorityDefault, ')
          ..write('priorityStart: $priorityStart, ')
          ..write('priorityEnd: $priorityEnd, ')
          ..write('email: $email, ')
          ..write('predefinedEmailSubjects: $predefinedEmailSubjects, ')
          ..write('perSwimlaneTaskLimits: $perSwimlaneTaskLimits, ')
          ..write('taskLimit: $taskLimit, ')
          ..write('enableGlobalTags: $enableGlobalTags, ')
          ..write('isTrelloImported: $isTrelloImported, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $ColumnModelTable extends ColumnModel
    with TableInfo<$ColumnModelTable, ColumnModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColumnModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskLimitMeta =
      const VerificationMeta('taskLimit');
  @override
  late final GeneratedColumn<int> taskLimit = GeneratedColumn<int>(
      'task_limit', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hideInDashboardMeta =
      const VerificationMeta('hideInDashboard');
  @override
  late final GeneratedColumn<int> hideInDashboard = GeneratedColumn<int>(
      'hide_in_dashboard', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES project_model (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, position, taskLimit, description, hideInDashboard, projectId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'column_model';
  @override
  VerificationContext validateIntegrity(Insertable<ColumnModelData> instance,
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
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('task_limit')) {
      context.handle(_taskLimitMeta,
          taskLimit.isAcceptableOrUnknown(data['task_limit']!, _taskLimitMeta));
    } else if (isInserting) {
      context.missing(_taskLimitMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('hide_in_dashboard')) {
      context.handle(
          _hideInDashboardMeta,
          hideInDashboard.isAcceptableOrUnknown(
              data['hide_in_dashboard']!, _hideInDashboardMeta));
    } else if (isInserting) {
      context.missing(_hideInDashboardMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, projectId};
  @override
  ColumnModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ColumnModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      taskLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_limit'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      hideInDashboard: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hide_in_dashboard'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
    );
  }

  @override
  $ColumnModelTable createAlias(String alias) {
    return $ColumnModelTable(attachedDatabase, alias);
  }
}

class ColumnModelData extends DataClass implements Insertable<ColumnModelData> {
  final int id;
  final String title;
  final int position;
  final int taskLimit;
  final String description;
  final int hideInDashboard;
  final int projectId;
  const ColumnModelData(
      {required this.id,
      required this.title,
      required this.position,
      required this.taskLimit,
      required this.description,
      required this.hideInDashboard,
      required this.projectId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['position'] = Variable<int>(position);
    map['task_limit'] = Variable<int>(taskLimit);
    map['description'] = Variable<String>(description);
    map['hide_in_dashboard'] = Variable<int>(hideInDashboard);
    map['project_id'] = Variable<int>(projectId);
    return map;
  }

  ColumnModelCompanion toCompanion(bool nullToAbsent) {
    return ColumnModelCompanion(
      id: Value(id),
      title: Value(title),
      position: Value(position),
      taskLimit: Value(taskLimit),
      description: Value(description),
      hideInDashboard: Value(hideInDashboard),
      projectId: Value(projectId),
    );
  }

  factory ColumnModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ColumnModelData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      position: serializer.fromJson<int>(json['position']),
      taskLimit: serializer.fromJson<int>(json['task_limit']),
      description: serializer.fromJson<String>(json['description']),
      hideInDashboard: serializer.fromJson<int>(json['hide_in_dashboard']),
      projectId: serializer.fromJson<int>(json['project_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'position': serializer.toJson<int>(position),
      'task_limit': serializer.toJson<int>(taskLimit),
      'description': serializer.toJson<String>(description),
      'hide_in_dashboard': serializer.toJson<int>(hideInDashboard),
      'project_id': serializer.toJson<int>(projectId),
    };
  }

  ColumnModelData copyWith(
          {int? id,
          String? title,
          int? position,
          int? taskLimit,
          String? description,
          int? hideInDashboard,
          int? projectId}) =>
      ColumnModelData(
        id: id ?? this.id,
        title: title ?? this.title,
        position: position ?? this.position,
        taskLimit: taskLimit ?? this.taskLimit,
        description: description ?? this.description,
        hideInDashboard: hideInDashboard ?? this.hideInDashboard,
        projectId: projectId ?? this.projectId,
      );
  @override
  String toString() {
    return (StringBuffer('ColumnModelData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('taskLimit: $taskLimit, ')
          ..write('description: $description, ')
          ..write('hideInDashboard: $hideInDashboard, ')
          ..write('projectId: $projectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, position, taskLimit, description, hideInDashboard, projectId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ColumnModelData &&
          other.id == this.id &&
          other.title == this.title &&
          other.position == this.position &&
          other.taskLimit == this.taskLimit &&
          other.description == this.description &&
          other.hideInDashboard == this.hideInDashboard &&
          other.projectId == this.projectId);
}

class ColumnModelCompanion extends UpdateCompanion<ColumnModelData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> position;
  final Value<int> taskLimit;
  final Value<String> description;
  final Value<int> hideInDashboard;
  final Value<int> projectId;
  final Value<int> rowid;
  const ColumnModelCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
    this.taskLimit = const Value.absent(),
    this.description = const Value.absent(),
    this.hideInDashboard = const Value.absent(),
    this.projectId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ColumnModelCompanion.insert({
    required int id,
    required String title,
    required int position,
    required int taskLimit,
    required String description,
    required int hideInDashboard,
    required int projectId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        taskLimit = Value(taskLimit),
        description = Value(description),
        hideInDashboard = Value(hideInDashboard),
        projectId = Value(projectId);
  static Insertable<ColumnModelData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? position,
    Expression<int>? taskLimit,
    Expression<String>? description,
    Expression<int>? hideInDashboard,
    Expression<int>? projectId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
      if (taskLimit != null) 'task_limit': taskLimit,
      if (description != null) 'description': description,
      if (hideInDashboard != null) 'hide_in_dashboard': hideInDashboard,
      if (projectId != null) 'project_id': projectId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ColumnModelCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? position,
      Value<int>? taskLimit,
      Value<String>? description,
      Value<int>? hideInDashboard,
      Value<int>? projectId,
      Value<int>? rowid}) {
    return ColumnModelCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      taskLimit: taskLimit ?? this.taskLimit,
      description: description ?? this.description,
      hideInDashboard: hideInDashboard ?? this.hideInDashboard,
      projectId: projectId ?? this.projectId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (taskLimit.present) {
      map['task_limit'] = Variable<int>(taskLimit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (hideInDashboard.present) {
      map['hide_in_dashboard'] = Variable<int>(hideInDashboard.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColumnModelCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('taskLimit: $taskLimit, ')
          ..write('description: $description, ')
          ..write('hideInDashboard: $hideInDashboard, ')
          ..write('projectId: $projectId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommentModelTable extends CommentModel
    with TableInfo<$CommentModelTable, CommentModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<int> dateCreation = GeneratedColumn<int>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<int> dateModification = GeneratedColumn<int>(
      'date_modification', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
      'task_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dateCreation,
        dateModification,
        taskId,
        userId,
        comment,
        username,
        name,
        email,
        avatarPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comment_model';
  @override
  VerificationContext validateIntegrity(Insertable<CommentModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    } else if (isInserting) {
      context.missing(_dateCreationMeta);
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    } else if (isInserting) {
      context.missing(_dateModificationMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, taskId};
  @override
  CommentModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommentModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dateCreation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_creation'])!,
      dateModification: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_modification'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
    );
  }

  @override
  $CommentModelTable createAlias(String alias) {
    return $CommentModelTable(attachedDatabase, alias);
  }
}

class CommentModelData extends DataClass
    implements Insertable<CommentModelData> {
  final int id;
  final int dateCreation;
  final int dateModification;
  final int taskId;
  final int userId;
  final String comment;
  final String? username;
  final String? name;
  final String? email;
  final String? avatarPath;
  const CommentModelData(
      {required this.id,
      required this.dateCreation,
      required this.dateModification,
      required this.taskId,
      required this.userId,
      required this.comment,
      this.username,
      this.name,
      this.email,
      this.avatarPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_creation'] = Variable<int>(dateCreation);
    map['date_modification'] = Variable<int>(dateModification);
    map['task_id'] = Variable<int>(taskId);
    map['user_id'] = Variable<int>(userId);
    map['comment'] = Variable<String>(comment);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    return map;
  }

  CommentModelCompanion toCompanion(bool nullToAbsent) {
    return CommentModelCompanion(
      id: Value(id),
      dateCreation: Value(dateCreation),
      dateModification: Value(dateModification),
      taskId: Value(taskId),
      userId: Value(userId),
      comment: Value(comment),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
    );
  }

  factory CommentModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommentModelData(
      id: serializer.fromJson<int>(json['id']),
      dateCreation: serializer.fromJson<int>(json['date_creation']),
      dateModification: serializer.fromJson<int>(json['date_modification']),
      taskId: serializer.fromJson<int>(json['task_id']),
      userId: serializer.fromJson<int>(json['user_id']),
      comment: serializer.fromJson<String>(json['comment']),
      username: serializer.fromJson<String?>(json['username']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      avatarPath: serializer.fromJson<String?>(json['avatar_path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date_creation': serializer.toJson<int>(dateCreation),
      'date_modification': serializer.toJson<int>(dateModification),
      'task_id': serializer.toJson<int>(taskId),
      'user_id': serializer.toJson<int>(userId),
      'comment': serializer.toJson<String>(comment),
      'username': serializer.toJson<String?>(username),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'avatar_path': serializer.toJson<String?>(avatarPath),
    };
  }

  CommentModelData copyWith(
          {int? id,
          int? dateCreation,
          int? dateModification,
          int? taskId,
          int? userId,
          String? comment,
          Value<String?> username = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> avatarPath = const Value.absent()}) =>
      CommentModelData(
        id: id ?? this.id,
        dateCreation: dateCreation ?? this.dateCreation,
        dateModification: dateModification ?? this.dateModification,
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        comment: comment ?? this.comment,
        username: username.present ? username.value : this.username,
        name: name.present ? name.value : this.name,
        email: email.present ? email.value : this.email,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
      );
  @override
  String toString() {
    return (StringBuffer('CommentModelData(')
          ..write('id: $id, ')
          ..write('dateCreation: $dateCreation, ')
          ..write('dateModification: $dateModification, ')
          ..write('taskId: $taskId, ')
          ..write('userId: $userId, ')
          ..write('comment: $comment, ')
          ..write('username: $username, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dateCreation, dateModification, taskId,
      userId, comment, username, name, email, avatarPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentModelData &&
          other.id == this.id &&
          other.dateCreation == this.dateCreation &&
          other.dateModification == this.dateModification &&
          other.taskId == this.taskId &&
          other.userId == this.userId &&
          other.comment == this.comment &&
          other.username == this.username &&
          other.name == this.name &&
          other.email == this.email &&
          other.avatarPath == this.avatarPath);
}

class CommentModelCompanion extends UpdateCompanion<CommentModelData> {
  final Value<int> id;
  final Value<int> dateCreation;
  final Value<int> dateModification;
  final Value<int> taskId;
  final Value<int> userId;
  final Value<String> comment;
  final Value<String?> username;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String?> avatarPath;
  final Value<int> rowid;
  const CommentModelCompanion({
    this.id = const Value.absent(),
    this.dateCreation = const Value.absent(),
    this.dateModification = const Value.absent(),
    this.taskId = const Value.absent(),
    this.userId = const Value.absent(),
    this.comment = const Value.absent(),
    this.username = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentModelCompanion.insert({
    required int id,
    required int dateCreation,
    required int dateModification,
    required int taskId,
    required int userId,
    required String comment,
    this.username = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dateCreation = Value(dateCreation),
        dateModification = Value(dateModification),
        taskId = Value(taskId),
        userId = Value(userId),
        comment = Value(comment);
  static Insertable<CommentModelData> custom({
    Expression<int>? id,
    Expression<int>? dateCreation,
    Expression<int>? dateModification,
    Expression<int>? taskId,
    Expression<int>? userId,
    Expression<String>? comment,
    Expression<String>? username,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? avatarPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateCreation != null) 'date_creation': dateCreation,
      if (dateModification != null) 'date_modification': dateModification,
      if (taskId != null) 'task_id': taskId,
      if (userId != null) 'user_id': userId,
      if (comment != null) 'comment': comment,
      if (username != null) 'username': username,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentModelCompanion copyWith(
      {Value<int>? id,
      Value<int>? dateCreation,
      Value<int>? dateModification,
      Value<int>? taskId,
      Value<int>? userId,
      Value<String>? comment,
      Value<String?>? username,
      Value<String?>? name,
      Value<String?>? email,
      Value<String?>? avatarPath,
      Value<int>? rowid}) {
    return CommentModelCompanion(
      id: id ?? this.id,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<int>(dateCreation.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<int>(dateModification.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentModelCompanion(')
          ..write('id: $id, ')
          ..write('dateCreation: $dateCreation, ')
          ..write('dateModification: $dateModification, ')
          ..write('taskId: $taskId, ')
          ..write('userId: $userId, ')
          ..write('comment: $comment, ')
          ..write('username: $username, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtaskModelTable extends SubtaskModel
    with TableInfo<$SubtaskModelTable, SubtaskModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtaskModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timeEstimatedMeta =
      const VerificationMeta('timeEstimated');
  @override
  late final GeneratedColumn<int> timeEstimated = GeneratedColumn<int>(
      'time_estimated', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timeSpentMeta =
      const VerificationMeta('timeSpent');
  @override
  late final GeneratedColumn<int> timeSpent = GeneratedColumn<int>(
      'time_spent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
      'task_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timerStartDateMeta =
      const VerificationMeta('timerStartDate');
  @override
  late final GeneratedColumn<int> timerStartDate = GeneratedColumn<int>(
      'timer_start_date', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusNameMeta =
      const VerificationMeta('statusName');
  @override
  late final GeneratedColumn<String> statusName = GeneratedColumn<String>(
      'status_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isTimerStartedMeta =
      const VerificationMeta('isTimerStarted');
  @override
  late final GeneratedColumn<bool> isTimerStarted = GeneratedColumn<bool>(
      'is_timer_started', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_timer_started" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        status,
        timeEstimated,
        timeSpent,
        taskId,
        userId,
        position,
        username,
        name,
        timerStartDate,
        statusName,
        isTimerStarted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtask_model';
  @override
  VerificationContext validateIntegrity(Insertable<SubtaskModelData> instance,
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
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('time_estimated')) {
      context.handle(
          _timeEstimatedMeta,
          timeEstimated.isAcceptableOrUnknown(
              data['time_estimated']!, _timeEstimatedMeta));
    } else if (isInserting) {
      context.missing(_timeEstimatedMeta);
    }
    if (data.containsKey('time_spent')) {
      context.handle(_timeSpentMeta,
          timeSpent.isAcceptableOrUnknown(data['time_spent']!, _timeSpentMeta));
    } else if (isInserting) {
      context.missing(_timeSpentMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('timer_start_date')) {
      context.handle(
          _timerStartDateMeta,
          timerStartDate.isAcceptableOrUnknown(
              data['timer_start_date']!, _timerStartDateMeta));
    } else if (isInserting) {
      context.missing(_timerStartDateMeta);
    }
    if (data.containsKey('status_name')) {
      context.handle(
          _statusNameMeta,
          statusName.isAcceptableOrUnknown(
              data['status_name']!, _statusNameMeta));
    }
    if (data.containsKey('is_timer_started')) {
      context.handle(
          _isTimerStartedMeta,
          isTimerStarted.isAcceptableOrUnknown(
              data['is_timer_started']!, _isTimerStartedMeta));
    } else if (isInserting) {
      context.missing(_isTimerStartedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, taskId};
  @override
  SubtaskModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtaskModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      timeEstimated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_estimated'])!,
      timeSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_spent'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      timerStartDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timer_start_date'])!,
      statusName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status_name']),
      isTimerStarted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_timer_started'])!,
    );
  }

  @override
  $SubtaskModelTable createAlias(String alias) {
    return $SubtaskModelTable(attachedDatabase, alias);
  }
}

class SubtaskModelData extends DataClass
    implements Insertable<SubtaskModelData> {
  final int id;
  final String title;
  final int status;
  final int timeEstimated;
  final int timeSpent;
  final int taskId;
  final int userId;
  final int position;
  final String? username;
  final String? name;
  final int timerStartDate;
  final String? statusName;
  final bool isTimerStarted;
  const SubtaskModelData(
      {required this.id,
      required this.title,
      required this.status,
      required this.timeEstimated,
      required this.timeSpent,
      required this.taskId,
      required this.userId,
      required this.position,
      this.username,
      this.name,
      required this.timerStartDate,
      this.statusName,
      required this.isTimerStarted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<int>(status);
    map['time_estimated'] = Variable<int>(timeEstimated);
    map['time_spent'] = Variable<int>(timeSpent);
    map['task_id'] = Variable<int>(taskId);
    map['user_id'] = Variable<int>(userId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['timer_start_date'] = Variable<int>(timerStartDate);
    if (!nullToAbsent || statusName != null) {
      map['status_name'] = Variable<String>(statusName);
    }
    map['is_timer_started'] = Variable<bool>(isTimerStarted);
    return map;
  }

  SubtaskModelCompanion toCompanion(bool nullToAbsent) {
    return SubtaskModelCompanion(
      id: Value(id),
      title: Value(title),
      status: Value(status),
      timeEstimated: Value(timeEstimated),
      timeSpent: Value(timeSpent),
      taskId: Value(taskId),
      userId: Value(userId),
      position: Value(position),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      timerStartDate: Value(timerStartDate),
      statusName: statusName == null && nullToAbsent
          ? const Value.absent()
          : Value(statusName),
      isTimerStarted: Value(isTimerStarted),
    );
  }

  factory SubtaskModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtaskModelData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<int>(json['status']),
      timeEstimated: serializer.fromJson<int>(json['time_estimated']),
      timeSpent: serializer.fromJson<int>(json['time_spent']),
      taskId: serializer.fromJson<int>(json['task_id']),
      userId: serializer.fromJson<int>(json['user_id']),
      position: serializer.fromJson<int>(json['position']),
      username: serializer.fromJson<String?>(json['username']),
      name: serializer.fromJson<String?>(json['name']),
      timerStartDate: serializer.fromJson<int>(json['timer_start_date']),
      statusName: serializer.fromJson<String?>(json['status_name']),
      isTimerStarted: serializer.fromJson<bool>(json['is_timer_started']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<int>(status),
      'time_estimated': serializer.toJson<int>(timeEstimated),
      'time_spent': serializer.toJson<int>(timeSpent),
      'task_id': serializer.toJson<int>(taskId),
      'user_id': serializer.toJson<int>(userId),
      'position': serializer.toJson<int>(position),
      'username': serializer.toJson<String?>(username),
      'name': serializer.toJson<String?>(name),
      'timer_start_date': serializer.toJson<int>(timerStartDate),
      'status_name': serializer.toJson<String?>(statusName),
      'is_timer_started': serializer.toJson<bool>(isTimerStarted),
    };
  }

  SubtaskModelData copyWith(
          {int? id,
          String? title,
          int? status,
          int? timeEstimated,
          int? timeSpent,
          int? taskId,
          int? userId,
          int? position,
          Value<String?> username = const Value.absent(),
          Value<String?> name = const Value.absent(),
          int? timerStartDate,
          Value<String?> statusName = const Value.absent(),
          bool? isTimerStarted}) =>
      SubtaskModelData(
        id: id ?? this.id,
        title: title ?? this.title,
        status: status ?? this.status,
        timeEstimated: timeEstimated ?? this.timeEstimated,
        timeSpent: timeSpent ?? this.timeSpent,
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        position: position ?? this.position,
        username: username.present ? username.value : this.username,
        name: name.present ? name.value : this.name,
        timerStartDate: timerStartDate ?? this.timerStartDate,
        statusName: statusName.present ? statusName.value : this.statusName,
        isTimerStarted: isTimerStarted ?? this.isTimerStarted,
      );
  @override
  String toString() {
    return (StringBuffer('SubtaskModelData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('timeEstimated: $timeEstimated, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('taskId: $taskId, ')
          ..write('userId: $userId, ')
          ..write('position: $position, ')
          ..write('username: $username, ')
          ..write('name: $name, ')
          ..write('timerStartDate: $timerStartDate, ')
          ..write('statusName: $statusName, ')
          ..write('isTimerStarted: $isTimerStarted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      status,
      timeEstimated,
      timeSpent,
      taskId,
      userId,
      position,
      username,
      name,
      timerStartDate,
      statusName,
      isTimerStarted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtaskModelData &&
          other.id == this.id &&
          other.title == this.title &&
          other.status == this.status &&
          other.timeEstimated == this.timeEstimated &&
          other.timeSpent == this.timeSpent &&
          other.taskId == this.taskId &&
          other.userId == this.userId &&
          other.position == this.position &&
          other.username == this.username &&
          other.name == this.name &&
          other.timerStartDate == this.timerStartDate &&
          other.statusName == this.statusName &&
          other.isTimerStarted == this.isTimerStarted);
}

class SubtaskModelCompanion extends UpdateCompanion<SubtaskModelData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> status;
  final Value<int> timeEstimated;
  final Value<int> timeSpent;
  final Value<int> taskId;
  final Value<int> userId;
  final Value<int> position;
  final Value<String?> username;
  final Value<String?> name;
  final Value<int> timerStartDate;
  final Value<String?> statusName;
  final Value<bool> isTimerStarted;
  final Value<int> rowid;
  const SubtaskModelCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.timeEstimated = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.taskId = const Value.absent(),
    this.userId = const Value.absent(),
    this.position = const Value.absent(),
    this.username = const Value.absent(),
    this.name = const Value.absent(),
    this.timerStartDate = const Value.absent(),
    this.statusName = const Value.absent(),
    this.isTimerStarted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtaskModelCompanion.insert({
    required int id,
    required String title,
    required int status,
    required int timeEstimated,
    required int timeSpent,
    required int taskId,
    required int userId,
    required int position,
    this.username = const Value.absent(),
    this.name = const Value.absent(),
    required int timerStartDate,
    this.statusName = const Value.absent(),
    required bool isTimerStarted,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        status = Value(status),
        timeEstimated = Value(timeEstimated),
        timeSpent = Value(timeSpent),
        taskId = Value(taskId),
        userId = Value(userId),
        position = Value(position),
        timerStartDate = Value(timerStartDate),
        isTimerStarted = Value(isTimerStarted);
  static Insertable<SubtaskModelData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? status,
    Expression<int>? timeEstimated,
    Expression<int>? timeSpent,
    Expression<int>? taskId,
    Expression<int>? userId,
    Expression<int>? position,
    Expression<String>? username,
    Expression<String>? name,
    Expression<int>? timerStartDate,
    Expression<String>? statusName,
    Expression<bool>? isTimerStarted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (timeEstimated != null) 'time_estimated': timeEstimated,
      if (timeSpent != null) 'time_spent': timeSpent,
      if (taskId != null) 'task_id': taskId,
      if (userId != null) 'user_id': userId,
      if (position != null) 'position': position,
      if (username != null) 'username': username,
      if (name != null) 'name': name,
      if (timerStartDate != null) 'timer_start_date': timerStartDate,
      if (statusName != null) 'status_name': statusName,
      if (isTimerStarted != null) 'is_timer_started': isTimerStarted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtaskModelCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? status,
      Value<int>? timeEstimated,
      Value<int>? timeSpent,
      Value<int>? taskId,
      Value<int>? userId,
      Value<int>? position,
      Value<String?>? username,
      Value<String?>? name,
      Value<int>? timerStartDate,
      Value<String?>? statusName,
      Value<bool>? isTimerStarted,
      Value<int>? rowid}) {
    return SubtaskModelCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      timeEstimated: timeEstimated ?? this.timeEstimated,
      timeSpent: timeSpent ?? this.timeSpent,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      position: position ?? this.position,
      username: username ?? this.username,
      name: name ?? this.name,
      timerStartDate: timerStartDate ?? this.timerStartDate,
      statusName: statusName ?? this.statusName,
      isTimerStarted: isTimerStarted ?? this.isTimerStarted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (timeEstimated.present) {
      map['time_estimated'] = Variable<int>(timeEstimated.value);
    }
    if (timeSpent.present) {
      map['time_spent'] = Variable<int>(timeSpent.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (timerStartDate.present) {
      map['timer_start_date'] = Variable<int>(timerStartDate.value);
    }
    if (statusName.present) {
      map['status_name'] = Variable<String>(statusName.value);
    }
    if (isTimerStarted.present) {
      map['is_timer_started'] = Variable<bool>(isTimerStarted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtaskModelCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('timeEstimated: $timeEstimated, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('taskId: $taskId, ')
          ..write('userId: $userId, ')
          ..write('position: $position, ')
          ..write('username: $username, ')
          ..write('name: $name, ')
          ..write('timerStartDate: $timerStartDate, ')
          ..write('statusName: $statusName, ')
          ..write('isTimerStarted: $isTimerStarted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskModelTable extends TaskModel
    with TableInfo<$TaskModelTable, TaskModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<int> dateCreation = GeneratedColumn<int>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorIdMeta =
      const VerificationMeta('colorId');
  @override
  late final GeneratedColumn<String> colorId = GeneratedColumn<String>(
      'color_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES project_model (id)'));
  static const VerificationMeta _columnIdMeta =
      const VerificationMeta('columnId');
  @override
  late final GeneratedColumn<int> columnId = GeneratedColumn<int>(
      'column_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES column_model (id)'));
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateCompletedMeta =
      const VerificationMeta('dateCompleted');
  @override
  late final GeneratedColumn<int> dateCompleted = GeneratedColumn<int>(
      'date_completed', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateDueMeta =
      const VerificationMeta('dateDue');
  @override
  late final GeneratedColumn<int> dateDue = GeneratedColumn<int>(
      'date_due', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _creatorIdMeta =
      const VerificationMeta('creatorId');
  @override
  late final GeneratedColumn<int> creatorId = GeneratedColumn<int>(
      'creator_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<int> dateModification = GeneratedColumn<int>(
      'date_modification', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateStartedMeta =
      const VerificationMeta('dateStarted');
  @override
  late final GeneratedColumn<int> dateStarted = GeneratedColumn<int>(
      'date_started', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeSpentMeta =
      const VerificationMeta('timeSpent');
  @override
  late final GeneratedColumn<int> timeSpent = GeneratedColumn<int>(
      'time_spent', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeEstimatedMeta =
      const VerificationMeta('timeEstimated');
  @override
  late final GeneratedColumn<int> timeEstimated = GeneratedColumn<int>(
      'time_estimated', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _swimlaneIdMeta =
      const VerificationMeta('swimlaneId');
  @override
  late final GeneratedColumn<int> swimlaneId = GeneratedColumn<int>(
      'swimlane_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMovedMeta =
      const VerificationMeta('dateMoved');
  @override
  late final GeneratedColumn<int> dateMoved = GeneratedColumn<int>(
      'date_moved', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceStatusMeta =
      const VerificationMeta('recurrenceStatus');
  @override
  late final GeneratedColumn<int> recurrenceStatus = GeneratedColumn<int>(
      'recurrence_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceTriggerMeta =
      const VerificationMeta('recurrenceTrigger');
  @override
  late final GeneratedColumn<int> recurrenceTrigger = GeneratedColumn<int>(
      'recurrence_trigger', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceFactorMeta =
      const VerificationMeta('recurrenceFactor');
  @override
  late final GeneratedColumn<int> recurrenceFactor = GeneratedColumn<int>(
      'recurrence_factor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceTimeframeMeta =
      const VerificationMeta('recurrenceTimeframe');
  @override
  late final GeneratedColumn<int> recurrenceTimeframe = GeneratedColumn<int>(
      'recurrence_timeframe', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceBasedateMeta =
      const VerificationMeta('recurrenceBasedate');
  @override
  late final GeneratedColumn<int> recurrenceBasedate = GeneratedColumn<int>(
      'recurrence_basedate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceParentMeta =
      const VerificationMeta('recurrenceParent');
  @override
  late final GeneratedColumn<int> recurrenceParent = GeneratedColumn<int>(
      'recurrence_parent', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceChildMeta =
      const VerificationMeta('recurrenceChild');
  @override
  late final GeneratedColumn<int> recurrenceChild = GeneratedColumn<int>(
      'recurrence_child', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        dateCreation,
        colorId,
        projectId,
        columnId,
        ownerId,
        position,
        isActive,
        dateCompleted,
        score,
        dateDue,
        categoryId,
        creatorId,
        dateModification,
        reference,
        dateStarted,
        timeSpent,
        timeEstimated,
        swimlaneId,
        dateMoved,
        recurrenceStatus,
        recurrenceTrigger,
        recurrenceFactor,
        recurrenceTimeframe,
        recurrenceBasedate,
        recurrenceParent,
        recurrenceChild,
        priority
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_model';
  @override
  VerificationContext validateIntegrity(Insertable<TaskModelData> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    } else if (isInserting) {
      context.missing(_dateCreationMeta);
    }
    if (data.containsKey('color_id')) {
      context.handle(_colorIdMeta,
          colorId.isAcceptableOrUnknown(data['color_id']!, _colorIdMeta));
    } else if (isInserting) {
      context.missing(_colorIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('column_id')) {
      context.handle(_columnIdMeta,
          columnId.isAcceptableOrUnknown(data['column_id']!, _columnIdMeta));
    } else if (isInserting) {
      context.missing(_columnIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('date_completed')) {
      context.handle(
          _dateCompletedMeta,
          dateCompleted.isAcceptableOrUnknown(
              data['date_completed']!, _dateCompletedMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('date_due')) {
      context.handle(_dateDueMeta,
          dateDue.isAcceptableOrUnknown(data['date_due']!, _dateDueMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('creator_id')) {
      context.handle(_creatorIdMeta,
          creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta));
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('date_started')) {
      context.handle(
          _dateStartedMeta,
          dateStarted.isAcceptableOrUnknown(
              data['date_started']!, _dateStartedMeta));
    }
    if (data.containsKey('time_spent')) {
      context.handle(_timeSpentMeta,
          timeSpent.isAcceptableOrUnknown(data['time_spent']!, _timeSpentMeta));
    }
    if (data.containsKey('time_estimated')) {
      context.handle(
          _timeEstimatedMeta,
          timeEstimated.isAcceptableOrUnknown(
              data['time_estimated']!, _timeEstimatedMeta));
    }
    if (data.containsKey('swimlane_id')) {
      context.handle(
          _swimlaneIdMeta,
          swimlaneId.isAcceptableOrUnknown(
              data['swimlane_id']!, _swimlaneIdMeta));
    } else if (isInserting) {
      context.missing(_swimlaneIdMeta);
    }
    if (data.containsKey('date_moved')) {
      context.handle(_dateMovedMeta,
          dateMoved.isAcceptableOrUnknown(data['date_moved']!, _dateMovedMeta));
    } else if (isInserting) {
      context.missing(_dateMovedMeta);
    }
    if (data.containsKey('recurrence_status')) {
      context.handle(
          _recurrenceStatusMeta,
          recurrenceStatus.isAcceptableOrUnknown(
              data['recurrence_status']!, _recurrenceStatusMeta));
    } else if (isInserting) {
      context.missing(_recurrenceStatusMeta);
    }
    if (data.containsKey('recurrence_trigger')) {
      context.handle(
          _recurrenceTriggerMeta,
          recurrenceTrigger.isAcceptableOrUnknown(
              data['recurrence_trigger']!, _recurrenceTriggerMeta));
    } else if (isInserting) {
      context.missing(_recurrenceTriggerMeta);
    }
    if (data.containsKey('recurrence_factor')) {
      context.handle(
          _recurrenceFactorMeta,
          recurrenceFactor.isAcceptableOrUnknown(
              data['recurrence_factor']!, _recurrenceFactorMeta));
    } else if (isInserting) {
      context.missing(_recurrenceFactorMeta);
    }
    if (data.containsKey('recurrence_timeframe')) {
      context.handle(
          _recurrenceTimeframeMeta,
          recurrenceTimeframe.isAcceptableOrUnknown(
              data['recurrence_timeframe']!, _recurrenceTimeframeMeta));
    } else if (isInserting) {
      context.missing(_recurrenceTimeframeMeta);
    }
    if (data.containsKey('recurrence_basedate')) {
      context.handle(
          _recurrenceBasedateMeta,
          recurrenceBasedate.isAcceptableOrUnknown(
              data['recurrence_basedate']!, _recurrenceBasedateMeta));
    } else if (isInserting) {
      context.missing(_recurrenceBasedateMeta);
    }
    if (data.containsKey('recurrence_parent')) {
      context.handle(
          _recurrenceParentMeta,
          recurrenceParent.isAcceptableOrUnknown(
              data['recurrence_parent']!, _recurrenceParentMeta));
    }
    if (data.containsKey('recurrence_child')) {
      context.handle(
          _recurrenceChildMeta,
          recurrenceChild.isAcceptableOrUnknown(
              data['recurrence_child']!, _recurrenceChildMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, columnId, projectId};
  @override
  TaskModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      dateCreation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_creation'])!,
      colorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      columnId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}column_id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      dateCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_completed']),
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score']),
      dateDue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_due']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      creatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}creator_id'])!,
      dateModification: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_modification']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      dateStarted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_started']),
      timeSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_spent']),
      timeEstimated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_estimated']),
      swimlaneId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}swimlane_id'])!,
      dateMoved: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_moved'])!,
      recurrenceStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_status'])!,
      recurrenceTrigger: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurrence_trigger'])!,
      recurrenceFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_factor'])!,
      recurrenceTimeframe: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurrence_timeframe'])!,
      recurrenceBasedate: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}recurrence_basedate'])!,
      recurrenceParent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_parent']),
      recurrenceChild: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_child']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
    );
  }

  @override
  $TaskModelTable createAlias(String alias) {
    return $TaskModelTable(attachedDatabase, alias);
  }
}

class TaskModelData extends DataClass implements Insertable<TaskModelData> {
  final int id;
  final String title;
  final String description;
  final int dateCreation;
  final String colorId;
  final int projectId;
  final int columnId;
  final int ownerId;
  final int position;
  final int isActive;
  final int? dateCompleted;
  final int? score;
  final int? dateDue;
  final int categoryId;
  final int creatorId;
  final int? dateModification;
  final String? reference;
  final int? dateStarted;
  final int? timeSpent;
  final int? timeEstimated;
  final int swimlaneId;
  final int dateMoved;
  final int recurrenceStatus;
  final int recurrenceTrigger;
  final int recurrenceFactor;
  final int recurrenceTimeframe;
  final int recurrenceBasedate;
  final int? recurrenceParent;
  final int? recurrenceChild;
  final int priority;
  const TaskModelData(
      {required this.id,
      required this.title,
      required this.description,
      required this.dateCreation,
      required this.colorId,
      required this.projectId,
      required this.columnId,
      required this.ownerId,
      required this.position,
      required this.isActive,
      this.dateCompleted,
      this.score,
      this.dateDue,
      required this.categoryId,
      required this.creatorId,
      this.dateModification,
      this.reference,
      this.dateStarted,
      this.timeSpent,
      this.timeEstimated,
      required this.swimlaneId,
      required this.dateMoved,
      required this.recurrenceStatus,
      required this.recurrenceTrigger,
      required this.recurrenceFactor,
      required this.recurrenceTimeframe,
      required this.recurrenceBasedate,
      this.recurrenceParent,
      this.recurrenceChild,
      required this.priority});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date_creation'] = Variable<int>(dateCreation);
    map['color_id'] = Variable<String>(colorId);
    map['project_id'] = Variable<int>(projectId);
    map['column_id'] = Variable<int>(columnId);
    map['owner_id'] = Variable<int>(ownerId);
    map['position'] = Variable<int>(position);
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || dateCompleted != null) {
      map['date_completed'] = Variable<int>(dateCompleted);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || dateDue != null) {
      map['date_due'] = Variable<int>(dateDue);
    }
    map['category_id'] = Variable<int>(categoryId);
    map['creator_id'] = Variable<int>(creatorId);
    if (!nullToAbsent || dateModification != null) {
      map['date_modification'] = Variable<int>(dateModification);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || dateStarted != null) {
      map['date_started'] = Variable<int>(dateStarted);
    }
    if (!nullToAbsent || timeSpent != null) {
      map['time_spent'] = Variable<int>(timeSpent);
    }
    if (!nullToAbsent || timeEstimated != null) {
      map['time_estimated'] = Variable<int>(timeEstimated);
    }
    map['swimlane_id'] = Variable<int>(swimlaneId);
    map['date_moved'] = Variable<int>(dateMoved);
    map['recurrence_status'] = Variable<int>(recurrenceStatus);
    map['recurrence_trigger'] = Variable<int>(recurrenceTrigger);
    map['recurrence_factor'] = Variable<int>(recurrenceFactor);
    map['recurrence_timeframe'] = Variable<int>(recurrenceTimeframe);
    map['recurrence_basedate'] = Variable<int>(recurrenceBasedate);
    if (!nullToAbsent || recurrenceParent != null) {
      map['recurrence_parent'] = Variable<int>(recurrenceParent);
    }
    if (!nullToAbsent || recurrenceChild != null) {
      map['recurrence_child'] = Variable<int>(recurrenceChild);
    }
    map['priority'] = Variable<int>(priority);
    return map;
  }

  TaskModelCompanion toCompanion(bool nullToAbsent) {
    return TaskModelCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      dateCreation: Value(dateCreation),
      colorId: Value(colorId),
      projectId: Value(projectId),
      columnId: Value(columnId),
      ownerId: Value(ownerId),
      position: Value(position),
      isActive: Value(isActive),
      dateCompleted: dateCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(dateCompleted),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      dateDue: dateDue == null && nullToAbsent
          ? const Value.absent()
          : Value(dateDue),
      categoryId: Value(categoryId),
      creatorId: Value(creatorId),
      dateModification: dateModification == null && nullToAbsent
          ? const Value.absent()
          : Value(dateModification),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      dateStarted: dateStarted == null && nullToAbsent
          ? const Value.absent()
          : Value(dateStarted),
      timeSpent: timeSpent == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSpent),
      timeEstimated: timeEstimated == null && nullToAbsent
          ? const Value.absent()
          : Value(timeEstimated),
      swimlaneId: Value(swimlaneId),
      dateMoved: Value(dateMoved),
      recurrenceStatus: Value(recurrenceStatus),
      recurrenceTrigger: Value(recurrenceTrigger),
      recurrenceFactor: Value(recurrenceFactor),
      recurrenceTimeframe: Value(recurrenceTimeframe),
      recurrenceBasedate: Value(recurrenceBasedate),
      recurrenceParent: recurrenceParent == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceParent),
      recurrenceChild: recurrenceChild == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceChild),
      priority: Value(priority),
    );
  }

  factory TaskModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskModelData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      dateCreation: serializer.fromJson<int>(json['date_creation']),
      colorId: serializer.fromJson<String>(json['color_id']),
      projectId: serializer.fromJson<int>(json['project_id']),
      columnId: serializer.fromJson<int>(json['column_id']),
      ownerId: serializer.fromJson<int>(json['owner_id']),
      position: serializer.fromJson<int>(json['position']),
      isActive: serializer.fromJson<int>(json['is_active']),
      dateCompleted: serializer.fromJson<int?>(json['date_completed']),
      score: serializer.fromJson<int?>(json['score']),
      dateDue: serializer.fromJson<int?>(json['date_due']),
      categoryId: serializer.fromJson<int>(json['category_id']),
      creatorId: serializer.fromJson<int>(json['creator_id']),
      dateModification: serializer.fromJson<int?>(json['date_modification']),
      reference: serializer.fromJson<String?>(json['reference']),
      dateStarted: serializer.fromJson<int?>(json['date_started']),
      timeSpent: serializer.fromJson<int?>(json['time_spent']),
      timeEstimated: serializer.fromJson<int?>(json['time_estimated']),
      swimlaneId: serializer.fromJson<int>(json['swimlane_id']),
      dateMoved: serializer.fromJson<int>(json['date_moved']),
      recurrenceStatus: serializer.fromJson<int>(json['recurrence_status']),
      recurrenceTrigger: serializer.fromJson<int>(json['recurrence_trigger']),
      recurrenceFactor: serializer.fromJson<int>(json['recurrence_factor']),
      recurrenceTimeframe:
          serializer.fromJson<int>(json['recurrence_timeframe']),
      recurrenceBasedate: serializer.fromJson<int>(json['recurrence_basedate']),
      recurrenceParent: serializer.fromJson<int?>(json['recurrence_parent']),
      recurrenceChild: serializer.fromJson<int?>(json['recurrence_child']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date_creation': serializer.toJson<int>(dateCreation),
      'color_id': serializer.toJson<String>(colorId),
      'project_id': serializer.toJson<int>(projectId),
      'column_id': serializer.toJson<int>(columnId),
      'owner_id': serializer.toJson<int>(ownerId),
      'position': serializer.toJson<int>(position),
      'is_active': serializer.toJson<int>(isActive),
      'date_completed': serializer.toJson<int?>(dateCompleted),
      'score': serializer.toJson<int?>(score),
      'date_due': serializer.toJson<int?>(dateDue),
      'category_id': serializer.toJson<int>(categoryId),
      'creator_id': serializer.toJson<int>(creatorId),
      'date_modification': serializer.toJson<int?>(dateModification),
      'reference': serializer.toJson<String?>(reference),
      'date_started': serializer.toJson<int?>(dateStarted),
      'time_spent': serializer.toJson<int?>(timeSpent),
      'time_estimated': serializer.toJson<int?>(timeEstimated),
      'swimlane_id': serializer.toJson<int>(swimlaneId),
      'date_moved': serializer.toJson<int>(dateMoved),
      'recurrence_status': serializer.toJson<int>(recurrenceStatus),
      'recurrence_trigger': serializer.toJson<int>(recurrenceTrigger),
      'recurrence_factor': serializer.toJson<int>(recurrenceFactor),
      'recurrence_timeframe': serializer.toJson<int>(recurrenceTimeframe),
      'recurrence_basedate': serializer.toJson<int>(recurrenceBasedate),
      'recurrence_parent': serializer.toJson<int?>(recurrenceParent),
      'recurrence_child': serializer.toJson<int?>(recurrenceChild),
      'priority': serializer.toJson<int>(priority),
    };
  }

  TaskModelData copyWith(
          {int? id,
          String? title,
          String? description,
          int? dateCreation,
          String? colorId,
          int? projectId,
          int? columnId,
          int? ownerId,
          int? position,
          int? isActive,
          Value<int?> dateCompleted = const Value.absent(),
          Value<int?> score = const Value.absent(),
          Value<int?> dateDue = const Value.absent(),
          int? categoryId,
          int? creatorId,
          Value<int?> dateModification = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          Value<int?> dateStarted = const Value.absent(),
          Value<int?> timeSpent = const Value.absent(),
          Value<int?> timeEstimated = const Value.absent(),
          int? swimlaneId,
          int? dateMoved,
          int? recurrenceStatus,
          int? recurrenceTrigger,
          int? recurrenceFactor,
          int? recurrenceTimeframe,
          int? recurrenceBasedate,
          Value<int?> recurrenceParent = const Value.absent(),
          Value<int?> recurrenceChild = const Value.absent(),
          int? priority}) =>
      TaskModelData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dateCreation: dateCreation ?? this.dateCreation,
        colorId: colorId ?? this.colorId,
        projectId: projectId ?? this.projectId,
        columnId: columnId ?? this.columnId,
        ownerId: ownerId ?? this.ownerId,
        position: position ?? this.position,
        isActive: isActive ?? this.isActive,
        dateCompleted:
            dateCompleted.present ? dateCompleted.value : this.dateCompleted,
        score: score.present ? score.value : this.score,
        dateDue: dateDue.present ? dateDue.value : this.dateDue,
        categoryId: categoryId ?? this.categoryId,
        creatorId: creatorId ?? this.creatorId,
        dateModification: dateModification.present
            ? dateModification.value
            : this.dateModification,
        reference: reference.present ? reference.value : this.reference,
        dateStarted: dateStarted.present ? dateStarted.value : this.dateStarted,
        timeSpent: timeSpent.present ? timeSpent.value : this.timeSpent,
        timeEstimated:
            timeEstimated.present ? timeEstimated.value : this.timeEstimated,
        swimlaneId: swimlaneId ?? this.swimlaneId,
        dateMoved: dateMoved ?? this.dateMoved,
        recurrenceStatus: recurrenceStatus ?? this.recurrenceStatus,
        recurrenceTrigger: recurrenceTrigger ?? this.recurrenceTrigger,
        recurrenceFactor: recurrenceFactor ?? this.recurrenceFactor,
        recurrenceTimeframe: recurrenceTimeframe ?? this.recurrenceTimeframe,
        recurrenceBasedate: recurrenceBasedate ?? this.recurrenceBasedate,
        recurrenceParent: recurrenceParent.present
            ? recurrenceParent.value
            : this.recurrenceParent,
        recurrenceChild: recurrenceChild.present
            ? recurrenceChild.value
            : this.recurrenceChild,
        priority: priority ?? this.priority,
      );
  @override
  String toString() {
    return (StringBuffer('TaskModelData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dateCreation: $dateCreation, ')
          ..write('colorId: $colorId, ')
          ..write('projectId: $projectId, ')
          ..write('columnId: $columnId, ')
          ..write('ownerId: $ownerId, ')
          ..write('position: $position, ')
          ..write('isActive: $isActive, ')
          ..write('dateCompleted: $dateCompleted, ')
          ..write('score: $score, ')
          ..write('dateDue: $dateDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('creatorId: $creatorId, ')
          ..write('dateModification: $dateModification, ')
          ..write('reference: $reference, ')
          ..write('dateStarted: $dateStarted, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('timeEstimated: $timeEstimated, ')
          ..write('swimlaneId: $swimlaneId, ')
          ..write('dateMoved: $dateMoved, ')
          ..write('recurrenceStatus: $recurrenceStatus, ')
          ..write('recurrenceTrigger: $recurrenceTrigger, ')
          ..write('recurrenceFactor: $recurrenceFactor, ')
          ..write('recurrenceTimeframe: $recurrenceTimeframe, ')
          ..write('recurrenceBasedate: $recurrenceBasedate, ')
          ..write('recurrenceParent: $recurrenceParent, ')
          ..write('recurrenceChild: $recurrenceChild, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        dateCreation,
        colorId,
        projectId,
        columnId,
        ownerId,
        position,
        isActive,
        dateCompleted,
        score,
        dateDue,
        categoryId,
        creatorId,
        dateModification,
        reference,
        dateStarted,
        timeSpent,
        timeEstimated,
        swimlaneId,
        dateMoved,
        recurrenceStatus,
        recurrenceTrigger,
        recurrenceFactor,
        recurrenceTimeframe,
        recurrenceBasedate,
        recurrenceParent,
        recurrenceChild,
        priority
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskModelData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dateCreation == this.dateCreation &&
          other.colorId == this.colorId &&
          other.projectId == this.projectId &&
          other.columnId == this.columnId &&
          other.ownerId == this.ownerId &&
          other.position == this.position &&
          other.isActive == this.isActive &&
          other.dateCompleted == this.dateCompleted &&
          other.score == this.score &&
          other.dateDue == this.dateDue &&
          other.categoryId == this.categoryId &&
          other.creatorId == this.creatorId &&
          other.dateModification == this.dateModification &&
          other.reference == this.reference &&
          other.dateStarted == this.dateStarted &&
          other.timeSpent == this.timeSpent &&
          other.timeEstimated == this.timeEstimated &&
          other.swimlaneId == this.swimlaneId &&
          other.dateMoved == this.dateMoved &&
          other.recurrenceStatus == this.recurrenceStatus &&
          other.recurrenceTrigger == this.recurrenceTrigger &&
          other.recurrenceFactor == this.recurrenceFactor &&
          other.recurrenceTimeframe == this.recurrenceTimeframe &&
          other.recurrenceBasedate == this.recurrenceBasedate &&
          other.recurrenceParent == this.recurrenceParent &&
          other.recurrenceChild == this.recurrenceChild &&
          other.priority == this.priority);
}

class TaskModelCompanion extends UpdateCompanion<TaskModelData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int> dateCreation;
  final Value<String> colorId;
  final Value<int> projectId;
  final Value<int> columnId;
  final Value<int> ownerId;
  final Value<int> position;
  final Value<int> isActive;
  final Value<int?> dateCompleted;
  final Value<int?> score;
  final Value<int?> dateDue;
  final Value<int> categoryId;
  final Value<int> creatorId;
  final Value<int?> dateModification;
  final Value<String?> reference;
  final Value<int?> dateStarted;
  final Value<int?> timeSpent;
  final Value<int?> timeEstimated;
  final Value<int> swimlaneId;
  final Value<int> dateMoved;
  final Value<int> recurrenceStatus;
  final Value<int> recurrenceTrigger;
  final Value<int> recurrenceFactor;
  final Value<int> recurrenceTimeframe;
  final Value<int> recurrenceBasedate;
  final Value<int?> recurrenceParent;
  final Value<int?> recurrenceChild;
  final Value<int> priority;
  final Value<int> rowid;
  const TaskModelCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dateCreation = const Value.absent(),
    this.colorId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.columnId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.position = const Value.absent(),
    this.isActive = const Value.absent(),
    this.dateCompleted = const Value.absent(),
    this.score = const Value.absent(),
    this.dateDue = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.dateModification = const Value.absent(),
    this.reference = const Value.absent(),
    this.dateStarted = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.timeEstimated = const Value.absent(),
    this.swimlaneId = const Value.absent(),
    this.dateMoved = const Value.absent(),
    this.recurrenceStatus = const Value.absent(),
    this.recurrenceTrigger = const Value.absent(),
    this.recurrenceFactor = const Value.absent(),
    this.recurrenceTimeframe = const Value.absent(),
    this.recurrenceBasedate = const Value.absent(),
    this.recurrenceParent = const Value.absent(),
    this.recurrenceChild = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskModelCompanion.insert({
    required int id,
    required String title,
    required String description,
    required int dateCreation,
    required String colorId,
    required int projectId,
    required int columnId,
    required int ownerId,
    required int position,
    required int isActive,
    this.dateCompleted = const Value.absent(),
    this.score = const Value.absent(),
    this.dateDue = const Value.absent(),
    required int categoryId,
    required int creatorId,
    this.dateModification = const Value.absent(),
    this.reference = const Value.absent(),
    this.dateStarted = const Value.absent(),
    this.timeSpent = const Value.absent(),
    this.timeEstimated = const Value.absent(),
    required int swimlaneId,
    required int dateMoved,
    required int recurrenceStatus,
    required int recurrenceTrigger,
    required int recurrenceFactor,
    required int recurrenceTimeframe,
    required int recurrenceBasedate,
    this.recurrenceParent = const Value.absent(),
    this.recurrenceChild = const Value.absent(),
    required int priority,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        dateCreation = Value(dateCreation),
        colorId = Value(colorId),
        projectId = Value(projectId),
        columnId = Value(columnId),
        ownerId = Value(ownerId),
        position = Value(position),
        isActive = Value(isActive),
        categoryId = Value(categoryId),
        creatorId = Value(creatorId),
        swimlaneId = Value(swimlaneId),
        dateMoved = Value(dateMoved),
        recurrenceStatus = Value(recurrenceStatus),
        recurrenceTrigger = Value(recurrenceTrigger),
        recurrenceFactor = Value(recurrenceFactor),
        recurrenceTimeframe = Value(recurrenceTimeframe),
        recurrenceBasedate = Value(recurrenceBasedate),
        priority = Value(priority);
  static Insertable<TaskModelData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? dateCreation,
    Expression<String>? colorId,
    Expression<int>? projectId,
    Expression<int>? columnId,
    Expression<int>? ownerId,
    Expression<int>? position,
    Expression<int>? isActive,
    Expression<int>? dateCompleted,
    Expression<int>? score,
    Expression<int>? dateDue,
    Expression<int>? categoryId,
    Expression<int>? creatorId,
    Expression<int>? dateModification,
    Expression<String>? reference,
    Expression<int>? dateStarted,
    Expression<int>? timeSpent,
    Expression<int>? timeEstimated,
    Expression<int>? swimlaneId,
    Expression<int>? dateMoved,
    Expression<int>? recurrenceStatus,
    Expression<int>? recurrenceTrigger,
    Expression<int>? recurrenceFactor,
    Expression<int>? recurrenceTimeframe,
    Expression<int>? recurrenceBasedate,
    Expression<int>? recurrenceParent,
    Expression<int>? recurrenceChild,
    Expression<int>? priority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dateCreation != null) 'date_creation': dateCreation,
      if (colorId != null) 'color_id': colorId,
      if (projectId != null) 'project_id': projectId,
      if (columnId != null) 'column_id': columnId,
      if (ownerId != null) 'owner_id': ownerId,
      if (position != null) 'position': position,
      if (isActive != null) 'is_active': isActive,
      if (dateCompleted != null) 'date_completed': dateCompleted,
      if (score != null) 'score': score,
      if (dateDue != null) 'date_due': dateDue,
      if (categoryId != null) 'category_id': categoryId,
      if (creatorId != null) 'creator_id': creatorId,
      if (dateModification != null) 'date_modification': dateModification,
      if (reference != null) 'reference': reference,
      if (dateStarted != null) 'date_started': dateStarted,
      if (timeSpent != null) 'time_spent': timeSpent,
      if (timeEstimated != null) 'time_estimated': timeEstimated,
      if (swimlaneId != null) 'swimlane_id': swimlaneId,
      if (dateMoved != null) 'date_moved': dateMoved,
      if (recurrenceStatus != null) 'recurrence_status': recurrenceStatus,
      if (recurrenceTrigger != null) 'recurrence_trigger': recurrenceTrigger,
      if (recurrenceFactor != null) 'recurrence_factor': recurrenceFactor,
      if (recurrenceTimeframe != null)
        'recurrence_timeframe': recurrenceTimeframe,
      if (recurrenceBasedate != null) 'recurrence_basedate': recurrenceBasedate,
      if (recurrenceParent != null) 'recurrence_parent': recurrenceParent,
      if (recurrenceChild != null) 'recurrence_child': recurrenceChild,
      if (priority != null) 'priority': priority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskModelCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<int>? dateCreation,
      Value<String>? colorId,
      Value<int>? projectId,
      Value<int>? columnId,
      Value<int>? ownerId,
      Value<int>? position,
      Value<int>? isActive,
      Value<int?>? dateCompleted,
      Value<int?>? score,
      Value<int?>? dateDue,
      Value<int>? categoryId,
      Value<int>? creatorId,
      Value<int?>? dateModification,
      Value<String?>? reference,
      Value<int?>? dateStarted,
      Value<int?>? timeSpent,
      Value<int?>? timeEstimated,
      Value<int>? swimlaneId,
      Value<int>? dateMoved,
      Value<int>? recurrenceStatus,
      Value<int>? recurrenceTrigger,
      Value<int>? recurrenceFactor,
      Value<int>? recurrenceTimeframe,
      Value<int>? recurrenceBasedate,
      Value<int?>? recurrenceParent,
      Value<int?>? recurrenceChild,
      Value<int>? priority,
      Value<int>? rowid}) {
    return TaskModelCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateCreation: dateCreation ?? this.dateCreation,
      colorId: colorId ?? this.colorId,
      projectId: projectId ?? this.projectId,
      columnId: columnId ?? this.columnId,
      ownerId: ownerId ?? this.ownerId,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      score: score ?? this.score,
      dateDue: dateDue ?? this.dateDue,
      categoryId: categoryId ?? this.categoryId,
      creatorId: creatorId ?? this.creatorId,
      dateModification: dateModification ?? this.dateModification,
      reference: reference ?? this.reference,
      dateStarted: dateStarted ?? this.dateStarted,
      timeSpent: timeSpent ?? this.timeSpent,
      timeEstimated: timeEstimated ?? this.timeEstimated,
      swimlaneId: swimlaneId ?? this.swimlaneId,
      dateMoved: dateMoved ?? this.dateMoved,
      recurrenceStatus: recurrenceStatus ?? this.recurrenceStatus,
      recurrenceTrigger: recurrenceTrigger ?? this.recurrenceTrigger,
      recurrenceFactor: recurrenceFactor ?? this.recurrenceFactor,
      recurrenceTimeframe: recurrenceTimeframe ?? this.recurrenceTimeframe,
      recurrenceBasedate: recurrenceBasedate ?? this.recurrenceBasedate,
      recurrenceParent: recurrenceParent ?? this.recurrenceParent,
      recurrenceChild: recurrenceChild ?? this.recurrenceChild,
      priority: priority ?? this.priority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<int>(dateCreation.value);
    }
    if (colorId.present) {
      map['color_id'] = Variable<String>(colorId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (columnId.present) {
      map['column_id'] = Variable<int>(columnId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (dateCompleted.present) {
      map['date_completed'] = Variable<int>(dateCompleted.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (dateDue.present) {
      map['date_due'] = Variable<int>(dateDue.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<int>(creatorId.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<int>(dateModification.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (dateStarted.present) {
      map['date_started'] = Variable<int>(dateStarted.value);
    }
    if (timeSpent.present) {
      map['time_spent'] = Variable<int>(timeSpent.value);
    }
    if (timeEstimated.present) {
      map['time_estimated'] = Variable<int>(timeEstimated.value);
    }
    if (swimlaneId.present) {
      map['swimlane_id'] = Variable<int>(swimlaneId.value);
    }
    if (dateMoved.present) {
      map['date_moved'] = Variable<int>(dateMoved.value);
    }
    if (recurrenceStatus.present) {
      map['recurrence_status'] = Variable<int>(recurrenceStatus.value);
    }
    if (recurrenceTrigger.present) {
      map['recurrence_trigger'] = Variable<int>(recurrenceTrigger.value);
    }
    if (recurrenceFactor.present) {
      map['recurrence_factor'] = Variable<int>(recurrenceFactor.value);
    }
    if (recurrenceTimeframe.present) {
      map['recurrence_timeframe'] = Variable<int>(recurrenceTimeframe.value);
    }
    if (recurrenceBasedate.present) {
      map['recurrence_basedate'] = Variable<int>(recurrenceBasedate.value);
    }
    if (recurrenceParent.present) {
      map['recurrence_parent'] = Variable<int>(recurrenceParent.value);
    }
    if (recurrenceChild.present) {
      map['recurrence_child'] = Variable<int>(recurrenceChild.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskModelCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dateCreation: $dateCreation, ')
          ..write('colorId: $colorId, ')
          ..write('projectId: $projectId, ')
          ..write('columnId: $columnId, ')
          ..write('ownerId: $ownerId, ')
          ..write('position: $position, ')
          ..write('isActive: $isActive, ')
          ..write('dateCompleted: $dateCompleted, ')
          ..write('score: $score, ')
          ..write('dateDue: $dateDue, ')
          ..write('categoryId: $categoryId, ')
          ..write('creatorId: $creatorId, ')
          ..write('dateModification: $dateModification, ')
          ..write('reference: $reference, ')
          ..write('dateStarted: $dateStarted, ')
          ..write('timeSpent: $timeSpent, ')
          ..write('timeEstimated: $timeEstimated, ')
          ..write('swimlaneId: $swimlaneId, ')
          ..write('dateMoved: $dateMoved, ')
          ..write('recurrenceStatus: $recurrenceStatus, ')
          ..write('recurrenceTrigger: $recurrenceTrigger, ')
          ..write('recurrenceFactor: $recurrenceFactor, ')
          ..write('recurrenceTimeframe: $recurrenceTimeframe, ')
          ..write('recurrenceBasedate: $recurrenceBasedate, ')
          ..write('recurrenceParent: $recurrenceParent, ')
          ..write('recurrenceChild: $recurrenceChild, ')
          ..write('priority: $priority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskMetadataModelTable extends TaskMetadataModel
    with TableInfo<$TaskMetadataModelTable, TaskMetadataModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskMetadataModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
      'task_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES task_model (id)'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumnWithTypeConverter<TaskMetadata?, String> metadata =
      GeneratedColumn<String>('metadata', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<TaskMetadata?>(
              $TaskMetadataModelTable.$convertermetadatan);
  @override
  List<GeneratedColumn> get $columns => [taskId, metadata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_metadata_model';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaskMetadataModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    context.handle(_metadataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  TaskMetadataModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskMetadataModelData(
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_id']),
      metadata: $TaskMetadataModelTable.$convertermetadatan.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}metadata'])),
    );
  }

  @override
  $TaskMetadataModelTable createAlias(String alias) {
    return $TaskMetadataModelTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskMetadata, String, String> $convertermetadata =
      const TaskMetadataConverter();
  static JsonTypeConverter2<TaskMetadata?, String?, String?>
      $convertermetadatan = JsonTypeConverter2.asNullable($convertermetadata);
}

class TaskMetadataModelData extends DataClass
    implements Insertable<TaskMetadataModelData> {
  final int? taskId;
  final TaskMetadata? metadata;
  const TaskMetadataModelData({this.taskId, this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(
          $TaskMetadataModelTable.$convertermetadatan.toSql(metadata));
    }
    return map;
  }

  TaskMetadataModelCompanion toCompanion(bool nullToAbsent) {
    return TaskMetadataModelCompanion(
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory TaskMetadataModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskMetadataModelData(
      taskId: serializer.fromJson<int?>(json['task_id']),
      metadata: $TaskMetadataModelTable.$convertermetadatan
          .fromJson(serializer.fromJson<String?>(json['metadata'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'task_id': serializer.toJson<int?>(taskId),
      'metadata': serializer.toJson<String?>(
          $TaskMetadataModelTable.$convertermetadatan.toJson(metadata)),
    };
  }

  TaskMetadataModelData copyWith(
          {Value<int?> taskId = const Value.absent(),
          Value<TaskMetadata?> metadata = const Value.absent()}) =>
      TaskMetadataModelData(
        taskId: taskId.present ? taskId.value : this.taskId,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  @override
  String toString() {
    return (StringBuffer('TaskMetadataModelData(')
          ..write('taskId: $taskId, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskMetadataModelData &&
          other.taskId == this.taskId &&
          other.metadata == this.metadata);
}

class TaskMetadataModelCompanion
    extends UpdateCompanion<TaskMetadataModelData> {
  final Value<int?> taskId;
  final Value<TaskMetadata?> metadata;
  const TaskMetadataModelCompanion({
    this.taskId = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  TaskMetadataModelCompanion.insert({
    this.taskId = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  static Insertable<TaskMetadataModelData> custom({
    Expression<int>? taskId,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (metadata != null) 'metadata': metadata,
    });
  }

  TaskMetadataModelCompanion copyWith(
      {Value<int?>? taskId, Value<TaskMetadata?>? metadata}) {
    return TaskMetadataModelCompanion(
      taskId: taskId ?? this.taskId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $TaskMetadataModelTable.$convertermetadatan.toSql(metadata.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskMetadataModelCompanion(')
          ..write('taskId: $taskId, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ProjectModelTable projectModel = $ProjectModelTable(this);
  late final $ColumnModelTable columnModel = $ColumnModelTable(this);
  late final $CommentModelTable commentModel = $CommentModelTable(this);
  late final $SubtaskModelTable subtaskModel = $SubtaskModelTable(this);
  late final $TaskModelTable taskModel = $TaskModelTable(this);
  late final $TaskMetadataModelTable taskMetadataModel =
      $TaskMetadataModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        projectModel,
        columnModel,
        commentModel,
        subtaskModel,
        taskModel,
        taskMetadataModel
      ];
}
