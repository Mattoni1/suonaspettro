import("stdfaust.lib");
g = par(i, 12, ma.PI*(i+1)/6);
//process = theta(1);
a = hslider("a", 1, 1, 3, 0.01);
xo = hslider("x origin", 0, -10, 10, 0.01);
yo = hslider("y origin", 0, -10, 10, 0.01);
thetarot = hslider("rotazione", 0, -180, 180, 30) * (ma.PI/ 180);
indg(i) = a*cos(ba.take(i, g)), a*sin(ba.take(i, g));

//process = p(1);
serie = 1, 4, 6, 6, 8, 5, 7, 10, 12, 9, 11, 2, 12, 3;

p(1) = (xo,yo);
p(n)  = p(n-1), indg(ba.take(n-1,serie)):>_,_;
px(n) = p(n-1), indg(ba.take(n-1,serie)):>_,!;
py(n) = p(n-1), indg(ba.take(n-1,serie)):>!,_;



xr = px(n) * cos(thetarot) - py(n) * sin(thetarot); // Calcolo della nuova coordinata x'
yr = px(n) * sin(thetarot) + py(n) * cos(thetarot); // Calcolo della nuova coordinata y'
pr = xr,yr;

//process = par(i,14,p(i+1));
process = xr;