% Generated by roxygen2 (4.0.2): do not edit by hand
\name{run_analyzer}
\alias{run_analyzer}
\title{Runs Lake Analyzer on remote server for GLM outputs}
\usage{
run_analyzer(lake_name = "lake", folder = "../resources/",
  folder_out = "../Supporting Files")
}
\arguments{
\item{lake_name}{a string for the name of the lake (used in *.lke file naming)}

\item{folder}{a string for the folder path of the Lake Analyzer files (e.g., *.lke)}

\item{folder_out}{a string for the destination of results output}
}
\value{
path_out a string with the file path to the output results
}
\description{
This function runs Lake Analyzer server according to the files created (e.g., *.lke, *.wtr, etc).  \cr
}
\examples{
# -- package up all the files for Lake Analyzer --
folder_out <- system.file('extdata', package = 'glmtools')
nml_file <- system.file('extdata', 'glm.nml', package = 'glmtools')
glm_nml <- read_nml(nml_file)
write_bth(glm_nml, lake_name = 'lake', folder_out = folder_out)
lke <- init_lke()
lake_depth <- max(get_hypsography(glm_nml)[, 1])
lke <- set_lke(lke, arg_name = 'totalDep', arg_val = lake_depth)
write_lke(lke, lake_name = 'lake', folder_out = folder_out)
file = system.file('extdata', 'output.nc', package = 'glmtools')
glm_wind <- get_wind(file)
write_wnd(glm_wind,lake_name='lake',folder_out = folder_out)
z_out <- seq(0,22,1)
glm_temp <- get_temp(file,reference = 'surface',z_out = z_out)
write_wtr(glm_temp,lake_name = 'lake', folder_out = folder_out)

# -- run Lake Analyzer on remote server --
\dontrun{
file_path <- run_analyzer(lake_name='lake',folder=folder_out,
                         folder_out=folder_out)
}
}
\author{
Luke A. Winslow, Jordan S. Read
}
\seealso{
\link{write_lke}, \link{init_lke}, \link{set_lke}
}
\keyword{methods}

