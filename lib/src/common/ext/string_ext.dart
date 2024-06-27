extension StringExt on String? {
  String? get ePath {
    return this?.trim().replaceAll(' ', '\\ ');
  }

  int? get monthFromString {
    switch (this) {
      case 'jan':
        return DateTime.january;
      case 'feb':
        return DateTime.february;
      case 'mar':
        return DateTime.march;
      case 'apr':
        return DateTime.april;
      case 'may':
        return DateTime.may;
      case 'jun':
        return DateTime.june;
      case 'jul':
        return DateTime.july;
      case 'aug':
        return DateTime.august;
      case 'sep':
        return DateTime.september;
      case 'oct':
        return DateTime.october;
      case 'nov':
        return DateTime.november;
      case 'dec':
        return DateTime.december;
      default:
        return null;
    }
  }
}
