// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JokeModel _$JokeModelFromJson(Map<String, dynamic> json) {
  return _JokeModel.fromJson(json);
}

/// @nodoc
mixin _$JokeModel {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get setup => throw _privateConstructorUsedError;
  String get punchline => throw _privateConstructorUsedError;

  /// Serializes this JokeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JokeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JokeModelCopyWith<JokeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokeModelCopyWith<$Res> {
  factory $JokeModelCopyWith(JokeModel value, $Res Function(JokeModel) then) =
      _$JokeModelCopyWithImpl<$Res, JokeModel>;
  @useResult
  $Res call({int id, String type, String setup, String punchline});
}

/// @nodoc
class _$JokeModelCopyWithImpl<$Res, $Val extends JokeModel>
    implements $JokeModelCopyWith<$Res> {
  _$JokeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JokeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? setup = null,
    Object? punchline = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            setup: null == setup
                ? _value.setup
                : setup // ignore: cast_nullable_to_non_nullable
                      as String,
            punchline: null == punchline
                ? _value.punchline
                : punchline // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JokeModelImplCopyWith<$Res>
    implements $JokeModelCopyWith<$Res> {
  factory _$$JokeModelImplCopyWith(
    _$JokeModelImpl value,
    $Res Function(_$JokeModelImpl) then,
  ) = __$$JokeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String type, String setup, String punchline});
}

/// @nodoc
class __$$JokeModelImplCopyWithImpl<$Res>
    extends _$JokeModelCopyWithImpl<$Res, _$JokeModelImpl>
    implements _$$JokeModelImplCopyWith<$Res> {
  __$$JokeModelImplCopyWithImpl(
    _$JokeModelImpl _value,
    $Res Function(_$JokeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JokeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? setup = null,
    Object? punchline = null,
  }) {
    return _then(
      _$JokeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        setup: null == setup
            ? _value.setup
            : setup // ignore: cast_nullable_to_non_nullable
                  as String,
        punchline: null == punchline
            ? _value.punchline
            : punchline // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JokeModelImpl extends _JokeModel {
  const _$JokeModelImpl({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  }) : super._();

  factory _$JokeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JokeModelImplFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String setup;
  @override
  final String punchline;

  @override
  String toString() {
    return 'JokeModel(id: $id, type: $type, setup: $setup, punchline: $punchline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JokeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.setup, setup) || other.setup == setup) &&
            (identical(other.punchline, punchline) ||
                other.punchline == punchline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, setup, punchline);

  /// Create a copy of JokeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JokeModelImplCopyWith<_$JokeModelImpl> get copyWith =>
      __$$JokeModelImplCopyWithImpl<_$JokeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JokeModelImplToJson(this);
  }
}

abstract class _JokeModel extends JokeModel {
  const factory _JokeModel({
    required final int id,
    required final String type,
    required final String setup,
    required final String punchline,
  }) = _$JokeModelImpl;
  const _JokeModel._() : super._();

  factory _JokeModel.fromJson(Map<String, dynamic> json) =
      _$JokeModelImpl.fromJson;

  @override
  int get id;
  @override
  String get type;
  @override
  String get setup;
  @override
  String get punchline;

  /// Create a copy of JokeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JokeModelImplCopyWith<_$JokeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
