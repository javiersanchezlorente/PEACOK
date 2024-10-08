\name{init.variable.lists}
\alias{init.variable.lists}
\title{
Load the variable information and data code information files
}
\description{
Load the variable information and data code information files
}
\usage{
init.variable.lists(variablelistfile, datacodingfile)
}
\arguments{
  \item{variablelistfile}{
  the input phenotype variable list file
}
  \item{datacodingfile}{
  the input data coding file for the DATA_CODING field for phenotypre
}
}
\details{
Load the variable information and data code information files
}
\value{
  return a list contain with two variables:
  \item{phenoInfo }{A data frame that holds information about phenotype varibles from UKB}
  \item{dataCodeInfo }{A data frame that provides further information about the DATA_CODING field of a phenotype from phenoInfo }
}

\examples{
  #vl <- init.variable.lists(opt$variablelistfile, opt$datacodingfile)
}
