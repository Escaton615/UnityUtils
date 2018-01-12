using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dithering : MonoBehaviour
{

    private Texture2D ditherMap;
    public int size = 16;

	// Use this for initialization
	void Start ()
	{
	    generateDitherMap(size);
	}

    private void generateDitherMap(int size)
    {
        ditherMap = new Texture2D(size, size, TextureFormat.RFloat, false, false);
        var finalmatrix = generateDitherMatrix(size);
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                var c = finalmatrix[i * size + j];
                ditherMap.SetPixel(i,j,new Color(c,0,0));
                ditherMap.filterMode = FilterMode.Point;
                ditherMap.Apply();
                Debug.Log(finalmatrix[i * size + j]* size * size) ;
            }
        }
        GetComponent<Renderer>().material.SetTexture("_DitherMap", ditherMap);
    }

    private float[] generateDitherMatrix(int size)
    {
        if (size % 2 != 0)
        {
            Debug.LogError(string.Format("trying to create dither map with illegal size: {0}", size));
            return null;
        }
        if (size == 2)
        {
            return new float[4] {0f/4f, 2f/4f, 3f/4f, 1f/4f};
        }
        else
        {
            float[] ret = new float[size*size];
            int halfSize = size / 2;
            float[] sub = generateDitherMatrix(halfSize);

            for (int i = 0; i < halfSize; i++)
            {
                for (int j = 0; j < halfSize; j++)
                {
                    var f = sub[i * halfSize + j] * halfSize * halfSize;
                    ret[i * size + j] = f * 4 / (size * size);
                    ret[i * size + j + halfSize] = (2 + f * 4) / (size * size);
                    ret[(i + halfSize) * size + j] = (3 + f * 4) / (size * size);
                    ret[(i + halfSize) * size + j + halfSize] = (1 + f * 4) / (size * size);
                }
                
            }

            return ret;
        }
    }


    // Update is called once per frame
//	void Update () {
//		
//	}
}
