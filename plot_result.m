function plot_result(image, corners, points)
    imshow(image);
    hold on;
    plot(corners(:,1), corners(:,2), 'r*');
    plot(points(:,1),points(:,2),'-g');
    plot(points(:,1), points(:,2), '*');

    hold off;
end