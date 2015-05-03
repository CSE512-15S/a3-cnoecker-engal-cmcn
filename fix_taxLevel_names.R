options(stringsAsFactors = F)
library(data.table)

args = commandArgs(trailingOnly = T)
tax_level = args[1]
display_height = 550

donorA = fread(paste0("DonorA_",tax_level,".txt"))
donorB = fread(paste0("DonorB_",tax_level,".txt"))
Anames = names(donorA)
Bnames = names(donorB)

allnames = union(names(donorA), names(donorB)) ## union preserves order
allnames = allnames[allnames != "Timepoint"]
# count = 1
# for(j in 1:length(names(donorA))){
#   if(names(donorA)[j]=="unknown"){
#     newnames[j] = paste0("unknown", count)
#     count = count + 1
#   }
# }
# setnames(donorA, newnames)

# for(j in 1:length(newnames)){
#   if(!(newnames[j] %in% names(donorA))){
#     donorA[,newCol:= rep(0)]
#     setnames(donorA, "newCol", newnames[j])
#   }
#   if(!(newnames[j] %in% names(donorB))){
#     donorB[,newCol:= rep(0)]
#     setnames(donorB, "newCol", newnames[j])
#   } 
# }
# donorA = donorA[,c("Timepoint", newnames),with=F]
# donorB = donorB[,c("Timepoint", newnames),with=F]
# 

all_maxes = data.table(Taxa = allnames, Amaxes = apply(donorA[,allnames,with=F], 2, max),
                       Bmaxes = apply(donorB[,allnames,with=F], 2, max))
all_maxes[,overallMax:= ifelse(Amaxes > Bmaxes, Amaxes, Bmaxes)]
good_taxa = all_maxes[overallMax >= 1/display_height, Taxa]

donorA = donorA[,c("Timepoint", good_taxa), with=F]
donorB = donorB[,c("Timepoint", good_taxa), with=F]

write.table(donorA, file = paste0("DonorA_",tax_level,".txt"), sep = "\t", quote=F, row.names=F)
write.table(donorB, file = paste0("DonorB_",tax_level,".txt"), sep = "\t", quote=F, row.names=F)

######################
#all_taxa_key = data.table()

