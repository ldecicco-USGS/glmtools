#'@title plot water temperatures from a GLM simulation
#'@param file a string with the path to the netcdf output from GLM
#'@param reference a string for 'surface' or 'bottom'
#'@param num_cells number of vertical cells to use for heatmap
#'@param fig_path F if plot to screen, string path if save plot as .png
#'@keywords methods
#'@seealso \link{get_temp}
#'@author
#'Jordan S. Read, Luke A. Winslow
#'@examples 
#'file <- system.file('extdata', 'output.nc', package = 'glmtools')
#'plot_temp(file = file, fig_path = FALSE)
#'plot_temp(file = file, fig_path = '../test_figure.png')
#'@export
plot_temp <- function(file, reference = 'surface', num_cells = 100, fig_path = F){

  surface <- get_surface_height(file)
  max_depth <- max(surface[, 2])
  min_depth <- 0
  z_out <- seq(min_depth, max_depth,length.out = num_cells)
  temp <- get_temp(file, reference = reference, z_out)
  palette <- colorRampPalette(c("violet","blue","cyan", "green3", "yellow", "orange", "red"), 
                              bias = 1, space = "rgb")
  levels <- seq(0, 36, 1)
  colors <- palette(n = length(levels)-1)
  dates <- temp[, 1]
  wtr_temps <- data.matrix(temp[, -1])
  xaxis <- get_xaxis(dates)
  yaxis <- get_yaxis(z_out, reference)
  
  if (is.character(fig_path)){
    gen_default_fig(file_name = fig_path) 
  }

  
  plot_layout(xaxis, yaxis)
  .filled.contour(x = dates, y = z_out, z = wtr_temps,
                  levels= levels,
                  col=colors)
  
  axis_layout(xaxis, yaxis) #doing this after heatmap so the axis are on top
  color_key(levels, colors, subs=seq(4,32,2))
  if (is.character(fig_path)){
    dev.off()
  }
}

plot_layout <- function(xaxis, yaxis){
  panels = matrix(c(rep(1,5),2), nrow = 1)
  
  layout(panels)
  
  plot(NA, xlim = xaxis$lim,
       ylim=yaxis$lim,
       xlab=xaxis$x_lab, ylab=' ',
       frame=FALSE,axes=F,xaxs="i",yaxs="i")
  
  
}

axis_layout <- function(xaxis, yaxis){
  # x axis
  axis(side = 1, labels=format(xaxis$vis_time, xaxis$time_form), at = xaxis$vis_time, tck = -0.01, pos = yaxis$lim[1])
  axis(side = 3, labels=NA, at = xaxis$lim, tck = 0)
  axis(side = 2, at = yaxis$ticks, tck = -0.01, pos = xaxis$lim[1])
  ol_par <- par()$mgp
  par(mgp=c(0,1.5,0))
  axis(side = 2, at = mean(yaxis$lim), tck = 0,  labels=yaxis$title)
  par(mgp=ol_par)
  axis(side = 4, labels=NA, at = yaxis$lim, tck = 0)
}
