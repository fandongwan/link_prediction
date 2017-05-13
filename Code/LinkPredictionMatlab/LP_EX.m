function [  thisauc ] = LP_EX( train, test )
%% ����LPָ�겢����AUCֵ
    sim = train*train;    
    % ����·��
    theta=0.01;
   
    sim = exp(-2^2/(2*theta^2))*sim + exp(-3^2/(2*theta^2)) * (train*train*train);
    
    % ����·�� + ����������·��
    thisauc = CalcAUC(train,test,sim, 10000);  
    % ���⣬�����ָ���Ӧ��AUC
end
