enum DataBox { activities, detail }
enum RawDataAction { importing, searching, deleting, clearing }

extension DataBoxExtension on DataBox {
  String get displayName {
    switch (this) {
      case DataBox.activities:
        return "活動";
      case DataBox.detail:
        return "明細";
    }
  }
  String get boxName {
    switch (this) {
      case DataBox.activities:
        return 'activitiesBox';
      case DataBox.detail:
        return 'detailBox';
    }
  }
}
const Map<DataBox, String> boxNameMap = {
  DataBox.activities: 'activitiesBox',
  DataBox.detail: 'detailBox',
};