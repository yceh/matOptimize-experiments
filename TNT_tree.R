# based on Rob's binarize, adjust taxa name to TNT's liking, and stop TNT from complaining unbalanced parenthesis
args = commandArgs(trailingOnly=TRUE)

library(ape)

tree.filename = args[1]

tree = read.tree(tree.filename)
tree$tip.label<-sapply(tree$tip.label,function(x){
	temp1=strsplit(x,'|',fixed=T)[[1]];
	temp=strsplit(temp1[1],'/',fixed=T)[[1]];
	if(length(temp)>1){
		return (gsub('-','_',fixed=T,temp[2]));
	}else{
		return (gsub('-','_',fixed=T,temp[1]));
	}
});
tree = collapse.singles(tree)
write.table(tree$tip.label,file="samples",row.names=F,col.names=F,quote=F)
write.tree(tree, tree.filename)
