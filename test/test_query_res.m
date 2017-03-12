netStruct = load('../data/resnet52_2stream_drop0.9/net-epoch-75.mat');
net = dagnn.DagNN.loadobj(netStruct.net);
net.mode = 'test' ;
net.move('gpu') ;
net.conserveMemory = false;
im_mean = net.meta(1).normalization.averageImage;
%im_mean = imresize(im_mean,[224,224]);
p = dir('/home/zzd/re_ID/market1501/query/*jpg');
ff = zeros(numel(p),2048);
for i = 1:numel(p)
   disp(i);
   str = strcat('/home/zzd/re_ID/market1501/query/',p(i).name);
   oim = imresize(imread(str),[224,224]); 
   f = getFeature2(net,oim,im_mean,'data','pool5');
   f = reshape(f,1,2048);
   f = f./sqrt(sum(f.^2));%normal
   ff(i,:) = f;
end
save('resnet_query_sample1:4.mat','ff','-v7.3');
