import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called when the form is added
    let formData: Record<string, string> = {
      'title': 'HarmonyHub',
      'detail': 'Atomic Service Ready'
    };
    let bindingData = formBindingData.createFormBindingData(formData);
    return bindingData;
  }

  onCastToNormalForm(formId: string) {
    // Called when the form is converted to a normal form
  }

  onUpdateForm(formId: string) {
    // Called when the form provider is requested to update the form
  }

  onChangeFormVisibility(newStatus: Record<string, number>) {
    // Called when the form visibility status changes
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event is triggered by the form
  }

  onRemoveForm(formId: string) {
    // Called when the specified form is destroyed
  }

  onConfigurationUpdate(config: object) {
    // Called when the system configuration is updated
  }
};
