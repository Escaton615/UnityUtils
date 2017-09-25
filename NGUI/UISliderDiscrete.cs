using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*  Changes In UIProgressBar.cs:
    

    /// <summary>
    /// Modifiable value for the scroll bar, 0-1 range.
    /// </summary>

    public virtual float GetValue()
    {
        if (numberOfSteps > 1) return Mathf.Round(mValue * (numberOfSteps - 1)) / (numberOfSteps - 1);
        return mValue;
    }

    public virtual float value
    {
        get { return GetValue(); }
*/

/*  Changes in UISliderEditor.cs:
    
    [CanEditMultipleObjects]
    [CustomEditor(typeof(UISliderDiscrete))]
    public class UISliderDiscreteEditor : UISliderEditor
    {
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            SerializedProperty sp = serializedObject.FindProperty("AvailableSteps");

            EditorGUI.BeginChangeCheck(); EditorGUILayout.PropertyField(sp, true);
            if (EditorGUI.EndChangeCheck()) serializedObject.ApplyModifiedProperties();

        }
    }
*/
    
public class UISliderDiscrete : UISlider {

    public List<int> AvailableSteps;

    public override float GetValue()
    {
        int nearest = 1;
        float minDiff = 1f;
        foreach (int availableStep in AvailableSteps)
        {
            var diff = Mathf.Abs((availableStep - 1) / ((float)numberOfSteps - 1) - mValue);
            if (diff < minDiff)
            {
                minDiff = diff;
                nearest = availableStep;
            }
        }
        return (nearest - 1) / (float)(numberOfSteps - 1);
    }
	
}
