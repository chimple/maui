// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_config.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StoryConfig> _$storyConfigSerializer = new _$StoryConfigSerializer();
Serializer<Page> _$pageSerializer = new _$PageSerializer();
Serializer<ImageItemDetail> _$imageItemDetailSerializer =
    new _$ImageItemDetailSerializer();
Serializer<Stories> _$storiesSerializer = new _$StoriesSerializer();

class _$StoryConfigSerializer implements StructuredSerializer<StoryConfig> {
  @override
  final Iterable<Type> types = const [StoryConfig, _$StoryConfig];
  @override
  final String wireName = 'StoryConfig';

  @override
  Iterable serialize(Serializers serializers, StoryConfig object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'storyId',
      serializers.serialize(object.storyId,
          specifiedType: const FullType(String)),
      'coverImagePath',
      serializers.serialize(object.coverImagePath,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'pages',
      serializers.serialize(object.pages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Page)])),
    ];

    return result;
  }

  @override
  StoryConfig deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StoryConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'storyId':
          result.storyId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'coverImagePath':
          result.coverImagePath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'pages':
          result.pages.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Page)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$PageSerializer implements StructuredSerializer<Page> {
  @override
  final Iterable<Type> types = const [Page, _$Page];
  @override
  final String wireName = 'Page';

  @override
  Iterable serialize(Serializers serializers, Page object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'pageNumber',
      serializers.serialize(object.pageNumber,
          specifiedType: const FullType(String)),
      'imagePath',
      serializers.serialize(object.imagePath,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'audioPath',
      serializers.serialize(object.audioPath,
          specifiedType: const FullType(String)),
      'imageitemDetails',
      serializers.serialize(object.imageitemDetails,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ImageItemDetail)])),
    ];

    return result;
  }

  @override
  Page deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'pageNumber':
          result.pageNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imagePath':
          result.imagePath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'audioPath':
          result.audioPath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imageitemDetails':
          result.imageitemDetails.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ImageItemDetail)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ImageItemDetailSerializer
    implements StructuredSerializer<ImageItemDetail> {
  @override
  final Iterable<Type> types = const [ImageItemDetail, _$ImageItemDetail];
  @override
  final String wireName = 'ImageItemDetail';

  @override
  Iterable serialize(Serializers serializers, ImageItemDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'itemName',
      serializers.serialize(object.itemName,
          specifiedType: const FullType(String)),
      'x',
      serializers.serialize(object.x, specifiedType: const FullType(String)),
      'y',
      serializers.serialize(object.y, specifiedType: const FullType(String)),
      'height',
      serializers.serialize(object.height,
          specifiedType: const FullType(String)),
      'width',
      serializers.serialize(object.width,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ImageItemDetail deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImageItemDetailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'itemName':
          result.itemName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'x':
          result.x = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'y':
          result.y = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$StoriesSerializer implements StructuredSerializer<Stories> {
  @override
  final Iterable<Type> types = const [Stories, _$Stories];
  @override
  final String wireName = 'Stories';

  @override
  Iterable serialize(Serializers serializers, Stories object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'stories',
      serializers.serialize(object.stories,
          specifiedType:
              const FullType(BuiltList, const [const FullType(StoryConfig)])),
    ];

    return result;
  }

  @override
  Stories deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StoriesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'stories':
          result.stories.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(StoryConfig)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$StoryConfig extends StoryConfig {
  @override
  final String storyId;
  @override
  final String coverImagePath;
  @override
  final String title;
  @override
  final BuiltList<Page> pages;

  factory _$StoryConfig([void Function(StoryConfigBuilder) updates]) =>
      (new StoryConfigBuilder()..update(updates)).build();

  _$StoryConfig._({this.storyId, this.coverImagePath, this.title, this.pages})
      : super._() {
    if (storyId == null) {
      throw new BuiltValueNullFieldError('StoryConfig', 'storyId');
    }
    if (coverImagePath == null) {
      throw new BuiltValueNullFieldError('StoryConfig', 'coverImagePath');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('StoryConfig', 'title');
    }
    if (pages == null) {
      throw new BuiltValueNullFieldError('StoryConfig', 'pages');
    }
  }

  @override
  StoryConfig rebuild(void Function(StoryConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoryConfigBuilder toBuilder() => new StoryConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoryConfig &&
        storyId == other.storyId &&
        coverImagePath == other.coverImagePath &&
        title == other.title &&
        pages == other.pages;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, storyId.hashCode), coverImagePath.hashCode),
            title.hashCode),
        pages.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StoryConfig')
          ..add('storyId', storyId)
          ..add('coverImagePath', coverImagePath)
          ..add('title', title)
          ..add('pages', pages))
        .toString();
  }
}

