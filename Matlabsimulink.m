load ColdValveSteps.lvm
figure(1)
plot(ColdValveSteps(:,1)-ColdValveSteps(1,1),ColdValveSteps(:,3),'r-','LineWidth',2)
hold on
plot(ColdValveSteps(:,1)-ColdValveSteps(1,1),ColdValveSteps(:,2),'b--','LineWidth',2)
title('My Plot','FontSize',14)
xlabel('Time (s)','FontSize',13)
axis([0 20 0 30])
ylabel('Temperature (^[\circ]C)','FontSize',13)
legend('Desired Temperature', 'Measured Temperature')
