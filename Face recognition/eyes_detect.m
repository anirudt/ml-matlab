NoseDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',10);
I = imread('DSC00861.jpg');
BB = step(NoseDetect,I);

figure;
imshow(I); hold on
for i=1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'EdgeColor','b','LineStyle','-');
end
title('Nose Detection');
hold off