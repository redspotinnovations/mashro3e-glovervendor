import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/services/custom_form_builder_validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_service.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/multiple_image_selector.dart';
import 'package:fuodz/widgets/states/loading_indicator.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewServicePage extends StatelessWidget {
  const NewServicePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewServiceViewModel>.reactive(
      viewModelBuilder: () => NewServiceViewModel(context),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "New Service".tr(),
          body: FormBuilder(
            key: vm.formBuilderKey,
            child: VStack(
              [
                //categories
                LoadingIndicator(
                  loading: vm.busy(vm.categories),
                  child: VStack(
                    [
                      "Category".tr().text.make(),
                      FormBuilderDropdown(
                        name: "category_id",
                        items: vm.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: '${category.id}',
                                child: Text('${category.name}'),
                              ),
                            )
                            .toList(),
                        validator: CustomFormBuilderValidator.required,
                        onChanged: vm.fetchSubCategories,
                      ),
                    ],
                  ),
                ),
                UiSpacer.verticalSpace(),
                //sub categories
                LoadingIndicator(
                  loading: vm.busy(vm.subcategories),
                  child: VStack(
                    [
                      "Sub Category".tr().text.make(),
                      FormBuilderDropdown(
                        name: "subcategory_id",
                        decoration: InputDecoration(
                          hintText: "",
                        ),
                        items: vm.subcategories
                            .map(
                              (subcategory) => DropdownMenuItem(
                                value: '${subcategory.id}',
                                child: Text('${subcategory.name}'),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                UiSpacer.verticalSpace(),

                //name
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'Name'.tr(),
                  ),
                  onChanged: (value) {},
                  validator: CustomFormBuilderValidator.required,
                ),
                UiSpacer.verticalSpace(),
                //description
                FormBuilderTextField(
                  name: 'description',
                  decoration: InputDecoration(
                    labelText: 'Description'.tr(),
                  ),
                  onChanged: (value) {},
                  validator: CustomFormBuilderValidator.required,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                UiSpacer.verticalSpace(),
                //image
                MultipleImageSelectorView(
                  onImagesSelected: vm.onImagesSelected,
                ),
                UiSpacer.verticalSpace(),
                //durations
                LoadingIndicator(
                  loading: vm.busy(vm.serviceDurations),
                  child: VStack(
                    [
                      "Duration Type".tr().text.make(),
                      FormBuilderDropdown(
                        name: "duration",
                        validator: CustomFormBuilderValidator.required,
                        decoration: InputDecoration(
                          hintText: "",
                        ),
                        items: vm.serviceDurations
                            .map(
                              (serviceDuration) => DropdownMenuItem(
                                value: '$serviceDuration',
                                child: Text('${serviceDuration}'),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                UiSpacer.verticalSpace(),
                //pricing
                HStack(
                  [
                    //price
                    FormBuilderTextField(
                      name: 'price',
                      decoration: InputDecoration(
                        labelText: 'Price'.tr(),
                      ),
                      onChanged: (value) {},
                     validator: (value) => CustomFormBuilderValidator.compose([
                        CustomFormBuilderValidator.required(value),
                        CustomFormBuilderValidator.numeric(value),
                      ]),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ).expand(),
                    UiSpacer.horizontalSpace(),
                    //Discount price
                    FormBuilderTextField(
                      name: 'discount_price',
                      initialValue: "0",
                      decoration: InputDecoration(
                        labelText: 'Discount Price'.tr(),
                      ),
                      onChanged: (value) {},
                     validator: (value) => CustomFormBuilderValidator.compose([
                        CustomFormBuilderValidator.required(value),
                        CustomFormBuilderValidator.numeric(value),
                      ]),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ).expand(),
                  ],
                ),

                //checkbox
                HStack(
                  [
                    //Location Required
                    FormBuilderCheckbox(
                      initialValue: false,
                      name: 'location',
                      onChanged: (value) {},
                      valueTransformer: (value) => value ? 1 : 0,
                      title: "Location Required".tr().text.make(),
                    ).expand(),
                    UiSpacer.horizontalSpace(),
                    //Active
                    FormBuilderCheckbox(
                      initialValue: true,
                      name: 'is_active',
                      onChanged: (value) {},
                      valueTransformer: (value) => value ? 1 : 0,
                      title: "Active".tr().text.make(),
                    ).expand(),
                  ],
                ),
                //

                //
                CustomButton(
                  title: "Save".tr(),
                  icon: FlutterIcons.save_fea,
                  loading: vm.isBusy,
                  onPressed: vm.processNewService,
                ).wFull(context).py12(),
                UiSpacer.verticalSpace(),
                UiSpacer.verticalSpace(),
              ],
            )
                .p20()
                .scrollVertical()
                .pOnly(bottom: context.mq.viewInsets.bottom),
          ),
        );
      },
    );
  }
}
