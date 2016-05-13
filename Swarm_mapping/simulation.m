classdef simulation < handle
    %BOT a robot that can map
    
    properties
        bot_list;
        target_list = [10,10]
        true_occupancy_grid;
        background;
        mothership_loc;
        stepDelay;
        stepSize;
        numBots;
        display_axes;
        
        bot_color = [160,32,240];
        mothership_color = [65,105,225];
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
               obj.bot_list(i).newFinds = [];
           end
           for i = 1:size(newFinds,2);
              obj.background(newFinds(1,i),newFinds(2,i)) = obj.background(newFinds(1,i),newFinds(2,i)) + 1;
           end 
        end
        
        function [] = draw(obj)
           obj.updateBackground();
           blackIndicies = find(obj.true_occupancy_grid == 1);          
           r = floor(255*(obj.numBots - obj.background)/obj.numBots);  r(blackIndicies) = 0;
           g = 255 - r(:,:,1); g(blackIndicies) = 0;
           img(:,:,1) = uint8(r); img(:,:,2) = uint8(g); img(:,:,3) = uint8(0);           
           
           for i = 1:obj.numBots %displaying robots
                cp = obj.bot_list(i).currentPos;
                img(cp(1),cp(2),:) = obj.bot_color;
           end
           img(obj.mothership_loc(1),obj.mothership_loc(2),:) = obj.mothership_color;
           
           imshow(img, 'parent',obj.display_axes);
           set(obj.display_axes,'Visible','on');          
        end
        
        function [] = step(obj)
            for i = 1:obj.stepSize
                i
                obj.target_list
                for j = 1:obj.numBots
                    obj.target_list =obj.bot_list(j).move(obj.true_occupancy_grid,obj.bot_list,obj.target_list);
                end % bot looping
                obj.draw();
                drawnow;
            end % step looping            
        end % step functoin
    end % method definitions
end % function definition

