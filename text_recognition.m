%Loading the image
I = imread('image_name');
figure;
imshow(I);

%Detecting MSER Areas
% i.e, blob detection 
grayimage = rgb2gray(I);
mserRegions = detectMSERFeatures(grayimage,'RegionAreaRange',[150 2000]);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));
figure; imshow(colorImage); hold on;
plot(mserRegions, 'showPixelList', true,'showEllipses',false);
title('MSER regions');

mserMask = false(size(grayimage));
ind = sub2ind(size(mserMask),mserRegionPixelsx(:,2),mserRegionPixels(1,:));
mserMask(ind) = True;

% Edge detection for better accuracy
edgeMask = edge(grayimage,'Canny');
edgeMserIntersection = edgeMask & mserMask;
figure; imshowpair(edgeMask, edgeAndMSERIntersection, 'montage');
title('Canny edges and intersection of canny edges with MSER regions');

%This part is for enhancing the image.

[~, gDir] = imgradient(grayImage);
% You must specify if the text is light on dark background or vice versa
gradientGrownEdgesMask = helperGrowEdges(edgeAndMSERIntersection, gDir, 'LightTextOnDark');
figure; imshow(gradientGrownEdgesMask); title('Edges grown along gradient direction')

% This is to remove those edges in MSER which are not part of the image.
edgeEnhancedMSERMask = ~gradientGrownEdgesMask & mserMask;

% Visualize the effect of segmentation
figure; imshowpair(mserMask, edgeEnhancedMSERMask, 'montage');
title('Original MSER regions and segmented MSER regions')


%Removal of unnecessary stuff
% This is probably code you need everywhere
connComp = bwconncomp(edgeEnhancedMSERMask); % Find connected components
stats = regionprops(connComp,'Area','Eccentricity','Solidity');

% Eliminate regions that do not follow common text measurements
regionFilteredTextMask = edgeEnhancedMSERMask;

regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Eccentricity] > .995})) = 0;
regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Area] < 150 | [stats.Area] > 2000})) = 0;
regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Solidity] < .4})) = 0;

% Visualize results of filtering
figure; imshowpair(edgeEnhancedMSERMask, regionFilteredTextMask, 'montage');
title('Text candidates before and after region filtering')

%Now, is the stroke width part.
distanceImage    = bwdist(~regionFilteredTextMask);  % Compute distance transform
strokeWidthImage = helperStrokeWidth(distanceImage); % Compute stroke width image

% Show stroke width image
figure; imshow(strokeWidthImage);
caxis([0 max(max(strokeWidthImage))]); axis image, colormap('jet'), colorbar;
title('Visualization of text candidates stroke width')

% Find remaining connected components
connComp = bwconncomp(regionFilteredTextMask);
afterStrokeWidthTextMask = regionFilteredTextMask;
for i = 1:connComp.NumObjects
    strokewidths = strokeWidthImage(connComp.PixelIdxList{i});
    % Compute normalized stroke width variation and compare to common value
    if std(strokewidths)/mean(strokewidths) > 0.35
        afterStrokeWidthTextMask(connComp.PixelIdxList{i}) = 0; % Remove from text candidates
    end
end

% Visualize the effect of stroke width filtering
figure; imshowpair(regionFilteredTextMask, afterStrokeWidthTextMask,'montage');
title('Text candidates before and after stroke width filtering')

% Bounding box finding, with initial fusing into a single block
se1=strel('disk',25);
se2=strel('disk',7);

afterMorphologyMask = imclose(afterStrokeWidthTextMask,se1);
afterMorphologyMask = imopen(afterMorphologyMask,se2);

% Display image region corresponding to afterMorphologyMask
displayImage = colorImage;
displayImage(~repmat(afterMorphologyMask,1,1,3)) = 0;
figure; imshow(displayImage); title('Image region under mask created by joining individual characters')

areaThreshold = 5000; % threshold in pixels
connComp = bwconncomp(afterMorphologyMask);
stats = regionprops(connComp,'BoundingBox','Area');
boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
for i=1:size(boxes,1)
    figure;
    imshow(imcrop(colorImage, boxes(i,:))); % Display segmented text
    title('Text region')
end
ocrtxt = ocr(afterStrokeWidthTextMask, boxes); % use the binary image instead of the color image
ocrtxt.Text
