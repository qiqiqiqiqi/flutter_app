class Address {
  ProvinceData provinceData;
  CityData cityData;
  AreaData areaData;

  @override
  String toString() {
    return 'Address{provinceData: $provinceData, cityData: $cityData, areaData: $areaData}';
  }

}

class ProvinceData {
  String provinceID;
  String provinceName;

  @override
  String toString() {
    return 'Province{provinceID: $provinceID, provinceName: $provinceName}';
  }
}

class CityData {
  String cityID;
  String cityName;

  @override
  String toString() {
    return 'CityData{cityID: $cityID, cityName: $cityName}';
  }
}

class AreaData {
  String areaID;
  String areaName;

  @override
  String toString() {
    return 'AreaData{areaID: $areaID, areaName: $areaName}';
  }
}
