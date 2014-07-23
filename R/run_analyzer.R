#'@title Runs Lake Analyzer on remote server for GLM outputs
#'@description 
#'This function runs Lake Analyzer server according to the files created (e.g., *.lke, *.wtr, etc).  \cr
#'
#'
#'@param lake_name a string for the name of the lake (used in *.lke file naming)
#'@param folder a string for the folder path of the Lake Analyzer files (e.g., *.lke)
#'@param folder_out a string for the destination of results output
#'@return path_out a string with the file path to the output results
#'@keywords methods
#'@author
#'Luke A. Winslow, Jordan S. Read
#'@seealso \link{write_lke}
#'@examples 
#'file_path <- run_analyzer(lake_name='lake',folder='../resources/', 
#'                          folder_out='../resources/')
#'@export
#'@import RCurl
run_analyzer	<-	function(lake_name='lake', folder='../resources/', folder_out='../Supporting Files'){
	require(RCurl)
  
  zip_path <- zip_LA(lake_name, folder, folder_out)
	file_h	<-	postForm("http://lakeanalyzer.gleon.org/postRunModel.php",
	          runzip = fileUpload(zip_path), binary=TRUE)
	# now move file_h to destFldr
  attributes(file_h) = NULL
  path_out <- file.path(folder_out,'output.zip')
  
	writeBin(file_h, path_out)
  
  return(path_out)
}


zip_LA  <-	function(lake_name='lake',folder='../resources/',folder_out='../resources/'){
  # finds all folders in the directory, zips and moves to destFldr. Fails w/o .lke file
  files	<-	list.files(folder,pattern=lake_name,full.names=TRUE)
  if (!any(grepl(pattern = '.lke',files))){stop("need *.lke file for zip")}
  
  zip_file	<-	paste(c(folder_out,lake_name),collapse='')
  zip(zip_file,files)
  return(paste(zip_file,'.zip',sep=''))
  # return success message?
}