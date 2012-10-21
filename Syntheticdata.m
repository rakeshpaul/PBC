a = 3;
b = 3.75;
x = a + (b-a).*rand(100,1);
a = 2;
b = 2.5;
y = a + (b-a).*rand(100,1);

a = 11;
b = 11.5;
x1 = a + (b-a).*rand(100,1);
a = 12;
b = 13;
y1 = a + (b-a).*rand(100,1);


a = 7;
b = 8;
x2 = a + (b-a).*rand(100,1);
a = 6;
b = 6.6;
y2 = a + (b-a).*rand(100,1);


sdInput = [[x;x1;x2] [y;y1;y2]];
save sdInput.mat 'sdInput'
