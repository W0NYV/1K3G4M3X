float2 Pixelate(float t, float2 uv, float _MaxWidth_Pixelate, float _MaxHeight_Pixelate, float _MinWidth_Pixelate, float _MinHeight_Pixelate)
{
    float pixelateTime = sin((frac(-t) * acos(-1.0)) / 2.0);

    float2 grid;
    grid.x = floor(uv.x * lerp(_MaxWidth_Pixelate, _MinWidth_Pixelate, pixelateTime)) / lerp(_MaxWidth_Pixelate, _MinWidth_Pixelate, pixelateTime);
    grid.y = floor(uv.y * lerp(_MaxHeight_Pixelate, _MinHeight_Pixelate, pixelateTime)) / lerp(_MaxHeight_Pixelate, _MinHeight_Pixelate, pixelateTime);

    return grid;
}