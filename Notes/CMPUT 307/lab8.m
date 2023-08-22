X = pcread('dragondata/dragon.ply').Location;
figure(1)
hold on;
scatter3(X(:,1),X(:,2),X(:,3),"b.");
num_points=size(X,1);
fprintf(" b) Number of points is %d .\n",num_points);
[eigen,~,~]=pca(X);

first_eigen=eigen(:,1);
disp(" c) Our first eigen vector is :");
disp(first_eigen);

new_x=X;

new_x(:,1)=X * first_eigen;
figure(2)
hold on;
scatter3(new_x(:,1),new_x(:,2),new_x(:,3),"b.");

[~, ind] = sort(new_x(:,1));
sorted_x = new_x(ind,:);

min_x = sorted_x(1,1);
max_x = sorted_x(end,1);

fprintf(" f) Our Min X is %f while our Max x is %f.\n",min_x,max_x);

points=size(sorted_x,1);
interval_size=ceil(points/100);
num_clusters=ceil(interval_size/10);
radii = zeros(num_clusters, 100);

fileID = fopen('radii.txt', 'w');
fprintf(fileID, 'Interval\tCluster\tCenter X\tCenter Y\tCenter Z\tRadius\n');

figure(3) 
for i=1:100
    low=(i-1)*interval_size+1;
    high=(i)*interval_size;

    if high>points
        high=points;
    end
    %here we choose our centers randomly from the split points
    split=sorted_x(low:high, :);
    index = randperm(size(split, 1), num_clusters);
    centers = split(index, :);
    [idx, final_center,~,D] = kmeans(split, num_clusters, 'Start', centers);
    for j = 1:num_clusters
        cluster_points = split(idx == j, :);
        step_1=cluster_points-final_center(j,:);
        step_2=sum(step_1.^2,2);
        radii(j,i) = max(step_2.^0.5);
        [x,y,z] = sphere(50);
        x = x * radii(j,i) + final_center(j,1);
        y = y * radii(j,i) + final_center(j,2);
        z = z * radii(j,i) + final_center(j,3);
        surf(x,y,z, 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha', 0.3);
        hold on;
        fprintf(fileID, '%d\t%d\t%0.4f\t%0.4f\t%0.4f\t%0.4f\n',i, j, final_center(j, 1), final_center(j, 2), final_center(j, 3), radii(j,i));
    end
end
hold off;

fclose(fileID);
disp("Done")
figure(4)
scatter3(new_x(:,1), new_x(:,2), new_x(:,3), 'b.');