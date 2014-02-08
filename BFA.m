clc
global T N C P D PR;

P=csvread('data.csv');
D=P(:,1); %duration of each task
P(:,1)=[]; %immediate predecessors of the task
[a1,b1]=size(P);
T=a1; %no. of tasks
PR=b1;
C=180; %cycle time
a2=(sum(D))/C; 
%N=1+a2-rem(a2,1); %no. of workstations
N=8;
%declared input data

%BFA Begins
iter=15;
pop=3000;
dim=T;
cv=[];
ibest=[];
population=[];
for p=1:pop
    particle(p).x= C*(rand(dim,1));
    population=[population particle(p).x];
    particle(p).c= cost(population(:,p));
    cv=[cv particle(p).c];
end
[least index]=min(cv);
gmin=least;
ibest=[ibest least];
ibestx=population(:,index);
gminx=population(:,index);
%BFA trail solutions declared
%BFA begins here
for j=1:iter
    %deleting the worst 50 percent elements
    for p=1:(pop/2)
        [most imost]=max(cv);
        population(:,imost)=[];
        cv(imost)=[];
    end
    cv=[];
    %copying/reproducing the fittest five elements
    population=[population population];
    %make the bacteria tumble and run
    population=population+(C*rand(dim,pop));
    for p=1:pop
        particle(p).c= cost(population(:,p));
        cv=[cv particle(p).c];
    end
    [least index]=min(cv);
    ibest=[ibest least];
    if(least<gmin)
        gmin=[gmin least];
        gminx=population(:,index);
    end
    
end
%final output 
efficiency=(1-least)*100  %efficiency
assignment=assign(population(:,index))    %final assignment matrix
%P
%D
% ibestx=population(:,index);
% gminx;
% plot(ibest);
% plot(gmin);        