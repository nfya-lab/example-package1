using UnityEngine;
using UnityEditor;

namespace Nfya.ExamplePackage1.Editor
{
    [CustomEditor(typeof(ExampleScript1))]
    public class ExampleEditor1 : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();
            
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Example Package 1 - Editor Extension", EditorStyles.boldLabel);
            
            if (GUILayout.Button("Test Example Method"))
            {
                var script = (ExampleScript1)target;
                script.ExampleMethod();
            }
        }
    }
}
