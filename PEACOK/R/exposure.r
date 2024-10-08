# The MIT License (MIT)
# Copyright (c) 2017 Louise AC Millard, MRC Integrative Epidemiology Unit, University of Bristol
# Copyright (c) 2020 Quanli Wang, Center for Genomic Research, AstraZeneca
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without
# limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions
# of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.


# returns boolean var - whether this field denotes the trait of interest, as specified
# in the variable information file
# to determine if values of cat mult fields (not the whole field) are exposure values, use getIsCatMultExposure function instead.
get.is.exposure <- function(vl, varName) {
    idx <- which(vl$phenoInfo$FieldID==varName)
    isExposure <- vl$phenoInfo$TRAIT_OF_INTEREST[idx]
    return(!is.na(isExposure) && isExposure=="YES")
}

# looks up categorical multiple field in the variable info file, return
# whether field has YES in TRAIT_OF_INTEREST column (i.e. all values in 
# this field denote the exposure), or whether varName has varValue stated 
# as a trait of interest in the TRAIT_OF_INTEREST column (multiple values are
# separated by "|" in this field
.getIsCatMultExposure <- function(vl, varName, varValue) {
    # get row index of field in variable information file
    idx <- which(vl$phenoInfo$FieldID==varName)
    # may be empty of may contain VALUE1|VALUE2 etc .. to denote those
    # cat mult values denoting exposure variable
    isExposure <- vl$phenoInfo$TRAIT_OF_INTEREST[idx]
    if (!is.na(isExposure) && isExposure!="") {
        isExposure <- as.character(isExposure)
        ## first check if value is YES, then all values are exposure traits
        if (isExposure == "YES") {
            cat("IS_CM_ALL_EXPOSURE || ")
            return(TRUE)
        }
      
        ## try to split by |, to set particular values as exposure
        # split into variable Values
        exposureValues = unlist(strsplit(isExposure,"\\|"))
        # for each value stated, check whether it is varValue
        for (thisVal in exposureValues) {
            if (thisVal == varValue) {
                cat("IS_CM_EXPOSURE || ")
                return(TRUE)
            }
        }
    }
    
    # varValue is not in list of exposure values
    return(FALSE)
}

# looks up categorical multiple field in the variable info file, return
# number of values denoted as trait of interest.
# returns zero if whole field is denoted trait of interest, not particular values.
.getNumValuesCatMultExposure <- function(vl, varName) {
    # get row index of field in variable information file
    idx <- which(vl$phenoInfo$FieldID==varName)
    # may be empty of may contain VALUE1|VALUE2 etc .. to denote those
    # cat mult values denoting exposure variable
    isExposure <- vl$phenoInfo$TRAIT_OF_INTEREST[idx]
    if (!is.na(isExposure) & isExposure!="") {
        isExposure <- as.character(isExposure)
        ## first check if value is YES, then no partic values are traits of interest
        if (isExposure == "YES") {
            return(0)
        }
        ## try to split by |, to set particular values as exposure
        # split into variable Values
        exposureValues <- unlist(strsplit(isExposure,"\\|"))
        return(length(exposureValues))
    }
    # varValue is not in list of exposure values
    return(0)
}
