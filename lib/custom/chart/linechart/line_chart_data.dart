class ChartData<T> {
  double dataValue;
  T sourceData;
  ChartData({this.dataValue, this.sourceData});

  @override
  String toString() {
    return 'ChartData{dataValue: $dataValue}';
  }

}
