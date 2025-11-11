using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderChange : MonoBehaviour
{
    public enum ShaderType
    {
        Bayer4,
        Bayer16,
        Bayer64,
        Diagonal4,
        Pulse5Int,
        Pulse9Int,
        Dither17,
        Texture,
        Texture2
    }
    [SerializeField] ShaderType shaderType;
    [SerializeField, Range(0, 1)] float alpha = 1f;

    [Space(20)]
    [SerializeField] Renderer targetRenderer;
    [SerializeField] List<Material> materials = new List<Material>();

    void OnValidate()
    {
        if (targetRenderer == null || materials.Count == 0) return;

        int index = (int)shaderType;
        if (index < 0 || index >= materials.Count) return;

        targetRenderer.sharedMaterial = materials[index];
        targetRenderer.sharedMaterial.SetFloat("_Alpha", alpha);
    }
}
