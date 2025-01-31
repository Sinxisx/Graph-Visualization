folder<-'Graph 2208'
#setwd(sprintf('C:/Users/MR38804/Documents/Network Graph',folder))
require(visNetwork)
require(igraph)
require(htmlwidgets)
entity_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/GB Request/%s/GB Top_entity_id.csv',folder))
transfer_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/GB Request/%s/GB Top_trans_id.csv',folder))
debtor_id<-read.csv(sprintf('C:/Users/MR38804/Documents/Network Graph/GB Request/%s/GB Top_debtor_id.csv',folder))
#setwd(sprintf('C:/Users/MR38804/Documents/Network Graph/%s',folder))
nodes<-data.frame(id=entity_id$ID,
                  label=entity_id$ENTITY,
                  group=entity_id$TYPE,
                  source = entity_id$SOURCE,
                  shape=entity_id$SHAPE,
                  color=entity_id$COLOR,
                  flag_filter = entity_id$LOB,
                  title=paste(entity_id$ENTITY,
                              entity_id$GCIF,
                              paste(entity_id$ORIG_AMOUNT/1e9, " Bio IDR"),
                              sep = " | "))
edges<-data.frame(from=transfer_id$FROM_ID,to=transfer_id$TO_ID,
                  title=paste(transfer_id$AMOUNT,' Bio IDR'),color=c('black'),
                  arrows=c('middle'), width = 0.00000001)
lnodes<-data.frame(label=c("MBI Out", "MBI In", "MBI Both",
                           "Non MBI Out", "Non MBI In", "Non MBI Both",
                           "GB", "BB", "SME+", "RSME", "External"),
                   shape=c("triangleDown", "triangle", "star", "diamond", "square", "hexagon",
                           "dot", "dot", "dot", "dot", "dot"),
                   color=c("black", "black", "black",
                           "black", "black", "black",
                           "orange", "#977dab", "#5c70a1", "#a15c5c", "#ff0000"))
#graph <- graph.data.frame(edges)
#degree_value <- degree(graph)
#degree_value <- 0.00001*degree_value
#nodes$value <- degree_value[match(nodes$id, names(degree_value))]
result=visNetwork(nodes,edges,main='Top GB Funding Entities - Cash Flow Graph',
                  height='750px',width='100%')%>%
  visOptions(highlightNearest=list(enabled = TRUE,
                                   degree = 1),
             nodesIdSelection=list(enabled=T,values=debtor_id$ID),selectedBy='flag_filter')%>%
  visPhysics(solver = "forceAtlas2Based",
             stabilization = TRUE,
             forceAtlas2Based = list(gravitationalConstant = -500,
                                     avoidOverlap = 0),
             maxVelocity = 200,
             minVelocity = 5,
             adaptiveTimestep = TRUE)%>%
  visInteraction(dragView=TRUE,dragNodes=TRUE)%>%
  visLegend(addNodes=lnodes, ncol=2, useGroups=FALSE)
htmlwidgets::saveWidget(result,(sprintf('C:/Users/MR38804/Documents/Network Graph/GB Request/%s/result_%sv1_GB Top 50.html',folder,folder)),selfcontained=TRUE)
