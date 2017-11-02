function [I_detected, valid_regions] = noisy_defdet(I)
% [I_detected, valid_regions] = bad_day(I, votes)
%
% multi orientation multi scale morphological edge detector.

%Note: This license has also been called the "New BSD License" or "Modified BSD License". See also the 2-clause BSD License.
%
%Copyright 2017 Julien FLEURET (julien.fleuret.1@ulaval.ca)
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%
%2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

I_moms = moms(I);

% figure;
% imshow(I_moms,[]);

% Sobel -> sensitive to x and y variations of gradient
I_edge1 = edge(I_moms,'sobel','both');
% Roberts cross -> sensitive to diagonal and anti diagonal variations of 
% gradient.
I_edge2 = edge(I_moms,'roberts','both');
I_edge = bitand(I_edge1, I_edge2);

% create regions candidate.
sec = strel('square',15);
% sec = strel('rectangle',[9, 7]);
% sec = strel('square',9);
% sec = strel('octagon', 9);
% sec = strel('diamond', 8);
I_close = imclose(I_edge, sec);

% figure;
% imshow(I_close,[]);


% detect the regions of interest
regions = regionprops(I_close,'Area','Centroid','BoundingBox','Image');

cnt=0;
areas = zeros(1, length(regions));

% Define the acceptance threshold.

for i=1:length(regions)
   areas(i) = regions(i).Area; 
end

mx = max(areas);

clear areas;

% NOTE: 0.2 can be tune... but it's unadvise.
mn = ceil(mx * 0.2);

for i=1:size(regions)   
    if(regions(i).Area>mn)
        cnt = cnt+1;
    end    
end

valid_regions = struct('Area', zeros(1, cnt),...
    'Centroid', zeros(cnt, 2),...
    'BoundingBox', zeros(cnt, 4));

% threshold the regions using the 'Area' criterion.
j=1;

for i=1:size(regions)   
    if(regions(i).Area>mn)
        
        region = regions(i);
        
        valid_regions(j).Area = region.Area;
        valid_regions(j).Centroid = region.Centroid(:);
        valid_regions(j).BoundingBox = region.BoundingBox(:);
        
        j = j+1;
    end    
end


I_detected = logical(zeros(size(I_moms)));


for i=1:length(valid_regions)
    
    reg = valid_regions(i);
    BB = reg.BoundingBox;

    x1 = ceil(BB(1));
    x2 = round(x1 + BB(3));
    y1 = ceil(BB(2));
    y2 = round(y1 + BB(4));
    
    I_detected(y1:y2, x1:x2) = 1;
        
end

end