class StoryConfigBuilder implements Builder<StoryConfig, StoryConfigBuilder> {
  _$StoryConfig _$v;

  String _storyId;
  String get storyId => _$this._storyId;
  set storyId(String storyId) => _$this._storyId = storyId;

  String _coverImagePath;
  String get coverImagePath => _$this._coverImagePath;
  set coverImagePath(String coverImagePath) =>
      _$this._coverImagePath = coverImagePath;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  ListBuilder<Page> _pages;
  ListBuilder<Page> get pages => _$this._pages ??= new ListBuilder<Page>();
  set pages(ListBuilder<Page> pages) => _$this._pages = pages;

  StoryConfigBuilder();

  StoryConfigBuilder get _$this {
    if (_$v != null) {
      _storyId = _$v.storyId;
      _coverImagePath = _$v.coverImagePath;
      _title = _$v.title;
      _pages = _$v.pages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoryConfig other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StoryConfig;
  }

  @override
  void update(void Function(StoryConfigBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StoryConfig build() {
    _$StoryConfig _$result;
    try {
      _$result = _$v ??
          new _$StoryConfig._(
              storyId: storyId,
              coverImagePath: coverImagePath,
              title: title,
              pages: pages.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'pages';
        pages.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'StoryConfig', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Page extends Page {
  @override
  final String pageNumber;
  @override
  final String imagePath;
  @override
  final String text;
  @override
  final String audioPath;
  @override
  final BuiltList<ImageItemDetail> imageitemDetails;

  factory _$Page([void Function(PageBuilder) updates]) =>
      (new PageBuilder()..update(updates)).build();

  _$Page._(
      {this.pageNumber,
      this.imagePath,
      this.text,
      this.audioPath,
      this.imageitemDetails})
      : super._() {
    if (pageNumber == null) {
      throw new BuiltValueNullFieldError('Page', 'pageNumber');
    }
    if (imagePath == null) {
      throw new BuiltValueNullFieldError('Page', 'imagePath');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('Page', 'text');
    }
    if (audioPath == null) {
      throw new BuiltValueNullFieldError('Page', 'audioPath');
    }
    if (imageitemDetails == null) {
      throw new BuiltValueNullFieldError('Page', 'imageitemDetails');
    }
  }

  @override
  Page rebuild(void Function(PageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageBuilder toBuilder() => new PageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Page &&
        pageNumber == other.pageNumber &&
        imagePath == other.imagePath &&
        text == other.text &&
        audioPath == other.audioPath &&
        imageitemDetails == other.imageitemDetails;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, pageNumber.hashCode), imagePath.hashCode),
                text.hashCode),
            audioPath.hashCode),
        imageitemDetails.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Page')
          ..add('pageNumber', pageNumber)
          ..add('imagePath', imagePath)
          ..add('text', text)
          ..add('audioPath', audioPath)
          ..add('imageitemDetails', imageitemDetails))
        .toString();
  }
}

class PageBuilder implements Builder<Page, PageBuilder> {
  _$Page _$v;

  String _pageNumber;
  String get pageNumber => _$this._pageNumber;
  set pageNumber(String pageNumber) => _$this._pageNumber = pageNumber;

  String _imagePath;
  String get imagePath => _$this._imagePath;
  set imagePath(String imagePath) => _$this._imagePath = imagePath;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  String _audioPath;
  String get audioPath => _$this._audioPath;
  set audioPath(String audioPath) => _$this._audioPath = audioPath;

  ListBuilder<ImageItemDetail> _imageitemDetails;
  ListBuilder<ImageItemDetail> get imageitemDetails =>
      _$this._imageitemDetails ??= new ListBuilder<ImageItemDetail>();
  set imageitemDetails(ListBuilder<ImageItemDetail> imageitemDetails) =>
      _$this._imageitemDetails = imageitemDetails;

  PageBuilder();

  PageBuilder get _$this {
    if (_$v != null) {
      _pageNumber = _$v.pageNumber;
      _imagePath = _$v.imagePath;
      _text = _$v.text;
      _audioPath = _$v.audioPath;
      _imageitemDetails = _$v.imageitemDetails?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Page other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Page;
  }

  @override
  void update(void Function(PageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Page build() {
    _$Page _$result;
    try {
      _$result = _$v ??
          new _$Page._(
              pageNumber: pageNumber,
              imagePath: imagePath,
              text: text,
              audioPath: audioPath,
              imageitemDetails: imageitemDetails.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'imageitemDetails';
        imageitemDetails.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Page', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ImageItemDetail extends ImageItemDetail {
  @override
  final String itemName;
  @override
  final String x;
  @override
  final String y;
  @override
  final String height;
  @override
  final String width;

  factory _$ImageItemDetail([void Function(ImageItemDetailBuilder) updates]) =>
      (new ImageItemDetailBuilder()..update(updates)).build();

  _$ImageItemDetail._({this.itemName, this.x, this.y, this.height, this.width})
      : super._() {
    if (itemName == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'itemName');
    }
    if (x == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'x');
    }
    if (y == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'y');
    }
    if (height == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'height');
    }
    if (width == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'width');
    }
  }

  @override
  ImageItemDetail rebuild(void Function(ImageItemDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageItemDetailBuilder toBuilder() =>
      new ImageItemDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageItemDetail &&
        itemName == other.itemName &&
        x == other.x &&
        y == other.y &&
        height == other.height &&
        width == other.width;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, itemName.hashCode), x.hashCode), y.hashCode),
            height.hashCode),
        width.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImageItemDetail')
          ..add('itemName', itemName)
          ..add('x', x)
          ..add('y', y)
          ..add('height', height)
          ..add('width', width))
        .toString();
  }
}

