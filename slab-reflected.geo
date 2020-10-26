Point (1) = {0,   0, 0, 0.5};
Point (2) = {2.71909,   0, 0, 0.25*0.5};
Point (3) = {2.71909+7.51023, 0, 0, 0.5};

Line(1) = {1, 2};
Line(2) = {2, 3};

Physical Line("fuel") = {1};
Physical Line("refl") = {2};

Physical Point("internal") = {1};
Physical Point("external") = {3};
