
vec1 = [0 0 1 1 1 1 1 1 1 1 0 0];
vec2 = [0 0 1 1 1 1 1 0 0];
myAnimation(vec1, vec2);
function myAnimation(vec1, vec2)
    t3 = -20:1:20; % create vector that will be our time axis.
    
    % Create figure with two subplots a1 and a2
    fig = figure;
    get(fig);
    set(gca,'XGrid','on','YGrid','on')
    set(gcf,'NumberTitle','off','Name','Convolution Animation');
    %top subplot
    a1 = subplot(2,1,1);
    vec1_start_index = ceil((length(t3) - length(vec1))/2) + 1;
    %plot vec1 in the middle of t axis
    Pr= plot(t3(vec1_start_index : vec1_start_index + length(vec1) - 1), vec1, 'r','LineWidth',2);
    hold on;
    grid on;
    xlim(a1,[-20,20]);
    ylim(a1,[0,1.2]);
    %plot vec2 on the right side of the t axis
    Pb = plot(t3(1:length(vec2)), vec2, 'b','LineWidth',2);
    ar= area(t3(1:length(vec2)), vec2,'FaceColor','none','EdgeColor','none');
    xlabel('Time');
    ylabel('Amplitude');
    legend('vec1', 'vec2');
    title('Press any key to start the animation!');
    pause;
    % bottom subplot of the result
    a2= subplot(2,1,2);
    xlabel('Time');
    ylabel('Amplitude');
    title('Convolution Result');
    xlim(a2,[-20,20]);
    ylim(a2,[0,7]);
    grid on;
    hold on;
    % Calculate convolution result
    result = myConv(vec1, vec2);
    %define range of result
    x = -(length(result)-1)/2 : (length(result)-1)/2;
    %create animation line object
    h = animatedline('LineWidth', 2);
    %create index for result animation
    j = 1;
    %create index for background change of vec1
    k = 1;
    % Animation loop
    for i = 1:length(t3) - length(vec2) + 1
        subplot(a1);
        % Move vec2 on the t3-axis from left to right over vec1
        XData = t3(i:i+length(vec2)-1);
        set(Pb, 'XData', XData, 'YData', vec2);
               
        %when vec1 and vec2 meet
        if i >= vec1_start_index-length(vec2)+1
            %change background of vec1 into yellow depending on index k
            subplot(a1);
            hold on;
            legend(a1, [Pr, Pb], {'vec1', 'vec2'});
            if k < length(vec2)
            set(ar,'Xdata',t3(vec1_start_index:vec1_start_index +k-1),'Ydata',vec2(1:k),'FaceColor','yellow','EdgeColor','none');
            k= k+1;
            
            elseif k>=length(vec2) && k<= length(vec1)
            set(ar,'Xdata',t3(vec1_start_index+k-length(vec2):vec1_start_index + k - 1),'Ydata',vec2,'FaceColor','yellow','EdgeColor','none');
            k=k+1;
            elseif k > length(vec1)
             % Reduce the background color of vec2
            x_3 = t3(vec1_start_index:vec1_start_index + length(vec2) - (k - length(vec1)) - 1);
            y_3 = vec2(1:length(vec2) - (k - length(vec1)));
            set(ar, 'Xdata', x_3, 'Ydata', y_3, 'FaceColor', 'yellow', 'EdgeColor', 'none');
            k = k + 1;
            end
            %Animated line of the conv result
            subplot(a2);
            hold on;
            legend('Convolution Result');
            if j < length(result)
            addpoints(h, x(j), result(j));
            j = j + 1;
            else
            addpoints(h,x(j),0);
            end
        end
        pause(0.2);
        drawnow; 
    end   
end
%function to calculate convolution of 2 vectors in discrete time.
function result = myConv(vec1, vec2)
    x = vec1'.*vec2;
    L_1 = length(vec1);
    L_2 = length(vec2);
    M = L_1 + L_2;
    x = fliplr(x);
    result = zeros(1, M-1);
    for n = 1:M-1
     result(M-n) = sum(diag(x, n-L_1));
    end 
end
