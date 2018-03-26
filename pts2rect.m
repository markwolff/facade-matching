function rect = pts2rect(pts)

    xmin = min(pts(:,1));
    ymin = min(pts(:,2));
    xmax = max(pts(:,1));
    ymax = max(pts(:,2));

    rect = [xmin ymin xmax-xmin ymax-ymin];
end