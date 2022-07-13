/// postUrl : "https://firebasestorage.googleapis.com/v0/b/socialmediaapp-d85db.appspot.com/o/feedPosts%2Fscaled_ca89d3a5-b182-41eb-b8ac-06eb14c1722a3321253844240093952.jpg?alt=media&token=5fcf8c59-bfba-4124-8f18-09bcf6d3d6b5"
/// postedAt : 1655379362457
/// feedId : "l1USq3GeROUIbP2AdF4KU2nNCOp21655379362456085"
/// userId : "l1USq3GeROUIbP2AdF4KU2nNCOp2"
/// likes : ["i6543qwearsdghfjgk"]

class FeedModel {
  FeedModel({
      this.postUrl, 
      this.postedAt, 
      this.feedId, 
      this.userId, 
      this.likes,});

  FeedModel.fromJson(dynamic json) {
    postUrl = json['postUrl'];
    postedAt = json['postedAt'];
    feedId = json['feedId'];
    userId = json['userId'];
    likes = json['likes'] != null ? json['likes'].cast<String>() : [];
  }
  String? postUrl;
  int? postedAt;
  String? feedId;
  String? userId;
  List<String>? likes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postUrl'] = postUrl;
    map['postedAt'] = postedAt;
    map['feedId'] = feedId;
    map['userId'] = userId;
    map['likes'] = likes;
    return map;
  }

}