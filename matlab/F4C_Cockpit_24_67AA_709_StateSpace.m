function F4C_Cockpit_24_67AA_709_StateSpace()
% matrices loaded from workspace

dt = 0.05;
x = [0;0;0;0];

fig = uifigure('Name','F-4C Cockpit','Color',[1 1 1],'Position',[100 100 700 500]);

uGauge = uigauge(fig,'circular','Position',[20 350 120 120],'Limits',[-20 150]);
uilabel(fig,'Position',[50 340 80 20],'Text','u (m/s)','HorizontalAlignment','center');

wGauge = uigauge(fig,'circular','Position',[160 350 120 120],'Limits',[-40 10]);
uilabel(fig,'Position',[190 340 80 20],'Text','w (m/s)','HorizontalAlignment','center');

qGauge = uigauge(fig,'circular','Position',[300 350 120 120],'Limits',[-0.3 0.3]);
uilabel(fig,'Position',[330 340 80 20],'Text','q (rad/s)','HorizontalAlignment','center');

tGauge = uigauge(fig,'circular','Position',[440 350 120 120],'Limits',[-0.6 0.6]);
uilabel(fig,'Position',[470 340 80 20],'Text','theta (rad)','HorizontalAlignment','center');

elevSlider = uislider(fig,'Position',[20 280 200 3],'Limits',[0 100],'Value',50);
uilabel(fig,'Position',[20 300 100 20],'Text','Elevator');

ax = uiaxes(fig,'Position',[500 100 180 180]);
ax.XTick=[]; ax.YTick=[]; ax.Box='off';
ax.XColor='none'; ax.YColor='none';
hold(ax,'on');
ang = linspace(0,2*pi,100);
fill(ax,cos(ang),sin(ang),[0.4 0.7 1],'EdgeColor','none');
hGround = fill(ax,cos(ang),sin(ang),[0.55 0.35 0.15],'EdgeColor','none');
hLine = plot(ax,[-1 1],[0 0],'w-','LineWidth',2);
plot(ax,[-0.3 -0.05],[0 0],'y-','LineWidth',3);
plot(ax,[0.05 0.3],[0 0],'y-','LineWidth',3);
plot(ax,cos(ang),sin(ang),'k-','LineWidth',3);
axis(ax,'equal'); xlim(ax,[-1.2 1.2]); ylim(ax,[-1.2 1.2]);

runBtn = uibutton(fig,'push','Text','Run','Position',[20 100 100 30]);
stopBtn = uibutton(fig,'push','Text','Stop','Position',[140 100 100 30]);

SimTimer = [];

runBtn.ButtonPushedFcn = @(~,~) startSim();
stopBtn.ButtonPushedFcn = @(~,~) stopSim();

    function startSim()
        x = [0;0;0;0];
        SimTimer = timer('ExecutionMode','fixedRate','Period',dt,...
            'TimerFcn',@(~,~) stepSim());
        start(SimTimer);
    end

    function stepSim()
        u_elev = (elevSlider.Value-50)/50*0.2;
        xdot = evalin('base','A')*x + evalin('base','B')*u_elev;
        x = x + dt*xdot;
        uGauge.Value = x(1);
        wGauge.Value = x(2);
        qGauge.Value = x(3);
        tGauge.Value = x(4);
        shift = x(4)*2;
        yc = sin(ang);
        gy = yc; gy(gy>shift)=shift;
        hGround.YData = gy;
        hLine.YData = [shift shift];
    end

    function stopSim()
        if ~isempty(SimTimer) && isvalid(SimTimer)
            stop(SimTimer);
            delete(SimTimer);
        end
    end

end