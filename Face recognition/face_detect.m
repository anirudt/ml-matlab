FDetect = vision.CascadeObjectDetector;
I = imread('DSC00861.jpg');
BB = step(FDetect,I);

figure;
imshow(I); hold on
for i=1:size(BB,1)
    rectangle('Position', BB(i,:),'Linewidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;