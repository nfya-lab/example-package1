using UnityEngine;
using VRC.SDKBase;

namespace Nfya.ExamplePackage1
{
    public class ExampleScript1 : VRCBehaviour
    {
        [Header("Example Package 1")]
        public string exampleText = "Hello from Example Package 1!";
        
        void Start()
        {
            Debug.Log($"[ExamplePackage1] {exampleText}");
        }
        
        public void ExampleMethod()
        {
            Debug.Log("[ExamplePackage1] Example method called!");
        }
    }
}