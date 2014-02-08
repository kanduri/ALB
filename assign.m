function c = assign(x)


global T N C P D PR;
x=x.*x;
x=x';
a=zeros(1,T);
suact=[];
list=zeros(1,T);
assign=zeros(N,T);
flag=zeros(1,T);

%assign the first task to the first station
list(1)=1;
assign(1)=1;
flag(1)=1;
u=C-D(1);
mintime=min(D); %smallest duration of task

%start assigning the remaining
for p=1:N
    flagw=0;
    if p==1
        UACT=u;
    else
        UACT=C;
    end
    j=2;
    while flagw==0
        if j<=T && j~=1
            if list(j)==1 %check if task already assigned
                j=j+1;
                continue;
            elseif flag(j)==1 %check if task in list A
                j=j+1;
                continue;
            elseif P(j,1)==0 %check if no prereq needed
                a(j)=1;
                flag(j)=1;
                j=j+1;
                a(1)=0;
                continue;
            else
                flagt=1;
                for q=1:PR
                    if P(j,q)==0  %check if prereq exists in P matrix
                        a(j)=1;
                        flag(j)=1;
                        j=j+1;
                        %q=1;
                        flagt=1;
                        a(1)=0;
                        break;
                    elseif list(P(j,q))==0 %check if prereq is assigned. reject if not
                        flagt=0;
                        break;
                    elseif a(P(j,q))==1 %check if prereq in list A reject. if yes
                        flagt=0;
                        break;
                    end
                end
                if flagt==0
                    j=j+1;
                    continue;
                end     
            end
        end
        
        wa=zeros(1,T); %make a wieght matrix generated using BFA with values for only list A tasks
        wa=(a.*x).*(ones(1,T)-list);
        
        wa(1)=-100;
            [wt index1]=max(wa);
            if UACT-D(index1)>=0 %if cycle time permits, assign it to assignment matrix, remove from list A, and tick on the assigned list
                assign(p,index1)=1;
                UACT=UACT-D(index1);
                wa(index1)=0;
                list(index1)=1;
                a(index1)=0;
                j=2;
                if UACT<mintime
                    flagw=1;%move to next workstation
                    suact=[suact UACT];
                    
                end
            else
                flagw=1;%move to next workstation
                suact=[suact UACT];
                
            end
        
    end
end
%final output
idle=sum(suact);
c=assign;
suact
list
1:22
end