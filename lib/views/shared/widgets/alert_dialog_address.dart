import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';

class AlertDialogAddress extends StatefulWidget {
  final String addressTitle;
  final List list;
  final TextEditingController controller;
  final dynamic saveLocation;
  const AlertDialogAddress(
      {Key? key,
      required this.addressTitle,
      required this.list,
      required this.controller,
      required this.saveLocation})
      : super(key: key);

  @override
  State<AlertDialogAddress> createState() => _AlertDialogAddressState();
}

class _AlertDialogAddressState extends State<AlertDialogAddress> {
  late List filteredLocation;
  final _searchController = TextEditingController();

  @override
  void initState() {
    setState(() {
      filteredLocation = widget.list;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //filter location
  void _filterLocation(value) {
    setState(() {
      filteredLocation = widget.list
          .where((location) => location.locationNameAr.contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
          backgroundColor: MainColor.darkGreyColor,
          title: Text(
            'من فضلك إختار ${widget.addressTitle}',
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  _filterLocation(value);
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              filteredLocation = widget.list;
                              _searchController.text = '';
                            });
                          },
                        )
                      : null,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: 'ابحث عن ${widget.addressTitle}',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                  child: SizedBox(
                // Specify some width
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height / 3.7,
                child: ListView.builder(
                    itemCount: filteredLocation.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.controller.text =
                              filteredLocation[index].locationNameAr!;
                          widget.saveLocation(
                              filteredLocation[index].locationNameEn!, index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 6),
                          child: Text(
                            filteredLocation[index].locationNameAr!,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }),
              )),
            ],
          )),
    );
  }
}
