function edges = moms(I)
% edges = moms(I)
% input:
%
% I: an one channel image
%
% edges: the 8 direction and 5 scales firt derivation of the image.

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
%
%@article{zhou2014novel,
%  title={A Novel Algorithm of Edge Location Based on Omni-directional and Multi-scale MM.},
%  author={Zhou, Hang and Peng, Dan and Wang, Xin and Wang, Hongyi},
%  journal={JCP},
%  volume={9},
%  number={4},
%  pages={990--997},
%  year={2014}
%}

if(~isa(I,'single') || ~isa(I,'double'))
   I = single(I); 
end
%%

persistent W1;
persistent W2;
persistent W3;
persistent W4;

persistent W5;
persistent W6;
persistent W7;
persistent W8;

persistent B1;
persistent B2;
persistent B3;
persistent B4;
persistent B5;

%% W1
W1 = zeros(5);
W1(3,:) = 1;
%% W2
W2 = zeros(5);
for i=1:5
   W2(i,end-(i-1)) = 1; 
end
%% W3
W3 = zeros(5);
W3(3, :) = 1;
%% W4
W4 = zeros(5);
for i=1:5
   W4(i,i) = 1; 
end
%% W5
W5 = zeros(5);
W5(2, end) = 1;
W5(3,3) = 1;
W5(4,1) = 1;
%% W6
W6 = zeros(5);
W6(1, end-1) = 1;
W6(3,3) = 1;
W6(5,2) = 1;
%% W7
W7 = zeros(5);
W7(1, 2) = 1;
W7(3,3) = 1;
W7(5,end-1) = 1;
%% W8
W8 = zeros(5);
W8(2, 1) = 1;
W8(3,3) = 1;
W8(end-1,5) = 1;
%% B1
B1 = strel('diamond',1).Neighborhood;
%% B2
B2 = strel('diamond',3).Neighborhood;
%% B3
B3 = strel('diamond',5).Neighborhood;
%% B4
B4 = strel('diamond',7).Neighborhood;
%% B5
B5 = strel('diamond',9).Neighborhood;


W = cell(1,8);
B = cell(1,5);

edges = double(zeros(size(I)));

W{1} = W1;
W{2} = W2;
W{3} = W3;
W{4} = W4;
W{5} = W5;
W{6} = W6;
W{7} = W7;
W{8} = W8;

for i=1:8
   W{i} = logical(W{i}); 
end

B{1} = B1;
B{2} = B2;
B{3} = B3;
B{4} = B4;
B{5} = B5;

for i=1:5
   B{i} = logical(B{i}); 
end

tmp = cell(1,4);

for i=1:4
   tmp{i} = zeros(size(edges)); 
end

for i=1:4
   
    F = imopen(I, B{i});
    F = imclose(F, B{i+1});
    
    for j=1:8
       
        E = imdilate(F,W{j});
        E = E - imerode(F,W{j});
        
        tmp{i} = tmp{i} + 0.0313 * E;
    end
        
end

for i=1:4
   edges = edges + tmp{i}; 
end

mn = min(edges(:));
mx = max(edges(:));

mx = mx - mn;

edges = (edges - mn) / mx;


end
