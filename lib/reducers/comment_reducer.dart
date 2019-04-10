import 'package:maui/actions/comment_actions.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:redux/redux.dart';

final commentReducer = combineReducers<Map<String, List<Comment>>>([
  TypedReducer<Map<String, List<Comment>>, AddCommentAction>(_addComment),
  TypedReducer<Map<String, List<Comment>>, CommentsLoadedAction>(
      _setLoadedComments),
  TypedReducer<Map<String, List<Comment>>, CommentsNotLoadedAction>(
      _setNoComments),
]);

Map<String, List<Comment>> _addComment(
    Map<String, List<Comment>> comments, AddCommentAction action) {
  return Map.from(comments)
    ..update(action.comment.parentId,
        (commentList) => commentList..add(action.comment),
        ifAbsent: () => [action.comment]);
}

Map<String, List<Comment>> _setLoadedComments(
    Map<String, List<Comment>> comments, CommentsLoadedAction action) {
  return Map.from(comments)
    ..update(action.comments.first.parentId, (commentList) => action.comments,
        ifAbsent: () => action.comments);
}

Map<String, List<Comment>> _setNoComments(
    Map<String, List<Comment>> comments, CommentsNotLoadedAction action) {
  return comments;
}
