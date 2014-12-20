languageImage = imread('book.jpg');
boxes = helperDetectText(languageImage);

% Visualize the results
figure; imshow(languageImage); title('Posters with different languages')
hold on
for i=1:size(boxes,1)
    rectangle('Position', boxes(i,:),'EdgeColor','r')
end