class ImageItemDetailBuilder
    implements Builder<ImageItemDetail, ImageItemDetailBuilder> {
  _$ImageItemDetail _$v;

  String _itemName;
  String get itemName => _$this._itemName;
  set itemName(String itemName) => _$this._itemName = itemName;

  String _x;
  String get x => _$this._x;
  set x(String x) => _$this._x = x;

  String _y;
  String get y => _$this._y;
  set y(String y) => _$this._y = y;

  String _height;
  String get height => _$this._height;
  set height(String height) => _$this._height = height;

  String _width;
  String get width => _$this._width;
  set width(String width) => _$this._width = width;

  ImageItemDetailBuilder();

  ImageItemDetailBuilder get _$this {
    if (_$v != null) {
      _itemName = _$v.itemName;
      _x = _$v.x;
      _y = _$v.y;
      _height = _$v.height;
      _width = _$v.width;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageItemDetail other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImageItemDetail;
  }

  @override
  void update(void Function(ImageItemDetailBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImageItemDetail build() {
    final _$result = _$v ??
        new _$ImageItemDetail._(
            itemName: itemName, x: x, y: y, height: height, width: width);
    replace(_$result);
    return _$result;
  }
}

class _$Stories extends Stories {
  @override
  final BuiltList<StoryConfig> stories;

  factory _$Stories([void Function(StoriesBuilder) updates]) =>
      (new StoriesBuilder()..update(updates)).build();

  _$Stories._({this.stories}) : super._() {
    if (stories == null) {
      throw new BuiltValueNullFieldError('Stories', 'stories');
    }
  }

  @override
  Stories rebuild(void Function(StoriesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoriesBuilder toBuilder() => new StoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stories && stories == other.stories;
  }

  @override
  int get hashCode {
    return $jf($jc(0, stories.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Stories')..add('stories', stories))
        .toString();
  }
}

class StoriesBuilder implements Builder<Stories, StoriesBuilder> {
  _$Stories _$v;

  ListBuilder<StoryConfig> _stories;
  ListBuilder<StoryConfig> get stories =>
      _$this._stories ??= new ListBuilder<StoryConfig>();
  set stories(ListBuilder<StoryConfig> stories) => _$this._stories = stories;

  StoriesBuilder();

  StoriesBuilder get _$this {
    if (_$v != null) {
      _stories = _$v.stories?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Stories other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Stories;
  }

  @override
  void update(void Function(StoriesBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Stories build() {
    _$Stories _$result;
    try {
      _$result = _$v ?? new _$Stories._(stories: stories.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'stories';
        stories.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Stories', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
