import("stdfaust.lib");
theta = par(i, 12, ma.PI*(i+1)/6);
//process = theta(1);
a = hslider("a", 1, 1, 3, 0.01);
xo = hslider("x origin", 0, -10, 10, 0.01);
yo = hslider("y origin", 0, -10, 10, 0.01);
p(i) = a*cos(ba.take(i, theta)), a*sin(ba.take(i, theta));
//process = p(1);
serie = 1, 4, 6, 6, 8, 5, 7, 10, 12, 9, 11, 2, 12, 3;
//rot = hslider("rotate",0,0,12,1);
process = serie : ro.crossNM(2,12);

px(1) = xo,yo;
px(n) = px(n-1),p(ba.take(n-1,serie)):>_,_;
//process = px(14);
//process = par(i,14,px(i+1));
