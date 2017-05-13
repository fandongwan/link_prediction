function [  thisauc ] = RWR( train, test, lambda )
%����train����������train set��δ���ߵĽڵ�Ե� RWR ���ƶ�
    train = train + train';
    deg = sum(train,2);
    deg = repmat(deg,[1,size(train,2)]);
    train = train ./ deg; clear deg;    %��ת�ƾ���
      
    
    I = sparse(eye(size(train,1)));
%     % ����ÿ���ڵ㣬�����������ڵ�֮���RWR���ƶ�
%     for nodei = 1:size(train,1)
%        sim(nodei,:) =  (1 - lambda) * inv(I- lambda * train') * I(:, nodei);
%     end
%     sim = sim+sim';
    sim = (1 - lambda) * inv(I- lambda * train') * I;
    sim = sim+sim';

%     lastsim = zeros(size(train,1),size(train,2)); % ��������
%     thissim = eye(size(train,1));
%     while (sum(abs(thissim - lastsim))>0.00000000000001)
%         lastsim = thissim;
%         thissim = (1-lambda)*I + lambda * train' * lastsim;
%     end
%     thissim = thissim + thissim';
    
    train = spones(train);   
    sim = triu(sim,1);
    sim = sim - sim.*train;
    %���⣬����AUC
    thisauc = CalcAUC(train,test,sim);
end
