lc = 10;
Point(1) = {0, 0, 0, lc};
Point(2) = {100, 0, 0, 0.2*lc};
Line(1) = {1, 2};


Physical Point("left") = {1};
Physical Point("right") = {2};
Physical Line("fuel") = {1};
