import 'dart:async';
import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:data/data.dart';
import 'package:data/models/quiz_session.dart';
import 'package:data/models/serializers.dart';
import 'package:data/models/class_students.dart';
import 'package:data/models/student.dart';
import 'package:data/models/user_profile.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/jamaica/models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

class StateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;

  const StateContainer({Key key, this.state, this.child}) : super(key: key);

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  AppState state;
//  Nearby _nearBy = Nearby.instance;
  List<dynamic> messages = [];
  String studentIdVal;
  List<Performance> overView = [];

  var quizSessionEndPointId;

  QuizUpdate quizUpdate;
  QuizSession quizSession;
  UserProfile userProfileDeatils;
  ClassStudents classStudents;
  String teacherEndPointId;
  Map<dynamic, List<dynamic>> messagesById = new Map<dynamic, List<dynamic>>();
  List<dynamic> connections = [];

  List<dynamic> activeConnections = [];

  /// State
  StreamSubscription _stateSubscription;
  String thisState = "unknown";

  /// Discovering
  StreamSubscription _discoverySubscription;
  List<dynamic> advertisers = [];
  List<dynamic> removedAdvertisersInSession = [];
  bool isDiscovering = false;

  bool isTeacherMode = false;

  /// Advertising
  StreamSubscription _advertisingSubscription;
  bool isAdvertising = false;

  // Connection
  StreamSubscription _endPointUnknownSubscription;
  StreamSubscription _endPointNotificationSubscription;
  StreamSubscription _connectionSubscription;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    state = widget.state ?? AppState.loading();
    initialize();
    discovering();
  }

  void discovering() async {
    await startDiscovery();
    print("firtst   $advertisers");
  }

  initialize() async {
    // Initialize Handlers
//    await SimplePermissions.requestPermission(Permission.AccessCoarseLocation);
//    _nearBy.initializeMessageHandlers((Map<dynamic, dynamic> message) async {
//      onReceiveMessage(message);
//    });
    // Immediately get the state of Nearby
//    _nearBy.state.then((s) {
//      setState(() {
//        thisState = s;
//        _log(thisState);
//      });
//    });
//     Subscribe to state changes
//    _stateSubscription = _nearBy.onStateChanged().listen((s) {
//      setState(() {
//        thisState = s;
//        _log("onStateChanged:" + thisState);
//      });
//    });

//    _endPointUnknownSubscription = _nearBy.onEndPointUnknown().listen((s) {
//      _log('onEndPointUnknown: $s');
//      // show pop up to ask user to go back to discovery screen
//    });
  }

  @override
  void dispose() {
//    _stateSubscription?.cancel();
//    _stateSubscription = null;
//    _discoverySubscription?.cancel();
//    _discoverySubscription = null;
//    _connectionSubscription?.cancel();
//    _connectionSubscription = null;
//    _endPointNotificationSubscription?.cancel();
//    _endPointNotificationSubscription = null;
    super.dispose();
  }

  onEndPointNotification(Function _navigateToScreen) async {
//    _endPointNotificationSubscription =
//        _nearBy.onEndPointNotification().listen((s) {
//      if (s != null && s['onEndpointDisconnected'] != null) {
//        onEndpointDisconnected(s);
//      } else if (s != null && s['onEndpointConnected'] != null) {
//        onEndpointConnected(s, _navigateToScreen);
//      }
//    });
  }

  updateTeacherMode(isTeacher) {
    setState(() {
      isTeacherMode = isTeacher;
    });
  }

  onEndpointDisconnected(s) async {
    await getConnections();
    setState(() {
      if (!isTeacherMode) {
        removedAdvertisersInSession.add(s);
        advertisers.removeWhere((i) =>
            i['endPointId'] == s['onEndpointDisconnected']['endPointId']);
      }
      messages.clear();
      messagesById.remove(
          (i) => i['endPointId'] == s['onEndpointDisconnected']['endPointId']);
    });
  }

  onEndpointConnected(s, _navigateToScreen) async {
    setState(() {
      _navigateToScreen();
    });
  }

  startDiscovery() async {
//    advertisers = [];
//    _discoverySubscription = _nearBy
//        .startDiscovery(
//      timeout: const Duration(seconds: 300),
//    )
//        .listen((discoveryResult) {
//      _log('discoveryResult: $discoveryResult');
//      setState(() {
//        advertisers.add(discoveryResult);
//        print('adding to list $discoveryResult');
//      });
//    }, onDone: stopDiscovery);
//
//    setState(() {
//      isDiscovering = true;
//    });
  }

  stopDiscovery() {
//    _discoverySubscription?.cancel();
//    _discoverySubscription = null;
//    _nearBy.stopDiscovery();
//    setState(() {
//      isDiscovering = false;
//    });
  }

  startAdvertising(Map<String, String> options) {
//    if (!isAdvertising) {
//      _advertisingSubscription = _nearBy
//          .startAdvertising(
//            options,
//            timeout: const Duration(seconds: 6000),
//          )
//          .listen((result) {}, onDone: stopAdvertising);
//
//      setState(() {
//        isAdvertising = true;
//      });
//    }
  }

  stopAdvertising() {
//    _advertisingSubscription?.cancel();
//    _advertisingSubscription = null;
//    _nearBy.stopAdvertise();
//    setState(() {
//      isAdvertising = false;
//    });
  }

  disconnectFromDevice(String endPointId) async {
//    final Map<String, String> connectionInfo = <String, String>{
//      'endPointId': endPointId
//    };
//
//    await _nearBy.disconnectFromDevice(connectionInfo);
//    final modifiedConnections = await _nearBy.connections;
//    setState(() {
//      connections = modifiedConnections;
//    });
  }

  connectTo(Map<dynamic, dynamic> connectionInfo) async {
    // Connect to device
//    _connectionSubscription =
//        _nearBy.connectTo(connectionInfo).listen((result) async {
//      stopDiscovery();
//      setState(() {
//        isConnected = result;
//        _log('connection Result: $isConnected');
//      });
//    }, onDone: stopConnection);
  }

  disconnect() async {
//    stopConnection();
//    _log('disconnect ...');
//    setState(() {
//      if (advertisers.length > 0) {
//        _log('remove all advertisers ...');
//        advertisers.removeRange(0, advertisers.length - 1);
//        advertisers = [];
//      }
//
//      print('disconnect messges $messages');
//      if (messages.length > 0) {
//        _log('remove all messages ...');
//        messages.clear();
//      }
//      //clear all messages
//      messagesById.clear();
//    });
//    await _nearBy.disconnect();
  }

  stopConnection() {
//    try {
//      _connectionSubscription?.cancel();
//      _connectionSubscription = null;
//      setState(() {
//        isConnected = false;
//        _log('stopConnection ... $isConnected');
//      });
//    } catch (e) {
//      setState(() {
//        _connectionSubscription = null;
//        isConnected = false;
//        _log('stopConnection ... $isConnected');
//      });
//    }
  }

  sendMessageTo(String endPointId, String textMessage) async {
//    final Map<String, String> textMessageMap = <String, String>{
//      'endPointId': endPointId,
//      'message': textMessage
//    };
//
//    var sentSuccessfully = await _nearBy.sendMessageTo(textMessageMap);
//    _log('message $textMessage sent: $sentSuccessfully');
  }

  sendMessage(String textMessage) async {
//    final Map<String, String> textMessageMap = <String, String>{
//      'message': textMessage
//    };
//
//    var sentSuccessfully = await _nearBy.sendMessage(textMessageMap);
//    _log('message $textMessage sent: $sentSuccessfully');
  }

  void _log(String message) {
    print("NearbyApp: -------> " + message);
  }

  void onReceiveMessage(Map<dynamic, dynamic> message) async {
//    messages.add(message);
//    final standardSerializers =
//        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
//    final newJson = jsonDecode(message['textMessages']['message']);
//    var values = newJson.keys;
//    String key = values.first;
//    switch (newJson[key]) {
//      case 'QuizSession':
//        quizSessionEndPointId = message['textMessages']['endPointId'];
//
//        quizSession = standardSerializers.deserialize(newJson);
//        break;
//      case 'QuizUpdate':
//        final sessionId = newJson['sessionId'];
//        if (quizSession.sessionId == sessionId) {
//          quizUpdate = standardSerializers.deserialize(newJson);
//        }
//        break;
//      case 'ClassStudents':
//        teacherEndPointId = message['textMessages']['endPointId'];
//        classStudents = standardSerializers.deserialize(newJson);
//        break;
//      case 'UserProfile':
//        userProfileDeatils = standardSerializers.deserialize(newJson);
//        break;
//      default:
//    }
  }

  Future<void> getConnections() async {
//    List<dynamic> connections = await _nearBy.connections;
//    setState(() => this.connections = connections);
//    print('got connections : $connections');
  }

  student(String studentId) async {
//    studentIdVal = studentId;
  }

  selfSignUp(String grade, String id, String name, String image) async {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    Student student = Student((b) => b
      ..name = name
      ..id = id
      ..grade = grade
      ..photo = image);
    final studentJson = standardSerializers.serialize(student);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$id', json.encode(studentJson));
  }

  studentJoin(String studentid, String sessionId, String teacherId) async {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    await student(studentid);
    ClassJoin classJoin = ClassJoin((b) => b
      ..studentId = studentid
      ..sessionId = classStudents.sessionId);
    final classJoinJson = standardSerializers.serialize(classJoin);
    final classJoinJsonString = jsonEncode(classJoinJson);
    print(classJoinJsonString);
    sendMessageTo(teacherId, classJoinJsonString);
  }

  addPerformanceData(Performance data) {
//    overView.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void setAccessories(BuiltMap<String, String> accessories) {
    setState(() {
      state = AppState((s) => s
        ..userProfile.accessories = accessories
        ..isLoading = state.isLoading);
    });
  }

  void setCurrentTheme(String t) {
    state = AppState((s) => s
      ..userProfile.currentTheme = t
      ..isLoading = state.isLoading);
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // Note: we could get fancy here and compare whether the old AppState is
  // different than the current AppState. However, since we know this is the
  // root Widget, when we make changes we also know we want to rebuild Widgets
  // that depend on the StateContainer.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
