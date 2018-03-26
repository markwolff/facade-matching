clear all
close all
addpath('./export_fig')
load(('hull_space.mat'));
ALPHA = .55;
figure(1), 
plot3(0,0,0,'k.', 'MarkerSize', 50);%plot3(nyc_f1, nyc_f2, nyc_f3, 'r*'), 
hold on
K = convhull(nyc_f1, nyc_f2, nyc_f3);
h1=surf(nyc_f1(K), nyc_f2(K), nyc_f3(K));
h1.FaceColor = 'red';
h1.EdgeColor = [0 0 0];
h1.FaceAlpha = ALPHA;


%plot3(sf_f1, sf_f2, sf_f3, 'g*'), 
hold on
K = convhull(sf_f1, sf_f2, sf_f3);
% nyc_f3 = nyc_f3 + rand(size(nyc_f3))/5
% nyc_f2 = nyc_f2 + rand(size(nyc_f3))/5
% nyc_f1 = nyc_f1 + rand(size(nyc_f3))/5
h2=surf(sf_f1(K), sf_f2(K), sf_f3(K));
h2.FaceColor = 'green';
h2.EdgeColor = [0 0 0];
h2.FaceAlpha = ALPHA;

%plot3(rome_f1, rome_f2, rome_f3, 'b*'), 
hold on
K = convhull(rome_f1, rome_f2, rome_f3);
h3=surf(rome_f1(K), rome_f2(K), rome_f3(K));
h3.FaceColor = 'blue';
h3.EdgeColor = [0 0 0];
h3.FaceAlpha = ALPHA;


xlim([0 1]), ylim([0 1]), zlim([0 1]);
hold on
ylabel('Sum Shape Context Cost');
xlabel('Sum Color Information Gain');
zlabel('Sum Texture Cost');
set(gcf,'Color','w');
set(gca, 'BoxStyle', 'full')
box on
grid on
%legend({'NYC Matched Facade','SF Matched Facade','Rome Matched Facade','Aerial Facade'})
n = 1;
get(gca, 'View')
set(gcf, 'Position', [300 300 850 600]);
views = [-37.5, 30; -37.5+45, 50; -37.5+5, 80];
for i = 1 : 3
        view(views(i,:));
        h1.FaceAlpha = 1.0;
        h2.FaceAlpha = .05;
        h3.FaceAlpha = .05;
%         export_fig(sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.png', n));
%         saveas(gcf,sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.fig', n));
        input('Press 1 then enter to show more...\n');
        n = 1 + n;
        h1.FaceAlpha = .05;
        h2.FaceAlpha = 1.0;
        h3.FaceAlpha = .05;
%         export_fig(sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.png', n));
%         saveas(gcf,sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.fig', n));
        input('Press 1 then enter to show more...\n');
        n = 1 + n;
        h1.FaceAlpha = .05;
        h2.FaceAlpha = .05;
        h3.FaceAlpha = 1.0;
%         export_fig(sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.png', n));
%         saveas(gcf,sprintf('C:/Users/mrw5329/Dropbox/Mark_Wolff/CVPR2016/graphics/all_3d_hull_%d.fig', n));
        n = 1 + n;
        input('Press 1 then enter to show more...\n');
    
end

% NYC       = .156 +/- .099
% SF        = .172 +/- .106
% Rome      = .197 +/- .129
