function [ X ] = Fibonacci_Minimization(func,lb,ub)
%UNTITLED Summary of this function goes here
%   Gives minimum of defined function with search bounds


N = 35;
a = min([lb, ub]);
b = max([lb, ub]);
termination_Criteria = 10^-5;


%% Creating Fibonacci Series of required num of iternations
persistent f;
fold=1;
fnew=1;
if (isempty(f))
    
    for i=1:N
        if i==1 || i==2
            f(i)=1;
            continue;
        end
        f(i)=fold+fnew;
        fold=fnew;
        fnew=f(i);
    end
end

%% Actual Fibonacci algorythm
L2=(b-a)*f(N-2)/f(N);
j=2;
while j<N
    if((b-a) <= termination_Criteria)
        break;
    end
        L1=(b-a);
        if L2>L1/2
            anew=b-L2;
            bnew=a+L2;
        else if L2<=L1/2
                anew=a+L2;
                bnew=b-L2;
            end
        end
        k1=func(anew);
        k2=func(bnew);
        if k2>k1
            b=bnew;
            L2=f(N-j)*L1/f(N-j+2);
        else if k2<k1
                a=anew;
                L2=f(N-j)*L1/f(N-(j-2));
            else if k2==k1
                    b=bnew;
                    L2=f(N-j)*[b-a]/f(N-(j-2));
                    j=j+1;
                end
            end
        end
        j=j+1;
    end
    X = (a+b)/2;
    
end

