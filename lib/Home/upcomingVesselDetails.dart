import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Core/custom_color.dart';

class upcomingVesselDetails extends StatefulWidget {
  // final List<dynamic> upcomingVesselList;
  String vesselName,
      country,
      port,
      estArrivalDate,
      regionNAme,
      coalType,
      calorificValue,
      totalMoisture,
      ashContent,
      estRate,
      coalTypeImage,
      productId,
      inherentMoisture,
      volatileMatter,
      sulphur,
      fixedCarbon,
      hardgroveGrindabilityIndex,
      size,
      phosphorus,
      csr,
      cri,
      aftId,
      aftFt,
      aftHt,
      csn,
      ncv;

  int regionId;
  upcomingVesselDetails(
      {super.key,
      required this.vesselName,
      required this.country,
      required this.port,
      required this.estArrivalDate,
      required this.regionNAme,
      required this.regionId,
      required this.coalType,
      required this.calorificValue,
      required this.totalMoisture,
      required this.ashContent,
      required this.estRate,
      required this.coalTypeImage,
      required this.productId,
      required this.aftFt,
      required this.aftHt,
      required this.aftId,
      required this.cri,
      required this.csn,
      required this.csr,
      required this.fixedCarbon,
      required this.hardgroveGrindabilityIndex,
      required this.inherentMoisture,
      required this.ncv,
      required this.phosphorus,
      required this.size,
      required this.sulphur,
      required this.volatileMatter});

  @override
  State<upcomingVesselDetails> createState() => _upcomingVesselDetailsState();
}

class _upcomingVesselDetailsState extends State<upcomingVesselDetails> {
  List<dynamic> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // list = widget.upcomingVesselList.toList();
    print("upcomimngghui+" + list.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bgColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 30,
                  width: 30,
                  color: CustomTheme.white,
                  child: Center(
                      child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Colors.black,
                  )),
                ),
              ),
            ),
          ),
          backgroundColor: CustomTheme.boxColor,
          elevation: 0.0,
          title: Text(
            widget.vesselName,
            style: TextStyle(
                color: CustomTheme.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: CustomTheme.boxColor),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.country,
                              style: TextStyle(
                                  color: CustomTheme.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Country",
                              style: TextStyle(
                                  color: CustomTheme.orengeTextColor,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.port,
                              style: TextStyle(
                                  color: CustomTheme.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Port",
                              style: TextStyle(
                                  color: CustomTheme.orengeTextColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: CustomTheme.buttonColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  widget.coalTypeImage.toString(),
                                  height: 30,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              widget.estArrivalDate,
                              style: TextStyle(
                                  color: CustomTheme.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Est Arrival Date",
                              style: TextStyle(
                                  color: CustomTheme.orengeTextColor,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.regionNAme,
                              style: TextStyle(
                                  color: CustomTheme.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Region",
                              style: TextStyle(
                                  color: CustomTheme.orengeTextColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Coal Details",
                      style: TextStyle(
                          color: CustomTheme.buttonColor, fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.coalType,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Coal Type",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.calorificValue,
                                //"10.5%-Ash Coking coal",
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Gross Calorific Value (ARB)",
                                //"Quality Parameter",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.totalMoisture,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Total Moisture (ARB)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.ashContent,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Ash Content (ADB)",
                                //"Ash (AD, %)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.inherentMoisture,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Inherent Moisture (ADB)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.volatileMatter,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Volatile Matter (ADB)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.sulphur,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Sulphur (ADB)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.fixedCarbon,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Fixed Carbon (ADB)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.hardgroveGrindabilityIndex,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Hardgrove Grindability Index",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.size,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Size",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.phosphorus,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Phosphorus",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.csr,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "CSR",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.cri,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "CRI",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.aftId,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "AFT (ID)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.aftFt,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "AFT(FT)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.aftHt,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "AFT(HT)",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.csn,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "CSN",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                widget.ncv,
                                style: TextStyle(
                                    color: CustomTheme.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "NCV",
                                style: TextStyle(
                                    color: CustomTheme.orengeTextColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          "Est. Rate",
                          style: TextStyle(
                              color: CustomTheme.orengeTextColor, fontSize: 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "₹ " + widget.estRate,
                          style: TextStyle(
                              color: CustomTheme.buttonColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          "Quantity",
                          style: TextStyle(
                              color: CustomTheme.orengeTextColor, fontSize: 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "5000/MT",
                          style: TextStyle(
                              color: CustomTheme.buttonColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
