% data={1[change_data] 2[job_num] 3[work_num] 4[factory_num] 5[assembly] 6[assembly_data]}
% schedule=[1工件号 2工序号  3机器号 4开工时间 5完工时间 6工厂号 7装配号 8属性(0加工/1装配) 9是否关键块]
% if 8==1  schedule=[-1 -1 -1 4开工时间 5完工时间 -1 7装配号 8属性(1装配) 9是否关键块]
function chromo = TS4DAJSP(chromo, iterate_num, threshold, data, tubeSearchLength)
    % 初始化
    % job_num=data{2};work_num=data{3};factory_num=data{4};assembly_num=max(data{5});
    % best_chromo=cell(1,3);
    best_fitness = 9999;
    tubeList = struct('tube', {}, 'tubeSearchLength', {});
    previous_fitness = best_fitness;
    % temp1=zeros(1,iterate_num);
    % temp2=zeros(1,iterate_num);    %???
    for i = 1:iterate_num
        isbreak = 0;
        %生成解的邻域解
        schedule = createSchedule(data, chromo);
        Cmax = max(schedule(:, 5));
        schedule_right = right_schedule(schedule, Cmax, data);
        index = find_rows_in_schedule(schedule, schedule_right);
        schedule(index, 9) = 1; % 这里1表示的是关键工序
        [keyblock_schedule, index] = find_keyblock(schedule);
        % 对每个关键块调度进行标注
        % 对FA作业重新分配到其他工厂，对PS进行N5，对AS进行N1
        [nei_chromos] = create_schedule(schedule, index, keyblock_schedule, chromo, data);

        if size(nei_chromos, 1) == 0
            isbreak = 1; break;
        end

        fitness = calcFitness(nei_chromos, data);
        [fitness, index] = sortrows(fitness);

        if best_fitness > fitness(1)
            best_fitness = fitness(1);
            best_chromo = nei_chromos(index(1), :);
        end

        % 计算适应度是否有改变，若无改变则连续计数器加一，否则重置计数器
        if best_fitness == previous_fitness
            unchanged_count = unchanged_count + 1;
        else
            unchanged_count = 0;
        end

        if unchanged_count >= threshold
            % disp('连续没有变动，跳出循环');
            % disp(i);
            break;
        end

        previous_fitness = best_fitness; % 更新上一次的适应度

        for j = 1:size(nei_chromos, 1)
            thisChromoIsin = false;
            Q = nei_chromos(j, :);

            if ~isempty(tubeList)
                % 按适应度依次检查染色体是否在禁忌表内
                for k = 1:numel(tubeList)

                    if isequal(Q, tubeList(k).tube)
                        % 在禁忌表内的话检查是否满足特赦策略
                        if fitness(index(j)) <= best_fitness
                            chromo = nei_chromos(index(j), :);
                            tubeList(end + 1).tubeSearchLength = tubeSearchLength;
                            tubeList(end).tube = Q;
                        end

                        thisChromoIsin = true;
                        break;
                    end

                end

            end

            if ~thisChromoIsin
                % 不在禁忌表内
                chromo = nei_chromos(index(j), :);
                tubeList(end + 1).tubeSearchLength = tubeSearchLength;
                tubeList(end).tube = Q;
                break;
            end

        end

        %更新禁忌表
        for k = numel(tubeList):-1:1
            tubeList(k).tubeSearchLength = tubeList(k).tubeSearchLength - 1;
        end

        for k = numel(tubeList):-1:1

            if all(tubeList(k).tubeSearchLength == -1)
                tubeList(k) = [];
            end

        end

        temp1(i) = best_fitness;
        temp2(i) = fitness(j, :);
    end

    % figure;
    % plot(1:size(temp2,2),temp1);% 最优的曲线
    % figure;
    % plot(1:size(temp2,2),temp2);% 选择的曲线
    if isbreak == 0
        chromo = best_chromo;
    end

end
