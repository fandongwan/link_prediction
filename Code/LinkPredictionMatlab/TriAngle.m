function [ thisauc ] = TriAngle( train, test,lamda)
%%%%%�ڽӾ��������ݵĶԽ�Ԫ�����ʾ���Ǵ�����һ���ڵ���������������ֻص�������
%%%%%��·����,Ҳ���ǰ����ö���������ε�����������
tri=train*train*train;
tri=diag(tri)./2;

%�����ڵ�������������ӽ����Ч������˲
% tri=repmat(tri,1,size(tri,1));
% sim=tri+tri';

%�����ڵ�������������˽��
tri_mat=tri*tri';
sim = lamda*tri_mat;
thisauc = CalcAUC(train,test,sim, 10000);


