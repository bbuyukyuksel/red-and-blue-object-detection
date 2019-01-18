function [roi_image] = crop(Image, roi)
    roi_image = Image(roi.y1:roi.y2, roi.x1:roi.x2,:);
end

