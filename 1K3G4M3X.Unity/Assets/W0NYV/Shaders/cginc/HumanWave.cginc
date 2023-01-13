fixed4 HumanWave(float2 uv, float t, float speed, float rotSpeed, float offset, float frequency, float amplitude)
{
    float2 humanWaveUV = uv;
    humanWaveUV = (humanWaveUV - 0.5) * 2.0;
    humanWaveUV = mul(humanWaveUV, float2x2(cos(t * rotSpeed), -sin(t * rotSpeed), sin(t * rotSpeed), cos(t * rotSpeed)));
    humanWaveUV.x += t * speed;

    float l = amplitude / length(frac((humanWaveUV.x * frequency)*5.0)-0.5);
    float l2 = amplitude / length(frac((humanWaveUV.x + offset) * frequency * 5.0)-0.5);
    float l3 = amplitude / length(frac((humanWaveUV.x - offset) * frequency * 5.0)-0.5);

    return fixed4(l, l2, l3, 1.0);
}