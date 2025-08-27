using UnityEngine;
using UnityEditor;

namespace nfya.ExamplePackage1.Editor
{
    public class ExamplePackageWindow : EditorWindow
    {
        private string textInput = "";

        [MenuItem("nfya/Example/Example Window")]
        public static void ShowWindow()
        {
            ExamplePackageWindow window = GetWindow<ExamplePackageWindow>("Example Window");
            window.minSize = new Vector2(200, 100);
            window.Show();
        }

        private void OnGUI()
        {
            textInput = EditorGUILayout.TextField("Text:", textInput);
            
            if (GUILayout.Button("Button"))
            {
                Debug.Log($"Button clicked! Text: {textInput}");
            }
        }
    }
}