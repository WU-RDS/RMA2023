if(!"packrat" %in% installed.packages()) install.packages("packrat")

output <- file("aux_setup_packages.R", "w")
non_standard_installs <- '
if(!"tufte" %in% installed.packages()) install.packages("tufte")
if(!"BiocManager" %in% installed.packages()) install.packages("BiocManager")
if(!"EBImage" %in% installed.packages()) BiocManager::install("EBImage")
if(!"devtools" %in% installed.packages()) install.packages("devtools")
if(!"robCompositions" %in% installed.packages()) devtools::install_github("matthias-da/robCompositions")
'
write(non_standard_installs, output, append = TRUE)

standard_installs <- c(packrat:::dirDependencies("."), packrat:::dirDependencies("Code"))
standard_installer <- "lapply(function(x) install.packages(x), standard_installs[!standard_installs %in% installed.packages()])\n"
dump("standard_installs", file = output, append = TRUE)
write(standard_installer, file = output, append = TRUE)
close(output)
