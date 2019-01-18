function [detect] = detect(crop_image,plot, roi_coor,org_image)
% HSV [Hue Saturation Value]
detect = 3;
hsv_image = rgb2hsv(uint8(crop_image));
hue = hsv_image(:,:,1);
sat = hsv_image(:,:,2);
val = hsv_image(:,:,3);

mavi    = struct('start',200/360,'finish',263/360);
kirmizi_sol = struct('start',0/360, 'finish',10/360);
kirmizi_sag = struct('start',345/360, 'finish',360/360);

%% Mavi Tespit
mavi_maske = (mavi.start <= hue & hue <= mavi.finish) & sat >= 50/255;
se_open = strel('square',3);
mavi_maske = imopen(mavi_maske,se_open);
mavi_ozellikler = regionprops(mavi_maske);

if isempty(mavi_ozellikler) ~= 1
    figure; imshow(mavi_maske,[]);
    if sum([mavi_ozellikler(:).Area] > 500) > 0
        max_index = find([mavi_ozellikler(:).Area] == max([mavi_ozellikler(:).Area]));
        detect = 2;
        if plot == true
            figure; 
            text_value = ['Mavi Tespit Edildi!'];
            text_position = [mavi_ozellikler(max_index).Centroid] + [roi_coor.x1 roi_coor.y1];
            RGB = insertText(uint8(org_image),text_position,text_value,'AnchorPoint','Center','BoxColor','blue');
            imshow(uint8(RGB), []);
            hold on;
            rectangle('Position',mavi_ozellikler(max_index).BoundingBox + [roi_coor.x1 roi_coor.y1 0 0],'EdgeColor','g');
        end
    end
end

%% Kýrmýzý Tespit
kirmizi_maske = ((kirmizi_sol.start <= hue & hue <= kirmizi_sol.finish) | (kirmizi_sag.start <= hue & hue <= kirmizi_sag.finish)) & sat >= 0.5;

se_open = strel('square',5);
se_close_01= strel('disk',50);
se_close_02= strel('disk',10);

kirmizi_maske = imopen(kirmizi_maske,se_open);
kirmizi_maske = imopen(kirmizi_maske,se_open);
kirmizi_maske = imclose(kirmizi_maske,se_close_01);
kirmizi_maske = imclose(kirmizi_maske,se_close_02);

kirmizi_ozellikler = regionprops(kirmizi_maske);

if isempty(kirmizi_ozellikler) ~= 1
    if sum([kirmizi_ozellikler(:).Area] > 500) > 0
        max_index = find([kirmizi_ozellikler(:).Area] == max([kirmizi_ozellikler(:).Area]));
        if detect == 2
            detect = 0;
        else
            detect = 1;
        end
        
        if plot == true
            figure;
            text_value = ['Kýrmýzý Tespit Edildi!'];
            text_position = [kirmizi_ozellikler(max_index).Centroid] + [roi_coor.x1 roi_coor.y1];
            RGB = insertText(uint8(org_image),text_position,text_value,'AnchorPoint','Center','BoxColor','red');
            imshow(uint8(RGB), []);
            hold on;
            rectangle('Position',kirmizi_ozellikler(max_index).BoundingBox + [roi_coor.x1 roi_coor.y1 0 0],'EdgeColor','g');
        end
    end
end

end

