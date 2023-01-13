fixed4 TileAlpha(float2 p, float t)
{

    float seq = floor(fmod(t*4.0, 8.0));
    
    float l = 0.0;

    if(seq > 3.9) //y
    {
        p.y += 0.75;
        l = step(length(p.y), 1.0/4.0);
        
        if(seq > 6.9)
        {
            p.y -= 0.5;
            l += step(length(p.y), 1.0/4.0);
        }
        
        if(seq > 5.9)
        {
            p.y -= 0.5;
            l += step(length(p.y), 1.0/4.0);
        }
        
        if(seq > 4.9)
        {
            p.y -= 0.5;
            l += step(length(p.y), 1.0/4.0);
        }
    }
    else //x
    {         
        p.x += 0.75;
        l = step(length(p.x), 1.0/4.0);
        
        if(seq > 2.9)
        {
            p.x -= 0.5;
            l += step(length(p.x), 1.0/4.0);
        }
        
        if(seq > 1.9)
        {
            p.x -= 0.5;
            l += step(length(p.x), 1.0/4.0);
        }
        
        if(seq > 0.9)
        {
            p.x -= 0.5;
            l += step(length(p.x), 1.0/4.0);
        }
    }

    return fixed4(l, l, l, seq);
}