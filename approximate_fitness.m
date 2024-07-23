% 新的schedule=[1工件号 2工序号  3机器号 4开工时间 5完工时间 6工厂号 7装配号 8属性(0加工/1装配) 9是否关键块 10UVQ标识 0=U 1=Q 2=V -1=其他 ]
% 返回neighborhoodSign 0是v移动到u之前 1是u移动到v之后  -1是没有移动，即原始解
function fitness=approximate_fitness(nei_schedule,nei_sign)
    nei_num=size(nei_sign,1);
    if nei_num=0
        fitness=99999;
    else
        for i=1:nei_schedule
            this_sign=nei_sign(i);

        end
    end
end