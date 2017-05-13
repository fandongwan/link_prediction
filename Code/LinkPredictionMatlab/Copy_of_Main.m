%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                    ��·Ԥ�� ---���������Ե���·Ԥ���㷨                       %%%%%%%%%%
%%%%%%%%%%           (1)���ھֲ��ṹ (2)����·�� (3)����������ߵ��㷨 (4)��������        %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%    ��ÿ�����ݼ���      step-1 ����ѵ�����Ͳ��Լ�                              %%%%%%%%%%
%%%%%%%%%%                       step-2 ���ڴ˻������������㷨�ľ�����AUC��              %%%%%%%%%%
%%%%%%%%%%                       �ظ�ǰ����������100�� ��ȡƽ��ֵ�ͷ���                  %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% �����趨���� �趨ѵ�����ı��� �� ����ʵ��Ĵ���
ratioTrain = 0.9;       %ѵ��������
numOfExperiment = 100;  %����ʵ��Ĵ���
%% �õ������ݼ�����
dataname = strvcat('USAir','NS','PB','Yeast','Celegans','FWFB','Power','Router'); 
datapath = 'D:\data\';      %���ݼ����ڵ�·��
%% ��·Ԥ�����
for ith_data = 1:length(dataname)                                   %����ÿһ������
    thisdatapath = strcat(datapath,dataname(ith_data,:),'.txt');    %��ith��data��·��
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%% test data 
%     thisdatapath = 'nettest.txt';
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    linklist = load(thisdatapath);              % �������ݣ��ߵ�list
    net = FormNet(linklist); clear linklist;    % ���ݱߵ�list�����ڽӾ���
    net = triu(net,1);                          % ������������ĶԳ��ԣ�ȡ�����Ǿ����Խ�ʡ�ռ�
    %%% step-1 ����ѵ�����Ͳ��Լ���ÿ�������� count �ζ���ʵ�飬����ÿ�εĽ�����������У����Լ����ֵ�ͷ���
    aucOfallPredictor = []; PredictorsName = [];
    for ith_experiment = 1:numOfExperiment
        %---����ѵ�����Ͳ��Լ�
        [train, test] = DivideNet(net,ratioTrain);  %���ص�train��testҲ���������Ǿ���
        ithAUCvector = []; Predictors = [];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% begin test*********************************************
        train = zeros(size(train)); test = train; train(1,2)=1; train(2,1)=1; train(4,1)=1; train(1,4)=1; train(2,3)=1; train(3,2)=1;
        train(2,5)=1; train(5,2)=1; train(4,5)=1; train(5,4)=1; test(3,5)=1; test(5,3)=1; train(1,5)=1; train(5,1)=1;
        train =sparse(triu(train)); test = sparse(triu(test));
        %%%%%%%%%% end test **********************************************
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %---����train set����test set��nonexistent set�����нڵ�����ߵĿ�����
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% �����ǻ���CN���������㷨
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = CN(train, test); % CN
            Predictors = [Predictors 'CN  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = Salton(train, test); %Salton
            Predictors = [Predictors 'Salton  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = Jaccard(train, test); %Jaccard
            Predictors = [Predictors 'Jaccard  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = Sorenson(train, test); %Sorenson
            Predictors = [Predictors 'Sorenson  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = HPI(train, test); %HPI
            Predictors = [Predictors 'HPI  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = HDI(train, test); %HDI
            Predictors = [Predictors 'HDI  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LHN(train, test); %LHN
            Predictors = [Predictors 'LHN  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = AA(train, test); %AA
            Predictors = [Predictors 'AA  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = RA(train, test); %RA
            Predictors = [Predictors 'RA  ']; ithAUCvector = [ithAUCvector tempauc];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ƫ�������������㷨
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = PA(train, test); %PA
            Predictors = [Predictors 'PA  ']; ithAUCvector = [ithAUCvector tempauc];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% �ֲ����ر�Ҷ˹ģ��
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = LNBCN(train, test); 
            Predictors = [Predictors 'LNBCN  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LNBAA(train, test); 
            Predictors = [Predictors 'LNBAA  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LNBRA(train, test); 
            Predictors = [Predictors 'LNBRA  ']; ithAUCvector = [ithAUCvector tempauc];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ����·����������ָ��
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = LocalPath(train, test, 0.0001);
            Predictors = [Predictors 'LocalPath  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = Katz(train, test, 0.01);
            Predictors = [Predictors 'Katz_0.01  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = Katz(train, test, 0.001);
            Predictors = [Predictors 'Katz_0.001  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LHNII(train, test, 0.9);
            Predictors = [Predictors 'LHNII_0.9  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LHNII(train, test, 0.95);
            Predictors = [Predictors 'LHNII_0.95  ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LHNII(train, test, 0.99);
            Predictors = [Predictors 'LHNII_0.99  ']; ithAUCvector = [ithAUCvector tempauc];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ����������ߵ�������ָ��
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = ACT(train, test); %average commute time
            Predictors = [Predictors 'ACT ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = CosPlus(train, test); %cos+ based on Laplacian matrix
            Predictors = [Predictors 'CosPlus ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = RWR(train, test, 0.85); %Random walk with restart
            Predictors = [Predictors 'RWR_0.85 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = RWR(train, test, 0.95); %Random walk with restart
            Predictors = [Predictors 'RWR_0.95 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = SimRank(train, test); %simRank! not completed
            Predictors = [Predictors 'SimRank ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LRW(train, test, 3); %Local random walk
            Predictors = [Predictors 'LRW_3 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LRW(train, test, 4); %Local random walk
            Predictors = [Predictors 'LRW_4 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = LRW(train, test, 5); %Local random walk
            Predictors = [Predictors 'LRW_5 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = SRW(train, test, 3); %Superposed random walk
            Predictors = [Predictors 'SRW_3 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = SRW(train, test, 4); %Superposed random walk
            Predictors = [Predictors 'SRW_4 ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = SRW(train, test, 5); %Superposed random walk
            Predictors = [Predictors 'SRW_5 ']; ithAUCvector = [ithAUCvector tempauc];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% ����������ָ��
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tempauc = MFI(train, test); %Matrix forest Index
            Predictors = [Predictors 'MFI ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = TSCN(train, test, 1); %Transfer similarity - Common Neighbor
            Predictors = [Predictors 'TSCN ']; ithAUCvector = [ithAUCvector tempauc];
        tempauc = TSRWR(train, test, 1); %Transfer similarity - Random walk with restart
            Predictors = [Predictors 'TSRWR ']; ithAUCvector = [ithAUCvector tempauc];
            
        aucOfallPredictor = [aucOfallPredictor; ithAUCvector]; PredictorsName = Predictors;
    end
    %% write the results for this data (dataname(ith_data,:))
    avg_auc = mean(aucOfallPredictor,1); var_auc = var(aucOfallPredictor,1);
    respath = strcat(datapath,'result\',dataname(ith_data,:),'_res.txt'); 
    dlmwrite(respath,[PredictorsName; aucOfallPredictor; avg_auc; var_auc], ' ');
end
