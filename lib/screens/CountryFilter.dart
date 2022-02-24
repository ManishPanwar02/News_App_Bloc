import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsApiBloc.dart';
import 'package:news_app_bloc/blocs/NewsCountryBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCountryState.dart';
import 'package:news_app_bloc/screens/CountryBottomSheet.dart';

class CountryFilter extends StatelessWidget {
  final Map<String,String> _countryMap= {
    "India":"in",
    "United Arab Emirates":"ae",
    "Argentina":"ar",
    "Austria":"at",
    "Australia":"au",
    "Belgium":"be"
  };
  String selectedCountryCode="in";
  String selectedCountry="India";

  @override
  Widget build(BuildContext context) {
    final newsApiBloc=BlocProvider.of<NewsApiBloc>(context);
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CountryBottomSheet();
                });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Location",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                const Icon(CupertinoIcons.location),
                BlocBuilder<NewsCountryBloc,NewsCountryState>(builder: (context, state) {
                  if(state is NewsCountryChangedState){
                    selectedCountryCode=_countryMap[state.country]!;
                    selectedCountry=state.country;
                    newsApiBloc.changeCountryCode(selectedCountryCode);
                  }
                  return Text(
                    selectedCountry,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  );
                })

              ])
            ],
          ),
        ));
  }
}
