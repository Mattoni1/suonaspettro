import("stdfaust.lib");
theta = par(i, 12, ma.PI*(i+1)/6);
//process = theta(1);
a = hslider("a", 1, 1, 3, 0.01);
xo = hslider("x origin", 0, -10, 10, 0.01);
yo = hslider("y origin", 0, -10, 10, 0.01);
thetarot = hslider("rotazione", 0, -180, 180, 30) * (ma.PI/ 180);
p(i) = a*cos(ba.take(i, theta)), a*sin(ba.take(i, theta));
//process = p(1);
serie = 1, 4, 6, 6, 8, 5, 7, 10, 12, 9, 11, 2, 12, 3;

px(1) = (xo,yo);
px(n) = px(n-1), p(ba.take(n-1,serie)):>_,_;
//px(2) = ba.take(2,px(2));
xr = ba.take(1, px(2)) * cos(thetarot) - ba.take(1, px(2)) * sin(thetarot); // Calcolo della nuova coordinata x'
yr = ba.take(1, px(2)) * sin(thetarot) + ba.take(1, px(2)) * cos(thetarot); // Calcolo della nuova coordinata y'
pr = xr,yr;

//process = px(2);
//process = par(i,14,px(i+1));

process = ba.take(1, px(5));