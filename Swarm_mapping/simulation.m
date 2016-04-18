classdef simulation < handle
    %BOT a robot that can map
    
    properties
        bot_list;
        true_occupancy_grid;
        background;
        mothership_loc;
        stepDelay;
        stepSize;
        numBots;
        display_axes;
    end
    
    methods
        function obj = simulation(handles)       
            obj.mothership_loc = str2num(get(handles.start_loc_edit,'string'));
            obj.stepSize = str2num(get(handles.step_edit,'string'));
            obj.stepSize = str2num(get(handles.sleep_edit,'string'));
            obj.numBots = str2num(get(handles.num_bots_edit,'string'));
            obj.display_axes = handles.display_axes;
            
            img = imread(get(handles.map_path_edit,'string'));
            img = rgb2gray(img);
            obj.true_occupancy_grid = ones(size(img));
            obj.true_occupancy_grid(find(img == 0)) = 0;
            
            obj.background = zeros(size(obj.true_occupancy_grid));
            
            for i = 1:obj.numBots
                %add a bot to the bot list
            end
            
            obj.draw();
        end
        
        function [] = updateBackground(obj)
          newFinds = [];
           for i = 1:obj.numBots
               % access bot from obj.bots, then map = bot.map;
               newFinds = [newFinds,bot.newFinds];
               bot.newFinds = [];
           end
           for i = 1:size(newFinds,2);
              background(newFinds(1,i),newFinds(2,i)) = background(newFinds(1,i),newFinds(2,i)) + 1;
           end 
        end
        
        function [] = draw(obj)
           obj.updateBackground();
           
           img(:,:,1) = floor(255*(obj.numBots - obj.background)/obj.numBots);
           img(:,:,2) = 255 - img(:,:,1);
           img(:,:,3) = 0;
           
           img = insertShape(img, 'FilledCircle', [obj.mothership_loc(1) obj.mothership_loc(2) 5], 'Color', [0,0,255]);
           imshow(img, 'parent',obj.display_axes);
           set(obj.display_axes,'Visible','on');          
        end
        
        function [] = step(obj)
            for i = 1:obj.stepSize
                for j = 1:obj.numBots
                    % access bot from obj.bots, then call bot.move();                   
                end % bot looping
                obj.draw(true_occupancy_grid);
            end % step looping            
        end % step functoin
    end % method definitions
end % function definition

