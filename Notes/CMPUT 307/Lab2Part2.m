d_x = 1; % howmuchever you want to translate in horizontal direction
d_y = 3; % howmuchever you want to translate in vertical direction
% create the original box
% first row has horizontal coordinates, second row has vertical coordinates
my_points = [1 1 2 2 1;1 2 2 1 1];
% write code to plot the original box
fig1=figure(1);
plot([my_points(1,:)],[my_points(2,:)])
% write code to create your Homogeneous 2D Translation matrix my_trans using d_x and d_y
my_trans = [1 0 d_x;0 1 d_y;0 0 1];
% Next, we perform the translation
% write code to convert my_points to the homogeneous system and store the result inhom_my_points
one=ones(1, length(my_points));
hom_my_points = [my_points(1,:);my_points(2,:); one];
% write code to perform translation in the homogeneous system using my_trans and
%hom_my_points and store the result in trans_my_points

for c=1:length(my_points)
   trans_my_points(:,c) = my_trans*hom_my_points(:,c);
end
hold on
% write code to plot the Translated box (output) which has to be done in Cartesian, so...
% cut out the X, Y points and ignore the 3rd dimension
axis([0.5 3.5 0.5 5.5]); % just to make the plot nicely visible
plot([trans_my_points(1,:)],[trans_my_points(2,:)])
hold off;