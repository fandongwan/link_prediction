function[predicted_label,thisauc,decision_values,svmStruct]=svmGeneral(train,test)

train=full(train);
test=full(test);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͬ�ھ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cnFeatTr=train*train;
cnFeatTr=cnFeatTr(:);

cnFeatTe=test*test;
cnFeatTe=cnFeatTe(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ڵ���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

degreeFeatTr=sum(train,2);
degreeFeatTr=repmat(degreeFeatTr',size(train,1),1)+repmat(degreeFeatTr,1,size(train,1));
degreeFeatTr=degreeFeatTr(:);
degreeFeatTr=degreeFeatTr-cnFeatTr;

degreeFeatTe=sum(test,2);
degreeFeatTe=repmat(degreeFeatTe',size(test,1),1)+repmat(degreeFeatTe,1,size(test,1));
degreeFeatTe=degreeFeatTe(:);
degreeFeatTe=degreeFeatTe-cnFeatTe;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PA����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

paFeatTr=sum(train,2);
paFeatTr=paFeatTr*paFeatTr';
paFeatTr=paFeatTr(:);

paFeatTe=sum(test,2);
paFeatTe=paFeatTe*paFeatTe';
paFeatTe=paFeatTe(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%katz����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

katzFeatTr=train+train*train;
katzFeatTr=katzFeatTr(:);

katzFeatTe=test+test*test;
katzFeatTe=katzFeatTe(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AA����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aaFeatTr=train./repmat(log(sum(train,2)),[1,size(train,1)]);
aaFeatTr(isnan(aaFeatTr)) = 0; 
aaFeatTr(isinf(aaFeatTr)) = 0;
aaFeatTr=train*aaFeatTr;
aaFeatTr=aaFeatTr(:);

aaFeatTe=test./repmat(log(sum(test,2)),[1,size(test,1)]);
aaFeatTe(isnan(aaFeatTe)) = 0; 
aaFeatTe(isinf(aaFeatTe)) = 0;
aaFeatTe=test*aaFeatTe; 
aaFeatTe=aaFeatTe(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%simIdx����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nodeNum=size(train,1);
theta=1;
simScoreFeatTr=zeros(size(train,1),size(train,2));
for i=2:3
    simMat=train^i;
    norm=1;
    for j=2:i
        norm=norm*(nodeNum-j);
    end
%     simScoreFeat=simScoreFeat+simMat./((i-1)*norm);
    simScoreFeatTr=simScoreFeatTr+simMat./(exp(-i^2/(2*theta^2))*norm);
end

simScoreFeatTr(isnan(simScoreFeatTr)) = 0; 
simScoreFeatTr(isinf(simScoreFeatTr)) = 0;
simScoreFeatTr=simScoreFeatTr(:);

nodeNum=size(test,1);
theta=1;
simScoreFeatTe=zeros(size(test,1),size(test,2));
for i=2:3
    simMat=test^i;
    norm=1;
    for j=2:i
        norm=norm*(nodeNum-j);
    end
%     simScoreFeat=simScoreFeat+simMat./((i-1)*norm);
    simScoreFeatTe=simScoreFeatTe+simMat./(exp(-i^2/(2*theta^2))*norm);
end

simScoreFeatTe(isnan(simScoreFeatTe)) = 0; 
simScoreFeatTe(isinf(simScoreFeatTe)) = 0;
simScoreFeatTe=simScoreFeatTe(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ڵ���������������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
triFeatTr=train*train*train;
triFeatTr=diag(triFeatTr)./2;
triFeatTr=triFeatTr*triFeatTr';

triFeatTe=test*test*test;
triFeatTe=diag(triFeatTe)./2;
triFeatTe=triFeatTe*triFeatTe';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ڵ��ı�����������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recFeatTr=train*train*train*train;
recFeatTr=diag(recFeatTr);
degreeFeat=train*train;
degreeFeat=diag(degreeFeat);

for i=1:size(train)
    recFeatTr(i)=0.5*(recFeatTr(i)-degreeFeat(i));
end

recFeatTr=recFeatTr'*recFeatTr;

recFeatTe=test*test*test*test;
recFeatTe=diag(recFeatTe);
degreeFeat=test*test;
degreeFeat=diag(degreeFeat);

for i=1:size(test)
    recFeatTe(i)=0.5*(recFeatTe(i)-degreeFeat(i));
end

recFeatTe=recFeatTe'*recFeatTe;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%ѵ������/������������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

featTr=[cnFeatTr degreeFeatTr paFeatTr aaFeatTr katzFeatTr simScoreFeatTr];

featTe=[cnFeatTe degreeFeatTe paFeatTe aaFeatTe katzFeatTe simScoreFeatTe];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ѵ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labelTr=train;
% labelTr=diagDel(labelTr);
labelTr=labelTr(:);

                        %%%%%%%������%%%%%%%
                        
indexPos = find(labelTr==1);

labelTr_pos=ones(length(indexPos),1);
featTr_pos=zeros(length(indexPos),size(featTr,2));

for i=1:length(indexPos)
   featTr_pos(i,:)=featTr(indexPos(i),:);
end

                       %%%%%%%������%%%%%%%

indexNeg = find(labelTr==0);


labelTr_neg=zeros(length(indexNeg),1);
featTr_neg=zeros(length(indexNeg),size(featTr,2));

for i=1:length(indexNeg)
   featTr_neg(i,:)=featTr(indexNeg(i),:);
end

                      %%%%%%%����ѵ������%%%%%%%
label_tr=[labelTr_pos;labelTr_neg];
feat_tr=[featTr_pos;featTr_neg];

                     %%%%%%%ѵ��������һ��%%%%%%%
% [featTrNorm,mu,sigma] = featureNormalize(feat_tr);
featTrNorm=(feat_tr-repmat(min(feat_tr),size(feat_tr,1),1))/(max(feat_tr)-min(feat_tr));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
labelTe=test;
% labelTe=diagDel(labelTe);
labelTe=labelTe(:);

                       %%%%%%%������%%%%%%%
                       
indexPos = find(labelTe==1);

labelTe_pos=ones(length(indexPos),1);
featTe_pos=zeros(length(indexPos),size(featTe,2));

for i=1:length(indexPos)
   featTe_pos(i,:)=featTe(indexPos(i),:);
end
 
                      %%%%%%%������%%%%%%%
                      
indexNeg = find(labelTe==0);


labelTe_neg=zeros(length(indexNeg),1);
featTe_neg=zeros(length(indexNeg),size(featTe,2));

for i=1:length(indexNeg)
   featTe_neg(i,:)=featTe(indexNeg(i),:);
end


                    %%%%%%%���ղ�������%%%%%%%
                    
label_te=[labelTe_pos;labelTe_neg];
feat_te=[featTe_pos;featTe_neg];

                    %%%%%%%����������һ��%%%%%%%
                    
% [featTeNorm,mu,sigma] = featureNormalize(feat_te);
featTeNorm=(feat_te-repmat(min(feat_te),size(feat_te,1),1))/(max(feat_te)-min(feat_te));

% featTeNorm = zeros(size(feat_te,1),size(feat_te,2));
% m=size(feat_te,1);
% for i=1:m
% 	featTeNorm(i,:) = feat_te(i,:)-mu;
% end
% 
% for i=1:m
% 	featTe(i,:)=feat_te(i,:)./sigma;
% end

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 svmStruct = svmtrain(label_tr,featTrNorm,'-h 0' );
 [predicted_label, thisauc, decision_values]=svmpredict(label_te,featTeNorm,svmStruct);
  
%%%%%%%Ԥ��׼ȷ�ȣ���θ�Ϊaucֵ��%%%%%%%
% thisauc = sum(label_te== C)/size(label_te,1);



