class NewsCountryState{

}

class NewsCountrySelectedState extends NewsCountryState{
  final String country;

  NewsCountrySelectedState({required this.country});


}

class NewsCountryChangedState extends NewsCountryState{
  final String country;

  NewsCountryChangedState({required this.country});

}

