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
            obj.stepDelay = str2num(get(handles.sleep_edit,'string'));
            obj.numBots = str2num(get(handles.num_bots_edit,'string'));
            obj.display_axes = handles.display_axes;
            
            img = imread(get(handles.map_path_edit,'string'));
            img = rgb2gray(img);
            obj.true_occupancy_grid = ones(size(img));
            obj.true_occupancy_grid(find(img > 0)) = 0;
            
            obj.background = zeros(size(obj.true_occupancy_grid));
            
            obj.bot_list = [];
            for i = 1:obj.numBots
                bot = BOT(obj.mothership_loc,obj.mothership_loc,obj.true_occupancy_grid);
                obj.bot_list = [obj.bot_list, bot];
            end
            
            obj.draw();
        end
        
        function [] = updateBackground(obj)
          newFinds = [];
           for i = 1:obj.numBots
               newFinds = [newFinds,obj.bot_list(i).newFinds];
               bot.newFinds = [];
           end
           for i = 1:size(newFinds,2);
              background(newFinds(1,i),newFinds(2,i)) = background(newFinds(1,i),newFinds(2,i)) + 1;
           end 
        end
        
        function [] = draw(obj)
           obj.updateBackground();
           blackIndicies = find(obj.true_occupancy_grid == 0);          
           r = floor(255*(obj.numBots - obj.background)/obj.numBots);
           r(blackIndicies) = 0;
           g = 255 - r(:,:,1);
           g(blackIndicies) = 0;
           img(:,:,1) = r; img(:,:,2) = g; img(:,:,3) = 0;           
           
           img = insertShape(img, 'FilledCircle', [obj.mothership_loc(1) obj.mothership_loc(2) 5], 'Color', [0,0,255]);
           imshow(img, 'parent',obj.display_axes);
           set(obj.display_axes,'Visible','on');          
        end
        
        function [] = step(obj)
            for i = 1:obj.stepSize
                for j = 1:obj.numBots
                    obj.bot_list(j).move();
                end % bot looping
                obj.draw();
            end % step looping            
        end % step functoin
    end % method definitions
end % function definition

