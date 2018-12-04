  %%
clc;
clear all;
close all;
I = uigetfile( '*', 'Select an image For Recogination' );
image1=I;
tic;
X=imread(I)
if (length(size(X))==3)
    X=X(:,:,1);
end
X=imresize(X,[256 256]);
XX=X;
X=im2double(X);
level=5;wname='db4';
[wc,s] = wavedec2(X,level,wname);% step 1 decomposition
for k=1:1:level
a{k} = appcoef2(wc,s,wname,k);         
h{k} = detcoef2('h',wc,s,k);           
v{k} = detcoef2('v',wc,s,k);           
d{k} = detcoef2('d',wc,s,k);  
end
for k=1:1:level
ra{k} = wrcoef2('a',wc,s,wname,k);
rh{k} = wrcoef2('h',wc,s,wname,k);
rv{k} = wrcoef2('v',wc,s,wname,k);
rd{k} = wrcoef2('d',wc,s,wname,k);
end
thresh='rigrsure'; % step 2 to evaluate threshold value
for k=1:1:level
thr_h{k} = thselect(rh{k},thresh);% for adaptive use this function for evaluate threshold for each detailed coefficient
thr_d{k} = thselect(rd{k},thresh);
thr_v{k} = thselect(rv{k},thresh);
end
%%  
thr_h = cell2mat(thr_h);thr_v=cell2mat(thr_v);thr_d=cell2mat(thr_d);
thr = [thr_h; thr_d; thr_v];
thr=thr;
[waveletout,wc_comp,s_comp,perf0,perfL2] = wdencmp('lvd',X,wname,level,thr,'s'); % step 3 for reconstruction
figure (1)
imagesc(X); colorbar;colormap('gray'); title('Original image')
figure (2)
imagesc(waveletout);colorbar;colormap('gray'); title('Image after applying wavelets ')
%% fcm clustering
dummy=waveletout;
data = im2double(dummy);
[rr, cc]=size(dummy);
dataa=data;
data=data(:);
[center,U,obj_fcn] = fcm(data,5);% fuzzy clustering
hold on;
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
index3 = find(U(3,:) == maxU);
index4 = find(U(4,:) == maxU);
index5 = find(U(5,:) == maxU);
data(index1,1)=0;
data(index2,1)=.1;
data(index3,1)=.2; 
data(index4,1)=.3; 
data(index5,1)=.4;
hold off;
fuzzydata = reshape(data,rr,cc);     
figure(88)
imagesc(fuzzydata); title('Image after fuzzy clustering')
 BW2 = edge(fuzzydata,'canny');
 figure, imshow(BW2)
 title('edge detection using canny edge filter')
 L = watershed(BW2,4); 
        rgb = label2rgb(L,'jet',[.5 .5 .5]);
        figure, imshow(rgb,'InitialMagnification','fit')
        title('Watershed transform')