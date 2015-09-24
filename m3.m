function VideoInCustomGUIExample()
videoSrc = vision.VideoFileReader('vipmen.avi', 'ImageColorSpace', 'Intensity');
[hFig, hAxes] = createFigureAndAxes();
insertButtons(hFig, hAxes, videoSrc);
playCallback(findobj('tag','PBButton123'),[],videoSrc,hAxes);
end