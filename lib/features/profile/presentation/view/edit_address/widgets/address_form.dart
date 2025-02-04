import 'package:beautilly/core/utils/common/custom_dropdown.dart';
import 'package:beautilly/features/profile/presentation/controllers/edit_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/auth/data/models/state_model.dart';
import 'package:beautilly/features/auth/data/models/city_model.dart';

class AddressForm extends StatefulWidget {
  final EditAddressController controller;

  const AddressForm({
    super.key,
    required this.controller,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<StateModell>(
          itemToString: (state) => state.name,
          label: 'المنطقة',
          value: widget.controller.selectedState,
          items: widget.controller.states,
          onChanged: (state) {
            widget.controller.onStateChanged(state);
            // تصفير اختيار المدينة عند تغيير المنطقة
            widget.controller.onCityChanged(null);
            setState(() {}); // تحديث الواجهة
          },
          validator: (value) {
            if (value == null) {
              return 'يرجى اختيار المنطقة';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomDropdown<CityModell>(
          itemToString: (city) => city.name ,
          label: 'المدينة',
          value: widget.controller.selectedCity,
          items: widget.controller.cities,
          onChanged: widget.controller.onCityChanged,
          validator: (value) {
            if (value == null) {
              return 'يرجى اختيار المدينة';
            }
            return null;
          },
        ),
      ],
    );
  }
}

