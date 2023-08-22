% create box
% first row is horizontal coordinates; second row is vertical coordinates
my_pts = [2 2 3 3 2;2 3 3 2 2];
% write code here to display the original box
fig1=figure(4);
plot([my_pts(1,:)],[my_pts(2,:)])
% write code here to create your 2D rotation matrix my_rot
my_rot = [cos(pi/6),-sin(pi/6); sin(pi/6),-cos(pi/6)];
% write code to perform rotation using my_rot and my_pts and store the result in my_rot_pts
my_rot_pts = [my_pts(1,1)*my_rot(1,1)+my_pts(2,1)*my_rot(1,2)...
    my_pts(1,2)*my_rot(1,1)+my_pts(2,2)*my_rot(1,2)...
    my_pts(1,3)*my_rot(1,1)+my_pts(2,3)*my_rot(1,2)...
    my_pts(1,4)*my_rot(1,1)+my_pts(2,4)*my_rot(1,2)...
    my_pts(1,5)*my_rot(1,1)+my_pts(2,5)*my_rot(1,2)...;
    my_pts(1,1)*my_rot(2,1)+my_pts(2,1)*my_rot(2,2)...
    my_pts(1,2)*my_rot(2,1)+my_pts(2,2)*my_rot(2,2)...
    my_pts(1,3)*my_rot(2,1)+my_pts(2,3)*my_rot(2,2)...
    my_pts(1,4)*my_rot(2,1)+my_pts(2,4)*my_rot(2,2)...
    my_pts(1,5)*my_rot(2,1)+my_pts(2,5)*my_rot(2,2)];



hold on;
%write code to plot output
axis([1.5 4.5 0 3.5]);
plot([my_rot_pts(1,:)],[my_rot_pts(2,:)])
hold on;