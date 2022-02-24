import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsCountryBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCountryState.dart';

class CountryBottomSheet extends StatelessWidget {
  final countryList = [
    "India",
    "United Arab Emirates",
    "Argentina",
    "Austria",
    "Australia",
    "Belgium"
  ];
  String selectedCountry = "India";

  @override
  Widget build(BuildContext context) {
    final newsCountryBloc = BlocProvider.of<NewsCountryBloc>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 4,
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  color: Color(0xFFd9d9d9),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Text(
                "Choose Your Location",
                style: TextStyle(fontFamily: 'Lato', fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 2,
                color: Color(0xFFd9d9d9),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: countryList.length,
                    itemBuilder: (context, pos) {
                      return BlocBuilder<NewsCountryBloc, NewsCountryState>(
                          builder: (context, state) {
                        if (state is NewsCountrySelectedState) {
                          selectedCountry = state.country;
                        }
                        return CountryListItem(
                            country: countryList[pos],
                            selectedCountry: selectedCountry);
                      });
                    })),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  newsCountryBloc.onCountryChangeApplied(selectedCountry);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryListItem extends StatelessWidget {
  final String country;
  String selectedCountry;

  CountryListItem({required this.country, required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    final newsCountryBloc = BlocProvider.of<NewsCountryBloc>(context);
    return ListTile(
      leading: Text(country),
      trailing: Radio(
        value: country,
        groupValue: selectedCountry,
        onChanged: (String? value) {
          if (value != null) {
            newsCountryBloc.onCountryChange(value);
          }
        },
      ),
    );
  }
}
