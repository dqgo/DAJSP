% 新的schedule=[1工件号 2工序号  3机器号 4开工时间 5完工时间 6工厂号 7装配号 8属性(0加工/1装配) 9是否关键块 10UVQ标识 0=U 1=Q 2=V -1=其他 ]
% 返回neighborhoodSign 0是v移动到u之前 1是u移动到v之后  -1是没有移动，即原始解
function fitness=approximate_fitness(nei_schedule,nei_sign,schedule,data,schedule_right,Cmax)
    nei_num=size(nei_sign,1);
    fitness=[];
    if nei_num==0
        fitness=99999;
    else
        for i=1:nei_schedule
            this_sign=nei_sign(i);
            u_schedule=nei_schedule(nei_schedule(:,10)==0,:);l_schedule=nei_schedule(nei_schedule(:,10)==1,:);v_schedule=nei_schedule(nei_schedule(:,10)==2,:);
            if this_sign
                    %如果是u移动到v之后
                    this_Q=[l_schedule;v_schedule;u_schedule];
            else    %如果是v移动到u之前
                    this_Q=[v_schedule;u_schedule;l_schedule];
            end
            this_nei_head_leagth=approximate_head_length(this_Q,nei_schedule,schedule,data,schedule_right,Cmax,u_schedule,l_schedule,v_schedule);
            this_nei_tail_leagth=approximate_tail_length(this_Q,nei_schedule,schedule,data,schedule_right,Cmax,u_schedule,l_schedule,v_schedule);
            this_nei_Cmax=max(this_nei_head_leagth+this_nei_tail_leagth);
            fitness=[fitness;this_nei_Cmax];
        end
    end
end




function this_nei_head_leagth=approximate_head_length(this_Q,nei_schedule,schedule,data,schedule_right,Cmax,u_schedule,l_schedule,v_schedule)
    this_Q_size=size(this_Q,1);
    %第一步 获取第一个的工序的头长，即自己的JP和U之前的MP
    the_first_schedule=this_Q(1,:);
    %先在原schedule中找到u的mp    
    the_same_machine_schedule=schedule(schedule(:,6)==u_schedule(6) & schedule(:,3)==u_schedule(3),:);
    [urow,~]=find(u_schedule(1)==the_same_machine_schedule(:,1));
    if urow==1
        the_first_schedule_head_leagth_1=0;
    else
        MP_u_schedule=the_same_machine_schedule(urow-1,:);
        
    end

end

function 


function head_leagth=find_this_schedule_head_length(schedule,this_schedule)
end

