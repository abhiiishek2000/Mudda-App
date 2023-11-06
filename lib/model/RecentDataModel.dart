class RecentDataOffline {
    String? muddaId;
    String? leadersCount;
    String? totalPost;
    String? support;
    String? inDebate;

  RecentDataOffline({
    this.muddaId,
    this.leadersCount,
    this.totalPost,
    this.support,
    this.inDebate,
  });
  RecentDataOffline.fromMap(Map<String, dynamic> map) {
    muddaId = map['muddaId'];
    leadersCount = map['leadersCount'];
    totalPost = map['totalPost'];
    support = map['support'];
    inDebate = map['inDebate'];

  }




  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"muddaId": muddaId,'leadersCount':leadersCount,'totalPost':totalPost,'support' : support,'inDebate' : inDebate};
    return map;
  }
}
