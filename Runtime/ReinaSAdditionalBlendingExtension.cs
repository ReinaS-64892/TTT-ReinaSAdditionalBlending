using System.Collections.Generic;
using net.rs64.TexTransCore.BlendTexture;
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
            };
            return (shaderKeywords,Shader.Find("Hidden/RenaSAdditionalBlending"));
        }
    }
}
