function [] = dispImg(handles)
    img = imread(get(handles.map_path_edit,'string'));
    pos = str2num(get(handles.start_loc_edit,'string'));
    img(pos(1),pos(2),1) = 160;
    img(pos(1),pos(2),2) = 32;
    img(pos(1),pos(2),3) = 240;
    
    imshow(img, 'parent',handles.display_axes);
    set(handles.display_axes,'Visible','on');
end