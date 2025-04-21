import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

import 'package:beautilly/features/auth/data/models/state_model.dart';
import 'package:beautilly/features/auth/data/models/city_model.dart';
import 'package:beautilly/features/auth/domain/repositories/location_repository.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationSearchForm extends StatefulWidget {
  const LocationSearchForm({super.key});

  @override
  State<LocationSearchForm> createState() => _LocationSearchFormState();
}

class _LocationSearchFormState extends State<LocationSearchForm> {
  final LocationRepository _locationRepository = sl<LocationRepository>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<StateModell> _allStates = [];
  List<StateModell> _filteredStates = [];
  List<CityModell> _cities = [];
  bool _isLoading = true;
  bool _showResults = false;
  
  @override
  void initState() {
    super.initState();
    _loadStates();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _showResults = false;
      });
    }
  }

  Future<void> _loadStates() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _locationRepository.getStates();
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
      },
      (states) {
        setState(() {
          _allStates = states;
          _filteredStates = states;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _loadCitiesForState(int stateId) async {
    final result = await _locationRepository.getCities(stateId);
    result.fold(
      (failure) {
        // Handle error silently
      },
      (cities) {
        _cities = cities;
      },
    );
  }

  void _filterStates(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStates = _allStates;
      } else {
        _filteredStates = _allStates
            .where((state) => state.name.contains(query))
            .toList();
      }
      _showResults = query.isEmpty ? false : true;
    });
  }

  Future<void> _selectState(StateModell state, int currentStateId) async {
    // Only update if different from current state
    if (state.id == currentStateId) {
      setState(() {
        _showResults = false;
        _searchController.clear();
      });
      return;
    }
    
    // Hide search results and show loading
    setState(() {
      _showResults = false;
      _searchController.clear();
      _isLoading = true;
    });

    // Load cities for this state
    await _loadCitiesForState(state.id);
    
    // Get default city ID
    int defaultCityId = _cities.isNotEmpty ? _cities.first.id : 0;
    
    // Update address in profile
    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.updateAddress(
      stateId: state.id,
      cityId: defaultCityId,
    );
    
    // No need to manually refresh as ProfileCubit already redirects to Splash
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        // Extract current state info from profile state
        String currentStateName = '';
        int currentStateId = 0;
        
        if (profileState is ProfileLoaded && profileState.profile.state != null) {
          currentStateName = profileState.profile.state!.name;
          currentStateId = profileState.profile.state!.id;
        }
        
        return GestureDetector(
          // Close search when tapping outside of the form
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _showResults = false;
            });
          },
          // Prevent the tap from closing search when tapping on the form itself
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'اختيار المنطقة',
                        style: getBoldStyle(
                          color: AppColors.primary,
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // When tapped, just focus and don't close results
                              FocusScope.of(context).requestFocus(_searchFocusNode);
                            },
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: _filterStates,
                              onTap: () {
                                if (_searchController.text.isEmpty) {
                                  setState(() {
                                    _showResults = true;
                                  });
                                }
                              },
                              style: getMediumStyle(
                                color: AppColors.textPrimary,
                                fontSize: FontSize.size14,
                                fontFamily: FontConstant.cairo,
                              ),
                              decoration: InputDecoration(
                                hintText: currentStateName.isEmpty 
                                    ? 'ابحث عن منطقة'
                                    : 'المنطقة الحالية: $currentStateName',
                                hintStyle: getMediumStyle(
                                  color: currentStateName.isEmpty 
                                      ? AppColors.grey
                                      : AppColors.black.withOpacity(0.9),
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                ),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.primary,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: currentStateName.isEmpty
                                        ? AppColors.grey.withOpacity(0.3)
                                        : AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_showResults && !_isLoading)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: _filteredStates.isEmpty 
                                  ? 50 
                                  : _filteredStates.length < 4
                                      ? _filteredStates.length * 40.0 // 40 height per item for small lists
                                      : 160, // Max height for longer lists
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _filteredStates.isEmpty
                                  ? Center(
                                      child: Text(
                                        'لا توجد نتائج',
                                        style: getMediumStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: FontSize.size14,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount: _filteredStates.length,
                                      separatorBuilder: (context, index) => const Divider(
                                        height: 1,
                                        thickness: 0.5,
                                        indent: 8,
                                        endIndent: 8,
                                      ),
                                      itemBuilder: (context, index) {
                                        final state = _filteredStates[index];
                                        final isCurrentState = state.id == currentStateId;
                                        return Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _selectState(state, currentStateId),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  if (isCurrentState)
                                                    const Icon(
                                                      Icons.check_circle,
                                                      color: AppColors.primary,
                                                      size: 16,
                                                    ),
                                                  if (isCurrentState)
                                                    const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      state.name,
                                                      textAlign: TextAlign.right,
                                                      style: getMediumStyle(
                                                        color: isCurrentState
                                                            ? AppColors.primary
                                                            : AppColors.textPrimary,
                                                        fontSize: FontSize.size14,
                                                        fontFamily: FontConstant.cairo,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                        ],
                      ),
                      if (_isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.white.withOpacity(0.6),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 