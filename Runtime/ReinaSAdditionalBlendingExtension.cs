using System.Collections.Generic;
using net.rs64.TexTransUnityCore.BlendTexture;
using UnityEngine;

namespace net.rs64.TTTReinaSAdditionalBlending
{
    public class ReinaSAdditionalBlendingExtension : ITexBlendExtension
    {
        public (HashSet<string> ShaderKeywords, Shader shader) GetExtensionBlender()
        {
            var shaderKeywords = new HashSet<string>(){
                "RenaSAdditionalBlending/LinearLightShine",
                "RenaSAdditionalBlending/MaskAlphaOverride",
                "RenaSAdditionalBlending/ColorOverride",
                "RenaSAdditionalBlending/AlphaSubtract",
            };
            return (shaderKeywords,Shader.Find("Hidden/RenaSAdditionalBlending"));
        }
    }
}
