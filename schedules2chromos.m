% data={1[change_data] 2[job_num] 3[work_num] 4[factory_num] 5[assembly] 6[assembly_data]}
% schedule=[1工件号 2工序号  3机器号 4开工时间 5完工时间 6工厂号 7装配号 8属性(0加工/1装配) 9是否关键块]
function chromos=schedules2chromos(schedules)
    schedules_num=size(schedules,3);
    chromos=cell(schedules_num,3);
    for i=1:schedules_num
        chromos(i,:)=schedule2chromo(schedules(:,:,i));
    end
end


% function chromo=schedule2chromo(schedule,data)
%     chromo=cell(1,3);
%     schedule_sort=sortrows(schedule,[8,4]);
%     for i=1:(size(schedule_sort,1)-size(data{6},2))
%          chromo{1}(schedule_sort(i,1))=schedule_sort(i,6);
%          chromo{2}(i)=schedule_sort(i,1);
%     end
%     for i=size(schedule_sort,1)+1:size(data{5})
%         chromo{3}=schedule_sort(i,7);
%     end
% end

function chromo=schedule2chromo(schedule)
    chromo=cell(1,3);
    schedule=sortrows(schedule,4);
    schedule_withno_assembly=schedule(schedule(:,8)==0,:);
    % schedule_withno_assembly_sort=sortrows(schedule_withno_assembly,4);
    num_schedule_withno_assembly=size(schedule_withno_assembly,1);
    for i=1:num_schedule_withno_assembly
        chromo{1}(schedule_withno_assembly(i,1))=schedule_withno_assembly(i,6);
        chromo{2}(i)=schedule_withno_assembly(i,1);
    end
    schedule_only_assembly=schedule(schedule(:,8)==1,:);
    chromo{3}=schedule_only_assembly(:,7)';
end