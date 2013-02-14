__device__  inline float2 simpleProjection( uint2 size, uint2 ssize/*, uint2 sizeImg*/ ,uint2 coord, int L)
{
	const float2 cf		= make_float2(ssize) * make_float2(coord) / make_float2(size) ;
	const int2	 a		= make_int2(cf);
	const float2 uva	= (make_float2(a) + 0.5f) / (make_float2(ssize));
	const float2 uvb	= (make_float2(a+1) + 0.5f) / (make_float2(ssize));
	float2 ra, rb, Iaa;

	ra	= tex2DLayered( TexLay_Proj, uva.x, uva.y, L);
	rb	= tex2DLayered( TexLay_Proj, uvb.x, uva.y, L);
	if (ra.x < 0.0f || ra.y < 0.0f || rb.x < 0.0f || rb.y < 0.0f)
		return make_float2(cH.badVig);

	Iaa	= ((float)(a.x + 1.0f) - cf.x) * ra + (cf.x - (float)(a.x)) * rb;
	ra	= tex2DLayered( TexLay_Proj, uva.x, uvb.y, L);
	rb	= tex2DLayered( TexLay_Proj, uvb.x, uvb.y, L);

	if (ra.x < 0.0f || ra.y < 0.0f || rb.x < 0.0f || rb.y < 0.0f)
		return make_float2(cH.badVig);

	ra	= ((float)(a.x+ 1.0f) - cf.x) * ra + (cf.x - (float)(a.x)) * rb;
	ra = ((float)(a.y+ 1.0f) - cf.y) * Iaa + (cf.y - (float)(a.y)) * ra;
	/*ra = (ra + 0.5f) / (make_float2(sizeImg));*/

	return ra;
}