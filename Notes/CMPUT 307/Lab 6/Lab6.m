function Lab6(X)
%X is the name of the data file you wish to plot Example is
%Lab6("eclipse1.mat")
    data=load(X).X;
    if size(data,2)==3
        plot3d_pca(data);
    else
        plot2d_pca(data);

    end

end

function [X_centered, centroid] = center(X)
    centroid = mean(X);
    X_centered = X - centroid;
end

function [cov_matrix, eigenvalues, eigenvectors] = PCA(X)
    [X_centered,~]=center(X);
    cov_matrix = cov(X_centered);
    [eigenvectors, eigenvalues] = eig(cov_matrix);
    eigenvalues = diag(eigenvalues);
    [eigenvalues, indices] = sort(eigenvalues, 'descend');
    eigenvectors = eigenvectors(:, indices);
    disp(eigenvectors)
    disp(eigenvalues)

end


function plot2d_pca(X)

    [~, eigenvalues, eigenvectors] = PCA(X);
    
    variances = eigenvalues / sum(eigenvalues);
    
    scatter(X(:,1), X(:,2), 'b.');
    hold on;
    
    quiver(mean(X(:,1)), mean(X(:,2)), ...
        (variances(1))*eigenvectors(1,1), ...
        (variances(1))*eigenvectors(2,1), 0, 'b');
    quiver(mean(X(:,1)), mean(X(:,2)), ...
        (variances(2))*eigenvectors(1,2), ...
        (variances(2))*eigenvectors(2,2), 0, 'r');
    
    xlim([min(X(:,1))-0.5, max(X(:,1))+0.5]);
    ylim([min(X(:,2))-0.5, max(X(:,2))+0.5]);
    

    xlabel('x');
    ylabel('y');
    
    hold off;

end


function plot3d_pca(X)

    [~, eigenvalues, eigenvectors] = PCA(X);

    variances = eigenvalues ./ sum(eigenvalues);

    scatter3(X(:,1), X(:,2), X(:,3), 'b.');
    hold on;
    

    quiver3(mean(X(:,1)), mean(X(:,2)), mean(X(:,3)), (variances(1))*eigenvectors(1,1), ...
        (variances(1))*eigenvectors(2,1), (variances(1))*eigenvectors(3,1), 'b',LineWidth=3);
    quiver3(mean(X(:,1)), mean(X(:,2)), mean(X(:,3)), (variances(2))*eigenvectors(1,2), ...
        (variances(2))*eigenvectors(2,2), (variances(2))*eigenvectors(3,2), 'r',LineWidth=3);
    quiver3(mean(X(:,1)), mean(X(:,2)), mean(X(:,3)), (variances(3))*eigenvectors(1,3), ...
        (variances(3))*eigenvectors(2,3), (variances(3))*eigenvectors(3,3), 'g',LineWidth=3);
    

    xlim([min(X(:,1))-0.5, max(X(:,1))+0.5]);
    ylim([min(X(:,2))-0.5, max(X(:,2))+0.5]);
    zlim([min(X(:,3))-0.5, max(X(:,3))+0.5]);
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    hold off;

end


