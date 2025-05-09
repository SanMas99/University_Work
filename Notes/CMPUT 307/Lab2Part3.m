d_x = 3;% how much ever you want to translate in horizontal direction
d_y = 1; % how much ever you want to translate in vertical direction
% create original box
% first row is horizontal and second row is vertical coordinates
my_pts = [3 3 4 4 3;3 4 4 3 3];
% write code to plot the box

fig1=figure(1);
plot([my_pts(1,:)],[my_pts(2,:)])
% write code here to create your 2D rotation matrix my_rot
my_rot = [cos(11*pi/6),-sin(11*pi/6); sin(11*pi/6),cos(11*pi/6)];
% write code to create your Homogeneous 2D Translation matrix hom_trans using d_x & d_y
hom_trans = [1 0 d_x;0 1 d_y;0 0 1];
% Perform Compound transformation
% write code to construct your 2D Homogeneous Rotation Matrix using my_rot and store theresult in hom_rot
% HINT: start with a 3x3 identity matrix and replace a part of it with my_rot to create hom_rot
hom_rot = [my_rot(1,1)  my_rot(1,2) 0; my_rot(2,1) my_rot(2,2) 0; 0 0 1];
% write code to convert my_pts to the homogeneous system and store the result inhom_my_pts
one=ones(1, length(my_pts));
hom_my_points = [my_pts(1,:);my_pts(2,:); one];
% write code to perform in a single compound transformation: translation (hom_trans)
%followed by rotation (hom_rot) on hom_my_pts, and store the result in trans_my_pts
comp1=mtimes(hom_rot,hom_trans);

trans_my_pts = [];
for c=1:length(hom_my_points)
   trans_my_points(:,c) = comp1*hom_my_points(:,c);
end
plot([trans_my_points(1,:)],[trans_my_points(2,:)])


% write code to plot the transformed box (output) which has to be done in Cartesian, so...
% cut out the X, Y points and ignore the 3rd dimension
hold on
axis([2 8 -2 5]); % just to make the plot nicely visible
% Now, let us reverse the order of rotation and translation and compare
fig2=figure(2);
plot(my_pts(1,1:end),my_pts(2,1:end),'b*-');
% write code to perform in a single compound transformation: rotation followed by translation,and store the result in trans_my_pts
comp2=mtimes(hom_trans,hom_rot);
trans_my_pts = [];
for c=1:length(hom_my_points)
   trans_my_points(:,c) = comp2*hom_my_points(:,c);
end
plot([trans_my_points(1,:)],[trans_my_points(2,:)])
hold on
% write code to plot the Transformed box (output) which has to be done in Cartesian, so...
% cut out the X, Y points and ignore the 3rd dimension
axis([2 8 -2 5]); % just to make the plot nicely visible