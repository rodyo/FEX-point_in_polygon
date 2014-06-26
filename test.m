clc

P1 = 50*rand(25,2) - 25;
I  = convhull(P1(:,1), P1(:,2));
P1 = P1(I,:);

Pc = sum(P1)/size(P1,1);
angles = atan2(P1(:,2)-Pc(2), P1(:,1)-Pc(1));
[~,I] = sort(angles);
P1 = P1(I,:);
P1 = [P1; P1(1,:)];

T = 100*rand(1e5,2) - 50;



% line(P1(:,1), P1(:,2));
% hold on
% plot(T(:,1), T(:,2), 'r.');
N = 1e1;

tic
for ii = 1:N
in1 = point_in_polygon(P1, T);
end
toc

tic
for ii = 1:N
in2 = inpoly(T, P1);
end
toc

tic
for ii = 1:N
in3 = inpolygon(T(:,1),T(:,2), P1(:,1),P1(:,2));
end
toc

isequal(in1,in2,in3)

% plot(T(in1,1), T(in1,2), 'g.') 
% plot(T(in2,1), T(in2,2), 'k.') 

%%

xv = rand(6,1); yv = rand(6,1);
xv = [xv ; xv(1)]; yv = [yv ; yv(1)];
x = rand(1000,1); y = rand(1000,1);
in = inpolygon(x,y,xv,yv);
plot(xv,yv,x(in),y(in),'.r',x(~in),y(~in),'.b')
hold on

in = inpoly([xv,yv], [x,y])
plot(xv,yv,x(in),y(in),'.g')


