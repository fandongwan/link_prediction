function [ thisauc,precision ] = CN( train, test )
%% ����CNָ�겢����AUCֵ
    sim = train * train;        
    % ���ƶȾ���ļ���
    thisauc = CalcAUC(train,test,sim, 10000);  
    % ���⣬�����ָ���Ӧ��AUC
    
     precision= CalcPrecision( train, test, sim, 100 );
end
