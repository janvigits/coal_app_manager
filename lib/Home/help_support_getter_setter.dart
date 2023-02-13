class helpSupportGetterSetter {
  final int issueId, isResolved;
  final String ticketNo, issueDate;
  String issueTittle;

  helpSupportGetterSetter(this.issueId, this.ticketNo, this.issueDate,
      this.issueTittle, this.isResolved);

  @override
  String toString() {
    return '{ ${this.issueId}, ${this.ticketNo}, ${this.issueDate}, ${this.issueTittle}, ${this.isResolved}';
  }

  factory helpSupportGetterSetter.fromJson(dynamic json) {
    return helpSupportGetterSetter(
      json['issueId'] as int,
      json['ticketNo'] as String,
      json['issueDate'] as String,
      json['issueTitle'] as String,
      json['isResolved'] as int,
    );
  }
}
