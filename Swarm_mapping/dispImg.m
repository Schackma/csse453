function [] = dispImg(handles)
img = handles.user.background;
pos = str2num(get(handles.start_loc_edit,'string'));
img = insertShape(img, 'FilledCircle', [pos(1) pos(2) 5], 'Color', [0,0,255]);
imshow(img, 'parent',handles.display_axes);
set(handles.display_axes,'Visible','on');
end