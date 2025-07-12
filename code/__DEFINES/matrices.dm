/// Identity transform matrix (2d) with 6 values
/// list(ax,by,c, dx,dy,f)
#define TRANSFORM_MATRIX_IDENTITY list(1,0,0, 0,1,0)

/// Identity transform matrix (xyz + translation) with 12 values
/// list(xx,xy,xz, yx,yy,yz, zx,zy,zz, cx,cy,cz)
#define TRANSFORM_COMPLEX_MATRIX_IDENTITY list(1,0,0, 0,1,0, 0,0,1, 0,0,0)

/// Identity transform matrix (xyzw + projection) with 16 values exclusive to particles
/// list(xx,xy,xz,xw, yx,yy,yz,yw, zx,zy,zz,zw, wx,wy,wz,ww)
#define TRANSFORM_PROJECTION_MATRIX_IDENTITY list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1)

/// Identity matrix for colors with 20 values
/// list(rr,rg,rb,ra, gr,gg,gb,ga, br,bg,bb,ba, ar,ag,ab,aa, cr,cg,cb,ca)
#define COLOR_MATRIX_IDENTITY list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
