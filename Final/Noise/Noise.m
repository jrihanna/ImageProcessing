% Author: Reihane Zekri
% Email: reihane.zekri@gmail.com

% Main function to call different filters
function Noise(im, noiseType)
    %close all;
    
    KERNEL_SIZE = 3;
    
    % Read in the image and convert to gray
    orig = imread (im);
    grayscale = rgb2gray ( orig );
    
    % Add noise to the grayscale image and display
    noisyImage = imnoise ( grayscale , noiseType );
    
    ShowOriginalImage(noisyImage);
    
    MeanFilter(noisyImage,KERNEL_SIZE);
    
    Gaussian(noisyImage,9,KERNEL_SIZE);
    
    MedianFilter(noisyImage);
    
end

function ShowOriginalImage(noisyImage)
    subplot(2,3,2)
    imshow(noisyImage);
    title('Original image');
end

% Apply convolution operations
% img       :   grayscaled image to be convolved
% kernel    :   kernel matrix, usually 3*3, as the reference for convolution
function [new_image] =  conv_customized(img, kernel)

    new_image = zeros(size(img));
    
    zero_to_row_num = zeros(1,size(img,2));
    zero_to_col_num = zeros(size(img,1) + 2,1);
    
    zero_border_img = [zero_to_row_num;img;zero_to_row_num];
    zero_border_img = double([zero_to_col_num zero_border_img zero_to_col_num]);
    
    kernel_row_num = size(kernel,1);
    kernel_col_num = size(kernel,2);
    
    img_size = size(zero_border_img);
    
    for i = 1:img_size(1)-kernel_row_num
        for j = 1:img_size(2)-kernel_col_num
            new_image(i,j) = sum(sum(zero_border_img(i:i+kernel_row_num-1,j:j+kernel_col_num-1) .* kernel));
        end
    end
    
    new_image;
end


function Gaussian(noisyImage, sigma, size)
    
    kernel = zeros(size);
    
    noisyImage = double(noisyImage);
    
    for i = 1:size
        for j = 1:size
            kernel(i,j) = exp(-1*(i^2 + (j)^2)/(2*(sigma^2)));
        end
    end
    
    new_image = conv_customized(noisyImage,kernel);
    
    subplot(2,3,4);
    imshow ((new_image .^2) .^0.5 , []);
    title('Gaussian filter applied');

end


function MeanFilter(noisyImage, size)

    kernel = ones(size);
    kernel = kernel .* (1/(size^2));
    
    denoisedImage = conv_customized(noisyImage,kernel);
    
    subplot(2,3,5)
    imshow((denoisedImage .^2) .^0.5 , []);
    title('Mean filter applied');
end


function MedianFilter(noisyImage)

    denoisedImage = double(noisyImage);
    
    for i=2:size(noisyImage,1)-1
        for j=2:size(noisyImage,2)-1
            mm = sort([noisyImage(i-1,j),noisyImage(i+1,j),noisyImage(i,j-1),noisyImage(i,j+1)]);
            denoisedImage(i,j) = mm(2);
        end
    end
    
    subplot(2,3,6)
    imshow((denoisedImage .^2) .^0.5 , []);
    title('Median filter applied');
end

