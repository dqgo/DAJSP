% 构造邻域
% schedule=[1工件号 2工序号  3机器号 4开工时间 5完工时间 6工厂号 7装配号 8属性(0加工/1装配) 9是否关键块]
% if 8==1  schedule=[-1 -1 -1 4开工时间 5完工时间 -1 7装配号 8属性(1装配) 9是否关键块]
% data={1[change_data] 2[job_num] 3[work_num] 4[factory_num] 5[assembly] 6[assembly_data]}
% 对FA作业重新分配到其他工厂，对PS进行N5，对AS进行N1
% 对FA进行操作时，直接操作chromo，不用管schedule
% 对PS进行操作时，对基于机器的编码进行N5邻域结构之后，整理，输出nei_chromo
% 对AS进行操作时，不用管FA PS 只对schedule中only_assembly_schedule进行操作，并且单独拉出来，不参与后续的解码，节省点时间
function [nei_chromos] = create_schedule(schedule, key_index, keyblock_schedule, chromo, datatemp)
    nei_chromos = [];
    keyblock_num = size(keyblock_schedule, 2);

    % FA----------------------------
    % 首先要知道关键上的工件号和工厂号
    factory_num = datatemp{4};
    job_index = []; factory_index = [];
    % job_index=keyblock_schedule(:,1);
    for i = 1:keyblock_num
        this_block = keyblock_schedule{i};

        for j = 1:size(this_block, 1)
            this_scheudle = this_block(j, :);

            if this_scheudle(1) ~= -1
                % job_index=[job_index,this_scheudle(1)];
                % factory_index=[factory_index,this_scheudle(6)];
                this_job = this_scheudle(1); this_factory = this_scheudle(6);
                rand_factory = randperm(factory_num, 1);

                while (rand_factory == this_factory)
                    rand_factory = randperm(factory_num, 1);
                end

                this_nei_chromo = chromo;
                this_nei_chromo{1}(job_index) = rand_factory;
                nei_chromos = [nei_chromos; this_nei_chromo];
            end

        end

    end

    % PS---------------------------
    % 首先把schedule中的关键块拉出来，并且记录行号，然后执行交换移动 如果大小是2直接交换
    % tail_data=[schedule_right(1:5),Cmax-schedule_right(5)];
    for i = 1:keyblock_num
        this_nei_chromo = chromo;
        this_nei_schedule = schedule(schedule(:, 8) == 0, :);
        this_keyblock = keyblock_schedule{i};
        this_keyblock_index = key_index{i};

        if this_keyblock_index(1) < size(chromo{2}, 2)

            if size(this_keyblock, 1) == 2
                u_schedule = this_keyblock(1, :); v_schedule = this_keyblock(2, :);
                isOk = can_V2Uper(u_schedule, v_schedule, schedule);

                if isOk
                    this_nei_schedule(this_keyblock_index, :) = V2Uper(u_schedule, v_schedule);
                    this_nei_chromo{2} = this_nei_schedule(:, 1)';
                    nei_chromos = [nei_chromos; this_nei_chromo];
                end

            else

                this_nei_schedule = schedule(schedule(:, 8) == 0, :);
                u_schedule = this_keyblock(1, :); v_schedule = this_keyblock(2, :);
                isOk = can_V2Uper(u_schedule, v_schedule, schedule);

                if isOk
                    this_nei_schedule(this_keyblock_index(1:2), :) = V2Uper(u_schedule, v_schedule);
                    this_nei_chromo{2} = this_nei_schedule(:, 1)';
                    nei_chromos = [nei_chromos; this_nei_chromo];
                end

                this_nei_schedule = schedule(schedule(:, 8) == 0, :);
                u_schedule = this_keyblock(end - 1, :); v_schedule = this_keyblock(end, :);
                isOk = can_V2Uper(u_schedule, v_schedule, schedule);

                if isOk
                    this_nei_schedule(this_keyblock_index(end - 1:end), :) = V2Uper(u_schedule, v_schedule);
                    this_nei_chromo{2} = this_nei_schedule(:, 1)';
                    nei_chromos = [nei_chromos; this_nei_chromo];
                end

            end

        end

    end

    % AS---------------------------No for Greedy Algorithm
    % 只对schedule中only_assembly_schedule进行操作
    % only_assembly_schedule=schedule(schedule(:,8)==1,:);
    % assembly_num=size(only_assembly_schedule,1);
    % for i=1:assembly_num-1
    %     AS=chromo{3};
    %     temp=AS(i);AS(i)=AS(i+1);AS(i+1)=temp;
    %     this_chromo={chromo{1} chromo{2} AS};
    %     nei_chromos=[nei_chromos;this_chromo];
    % end
end

% tail_data=[schedule_right(1:5),Cmax-schedule_right(5)];
function isOK = can_V2Uper(u_schedule, v_schedule, schedule)
    % if r(jpv)<=r(u)+Pu    is OK
    index = ismember(schedule(1:2), [v_schedule(1), v_schedule(2) - 1], 'rows');
    isOK = false;

    if any(index) %如果存在
        jpv_schedule = schedule(index, :);
        jpv_head_leagth = jpv_schedule(4);
    else
        jpv_head_leagth = 0;
    end

    pu = u_schedule(5) - u_schedule(4);

    if jpv_head_leagth <= u_schedule(4) + pu
        isOK = true;
    end

end

function new_schedule = V2Uper(u_schedule, v_schedule)
    v_schedule(4:5) = [u_schedule(4), u_schedule(4) + v_schedule(5) - v_schedule(4)];
    u_schedule(4:5) = [v_schedule(5), v_schedule(5) + u_schedule(5) - u_schedule(4)];
    new_schedule = [v_schedule; u_schedule];
end
