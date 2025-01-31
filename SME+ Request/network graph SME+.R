folder<-'Graph 2212'
#setwd(sprintf('C:/Users/MR38804/Documents/Network Graph',folder))
require(visNetwork)
require(igraph)
require(htmlwidgets)
entity_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/SME+ Request/%s/SME+ 50_entityV3_id.csv',folder))
transfer_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/SME+ Request/%s/SME+ 50_transV3_id.csv',folder))
ext_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/SME+ Request/%s/SME+ 50_extV3_id.csv',folder))
cust_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/SME+ Request/%s/SME+ 50_custV3_id.csv',folder))
#setwd(sprintf('C:/Users/MR38804/Documents/Network Graph/%s',folder))
nodes<-data.frame(id=entity_id$ID,
                  label=entity_id$ENTITY,
                  group=entity_id$TYPE,
                  source = entity_id$SOURCE,
                  shape=entity_id$SHAPE,
                  color=entity_id$COLOR,
                  entity = entity_id$ENTITY,
                  title=paste(entity_id$ENTITY,
                              entity_id$GCIF,
                              paste(entity_id$ORIG_AMOUNT/1e9, " Bio IDR"),
                              sep = " | "))
edges<-data.frame(from=transfer_id$FROM_ID,to=transfer_id$TO_ID,
                  title=paste(transfer_id$AMOUNT,' Bio IDR'),color=c('black'),
                  arrows=c('middle'), width = 0.00000001)
lnodes<-data.frame(label=c("MBI Out", "MBI In", "MBI Both",
                           "Non MBI Out", "Non MBI In", "Non MBI Both",
                           "SME+", "BB", "GB", "RSME", "External"),
                   shape=c("triangleDown", "triangle", "star", "diamond", "square", "hexagon",
                           "dot", "dot", "dot", "dot", "dot"),
                   color=c("black", "black", "black", "black", "black", "black",
                           "orange", "#977dab", "#5c70a1", "#a15c5c", "#ff0000"))
#graph <- graph.data.frame(edges)
#degree_value <- degree(graph)
#degree_value <- 0.00001*degree_value
#nodes$value <- degree_value[match(nodes$id, names(degree_value))]
result=visNetwork(nodes,edges,main=sprintf('SME+ Top 50 Funding Entities - Cash Flow Graph %s',folder),
                  height='750px',width='100%')%>%
  visOptions(highlightNearest=list(enabled = TRUE, 
                                   degree = 1, 
                                   algorithm='hierarchical'),
             nodesIdSelection=list(enabled=T,values=cust_id$ID, 
                                   style='width: 160px; height: 26px', main='MBI Customer (SME+)'),
             selectedBy=list(variable='entity',values=ext_id$ENTITY, style='width: 160px; height: 26px',
                             main='Potential NTB Names', highlight=TRUE))%>%
  visPhysics(solver = "forceAtlas2Based",
             stabilization = FALSE,
             forceAtlas2Based = list(gravitationalConstant = -500,
                                     avoidOverlap = 0),
             maxVelocity = 200,
             minVelocity = 5,
             adaptiveTimestep = TRUE)%>%
  visInteraction(dragView=TRUE,dragNodes=TRUE)%>%
  visLegend(addNodes=lnodes, ncol=2, useGroups=FALSE)
htmlwidgets::saveWidget(result,(sprintf('C:/Users/MR38804/Documents/Network Graph/SME+ Request/%s/result_%sv3_SME+ Funding Top 50.html',folder,folder)),selfcontained=TRUE)
