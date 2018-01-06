using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthBasedOutline : MonoBehaviour
{

    public Shader OutlineShader;


    private Color _outlinec = Color.black;
    public Color OutlineColor
    {
        get { return _outlinec; }
        set
        {
            _outlinec = value;
            if (mat) mat.SetColor("_OutlineColor", _outlinec);
        }
    }

    private float _outlineThreshold = 0.01f;
    public float OutlineThreshold
    {
        get { return _outlineThreshold; }
        set
        {
            _outlineThreshold = value;
            if (mat) mat.SetFloat("_OutlineThreshold", _outlineThreshold);
        }
    }

    private Material mat;
	// Use this for initialization
	void Start () {
        if (!OutlineShader) OutlineShader = Shader.Find("CQ/DepthBasedOutline");
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	    mat = new Material(OutlineShader);
        OutlineColor = Color.black;
	    OutlineThreshold = 0.005f;
	    mat.SetFloat("_DeltaX", 1f / Screen.width);
	    mat.SetFloat("_DeltaY", 1f / Screen.height);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, mat);
    }
}
