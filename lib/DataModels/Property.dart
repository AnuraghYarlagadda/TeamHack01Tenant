import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class Property {
  String propertyName,
      rent,
      location,
      leasetime,
      owner_email,
      tenant_name,
      tenant_email;
  Property(this.propertyName, this.rent, this.location, this.owner_email,
      this.tenant_name, this.tenant_email);

  Property.fromSnapshot(DataSnapshot snapshot)
      : propertyName = snapshot.value["propertyName"],
        rent = snapshot.value["rent"],
        location = snapshot.value["location"],
        leasetime = snapshot.value["leasetime"],
        owner_email = snapshot.value["owner_email"],
        tenant_name = snapshot.value["tenant_name"],
        tenant_email = snapshot.value["tenant_email"];

  toJson() {
    return {
      "propertyName": propertyName,
      "rent": rent,
      "location": location,
      "leasetime": leasetime,
      "owner_email": owner_email,
      "tenant_name": tenant_name,
      "tenant_email": tenant_email
    };
  }

  Property.fromJson(LinkedHashMap<dynamic, dynamic> data)
      : propertyName = data["propertyName"],
        rent = data["rent"],
        location = data["location"],
        leasetime = data["leasetime"],
        owner_email = data["owner_email"],
        tenant_name = data["tenant_name"],
        tenant_email = data["tenant_email"];
}
