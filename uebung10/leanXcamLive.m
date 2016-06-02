clear all;  close all;  clc;

ImageCounter = 1;

figure(1);hold on;

k=[];
set(gcf,'keypress','k=get(gcf,''currentchar'');');

while 1 
    
    try
        %first we trigger the cgi script in order to have the leanXcam save
        %a new image
        websave('empty.gif','http://192.168.1.10/cgi-bin/cgi');
        %the return value will not be an image, so the call fails (-> catch)!!
    catch
        
    end
    %nevertheless the image is available (url works :-)
    
    try 
        websave('image.gif','http://192.168.1.10/image.gif');
        Image=imread('image.gif');
    catch
    end
    
    imshow(Image);
    ImageCounter = ImageCounter+1;
    title(strcat('image index: ', num2str(ImageCounter), '     (hit e-key to stop)'));
    
    if ~isempty(k)
        if strcmp(k,'e'); 
            break; 
        end;
        if strcmp(k,'p'); 
            pause; k=[]; 
        end;
    end
    
    pause(0.2);
end