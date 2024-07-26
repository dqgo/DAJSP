function MAINSTART()
    n = 5;
    popu = 10;
    this = zeros(1, n);
    [data] = changeDataFunction();

    for i = 1:n
        [chromos] = createInitialPopus(popu, data);
        % temp1=MAIN(chromos,popu);
        % this(1,i)=temp1;
        % 在当前时间内选择可开始且加工时间最短的任务进行加工的原则。
        temp2 = MAINGREEDY(chromos, popu);
        this(1, i) = temp2;
    end

    disp(this);
    load splat
    sound(y, Fs)
    beep on
    beep
end
