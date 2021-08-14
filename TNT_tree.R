# based on Rob's binarize, adjust taxa name to TNT's liking, and stop TNT from complaining unbalanced parenthesis
args = commandArgs(trailingOnly=TRUE)

library(ape)

tree.filename = args[1]

tree = read.tree(tree.filename)
tree = collapse.singles(tree)
write.tree(tree, tree.filename)
